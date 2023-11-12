//
//  ICloudDataManager.swift
//  FallWin
//
//  Created by 최명근 on 11/10/23.
//

import Foundation
import CoreData
import CloudKit
import ZIPFoundation

// MARK: - Declaration
final class ICloudBackupManager {
    enum BackupResult {
        case success
        case failure(_ error: String)
    }
    
    private let documentUrl: URL
    private let backupFolderUrl: URL
    private let tempFolderUrl: URL
    private let iCloudUrl: URL
    private let iCloudBackupFolderUrl: URL
    private let BACKUP_FILE_EXTENSION = "pcdarchive"
    private let BACKUP_FILE_NAME = "icloud_backup.zip"
    private let BACKUP_DATA_FILE_NAME = "journals.txt"
    private let BACKUP_DATE_KEY = "last_backup"
    private let BACKUP_DIRECTORY = "backups"
    private let TEMP_DIRECTORY = "temp"
    
    /*
     * File Tree
     * {DocumentDirectory}
     *   ⌙ [Images]
     *   ⌙ backups
     *     ⌙ [backup folder]
     *       backup_{date}
     */
    
    init?() {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        self.documentUrl = documentUrl
        
        self.backupFolderUrl = documentUrl.appending(path: BACKUP_DIRECTORY)
        if !FileManager.default.fileExists(atPath: self.backupFolderUrl.path()) {
            do {
                try FileManager.default.createDirectory(at: self.backupFolderUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
                return nil
            }
        }
        
        self.tempFolderUrl = documentUrl.appending(path: TEMP_DIRECTORY)
        if !FileManager.default.fileExists(atPath: self.tempFolderUrl.path()) {
            do {
                try FileManager.default.createDirectory(at: self.tempFolderUrl, withIntermediateDirectories: true)
            } catch {
                print(#function, error)
                return nil
            }
        }
        
        guard let iCloudUrl = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appending(path: "Documents") else {
            return nil
        }
        self.iCloudUrl = iCloudUrl
        self.iCloudBackupFolderUrl = iCloudUrl.appending(path: BACKUP_DIRECTORY)
        if !FileManager.default.fileExists(atPath: self.iCloudBackupFolderUrl.path()) {
            do {
                try FileManager.default.createDirectory(at: self.iCloudBackupFolderUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
                return nil
            }
        }
    }
    
    /// 백업 폴더의 위치를 반환합니다.
    /// (예: {document}/backups/{backupName}
    private func getBackupUrl(backupName: String) -> URL {
        return backupFolderUrl.appending(path: backupName)
    }
    
    /// 백업 파일의 위치를 반환합니다.
    /// (예: {document}/backups/{backupName}/{backupName}.pcdarchive
    private func getBackupFileUrl(backupName: String) -> URL {
        return getBackupUrl(backupName: backupName)
            .appending(path: BACKUP_FILE_NAME)
    }
    
    private func getICloudBackupFileUrl() -> URL {
        return iCloudBackupFolderUrl.appending(path: "\(BACKUP_FILE_NAME)")
    }
    
    var hasICloudBackup: Bool {
        FileManager.default.fileExists(atPath: getICloudBackupFileUrl().path())
    }
    
    var lastICloudBackup: Date? {
        NSUbiquitousKeyValueStore().object(forKey: BACKUP_DATE_KEY) as? Date
    }
    
    func test() {
        print("------- ContentsOfDirectory::document -------")
        do {
            for file in try FileManager.default.contentsOfDirectory(atPath: documentUrl.path()) {
                print(file)
            }
        } catch {
            print(error)
        }
        
        print("------- ContentsOfDirectory::backupFolder -------")
        do {
            for file in try FileManager.default.contentsOfDirectory(atPath: backupFolderUrl.path()) {
                print(file)
            }
        } catch {
            print(error)
        }
        
        print("------- ContentsOfDirectory::Temp -------")
        do {
            for file in try FileManager.default.contentsOfDirectory(atPath: tempFolderUrl.path()) {
                print(file)
            }
        } catch {
            print(error)
        }
        
        print("------- Test finished -------")
    }
}

// MARK: - Backup
extension ICloudBackupManager {
    fileprivate enum LocalBackupResult {
        case local(_ backupName: String)
        case iCloud(_ backupTime: Date)
        case failure(_ error: String)
    }
    
    enum BackupProcedures: Int {
        case fetch
        case pack
        case upload
        case register
        case clean
    }
    
    func backup(onProcess: ((BackupProcedures) -> Void)? = nil, onFinish: @escaping (BackupResult) -> Void) {
        // Clean
        cleanLocalBackupFolder()
        if let onProcess = onProcess { onProcess(.clean) }
        
        // MARK: Fetch
        let journals = fetchJournals()
        guard let journals = journals else {
            print(#function, "Cannot fetch journals")
            onFinish(.failure("백업할 파일을 찾을 수 없습니다."))
            return
        }
        if let onProcess = onProcess { onProcess(.fetch) }
        
        // MARK: Pack
        let pack = pack(journals: journals)
        var backupName: String
        switch pack {
        case .local(let backup):
            backupName = backup
            break
        case .iCloud(_):
            onFinish(.failure("압축 도중 올바르지 않은 절차가 진행되었습니다."))
            return
        case .failure(let error):
            onFinish(.failure(error))
            return
        }
        if let onProcess = onProcess { onProcess(.pack) }
        
        // MARK: Upload
        let upload = uploadBackup(backupName)
        var backupTime: Date
        switch upload {
        case .local(_):
            onFinish(.failure("업로드 도중 올바르지 않은 절차가 진행되었습니다."))
            return
        case .iCloud(let backup):
            backupTime = backup
            break
        case .failure(let error):
            onFinish(.failure(error))
            return
        }
        if let onProcess = onProcess { onProcess(.upload) }
        
        // MARK: Register
        registerBackupToICloud(backupDate: backupTime)
        if let onProcess = onProcess { onProcess(.register) }
        
        // MARK: Clean
        cleanLocalBackupFolder()
        if let onProcess = onProcess { onProcess(.clean) }
        
        onFinish(.success)
    }
    
    private func fetchJournals() -> [Journal]? {
        // 백업할 Journal Fetch
        let context = PersistenceController.shared.container.viewContext
        var journals: [Journal]?
        do {
            let fetchRequest = NSFetchRequest<Journal>(entityName: "Journal")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Journal.timestamp), ascending: false)]
            journals = try context.fetch(fetchRequest)
        } catch {
            print(#function, error)
            journals = nil
        }
        return journals
    }
    
    private func pack(journals: [Journal]) -> LocalBackupResult {
        // [Journal]을 JSON 변환을 위한 [RawJournal]로 변환
        let rawJournals = RawJournal.convert(from: journals)
        var rawJournalJson: String?
        do {
            let rawJournalData = try JSONEncoder().encode(rawJournals)
            rawJournalJson = String(data: rawJournalData, encoding: .utf8)
        } catch {
            print(#function, error)
            rawJournalJson = nil
        }
        
        guard let rawJournalJson = rawJournalJson else {
            print("Cannot convert RawJournal to JSON")
            return .failure("백업 데이터를 변환하는 도중 오류가 발생했습니다.")
        }
        
        // 임시 일기 파일 저장할 디렉토리
        // 임시 일기 파일 생성 날짜
        let backupName = "backup-\(Date().timeInMillis)"
        let backupUrl = getBackupUrl(backupName: backupName)
        if !FileManager.default.fileExists(atPath: backupUrl.path()) {
            do {
                try FileManager.default.createDirectory(at: backupUrl, withIntermediateDirectories: true)
            } catch {
                print(#function, error)
                return .failure("백업 폴더를 만들 수 없습니다.")
            }
        }
        
        // 임시 일기 파일 생성
        do {
            // 임시 일기 파일
            let fileUrl = backupUrl.appendingPathComponent(BACKUP_DATA_FILE_NAME, conformingTo: .text)
            try rawJournalJson.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print(#function, error)
            return .failure("백업 데이터를 작성할 수 없습니다.")
        }
        
        // 이미지 백업
        do {
            for journal in journals {
                if let image = journal.image {
                    let fileUrl = documentUrl.appendingPathComponent(image, conformingTo: .jpeg)
                    let backupUrl = backupUrl.appendingPathComponent(image, conformingTo: .jpeg)
                    if !FileManager.default.fileExists(atPath: backupUrl.path()) {
                        try FileManager.default.copyItem(atPath: fileUrl.path(), toPath: backupUrl.path())
                    }
                }
            }
        } catch {
            print(#function, error)
            return .failure("이미지를 백업하는 도중 오류가 발생했습니다.")
        }
        
        // 백업 파일 압축
        do {
            let destination = backupUrl.appending(path: BACKUP_FILE_NAME)
            if FileManager.default.fileExists(atPath: destination.path()) {
                try FileManager.default.removeItem(at: destination)
            }
            try FileManager().zipItem(at: backupUrl, to: destination, shouldKeepParent: false)
        } catch {
            print(#function, error)
            return .failure("백업 데이터를 압축하는데 실패했습니다.")
        }
        
        return .local(backupName)
    }
    
    private func uploadBackup(_ backupName: String) -> LocalBackupResult {
        do {
            if FileManager.default.fileExists(atPath: getICloudBackupFileUrl().path) {
                print("iCloud backup file removed")
                try FileManager.default.removeItem(at: getICloudBackupFileUrl())
            }
            try FileManager.default.copyItem(at: getBackupFileUrl(backupName: backupName), to: getICloudBackupFileUrl())
        } catch {
            print(#function, error)
            return .failure("백업 파일을 iCloud에 작성할 수 없습니다.")
        }
        
        return .iCloud(Date())
    }
    
    func cleanLocalBackupFolder() {
        do {
            for file in try FileManager.default.contentsOfDirectory(atPath: backupFolderUrl.path()) {
                let item = backupFolderUrl.appendingPathComponent(file)
                try FileManager.default.removeItem(at: item)
            }
        } catch {
            print(#function, error)
        }
    }
    
    private func registerBackupToICloud(backupDate: Date) {
        let store = NSUbiquitousKeyValueStore()
        store.set(backupDate, forKey: BACKUP_DATE_KEY)
    }
}

extension ICloudBackupManager {
    fileprivate enum LocalRestoreResult {
        case success
        case failure(_ error: String)
    }
    
    enum RestoreProcedures: Int {
        case fetch
        case unpack
        case data
        case image
        case clean
    }
    
    func restore(onProcess: ((RestoreProcedures) -> Void)? = nil, onFinish: @escaping (BackupResult) -> Void) {
        // Clean
        cleanTempFolder()
        if let onProcess = onProcess { onProcess(.clean) }
        
        // Fetch
        let fetch = fetch()
        switch fetch {
        case .success:
            break
        case .failure(let error):
            onFinish(.failure(error))
            return
        }
        if let onProcess = onProcess { onProcess(.fetch) }
        
        // Unpack
        let unpack = unpack()
        switch unpack {
        case .success:
            break
        case .failure(let error):
            onFinish(.failure(error))
            return
        }
        if let onProcess = onProcess { onProcess(.unpack) }
        
        // Data
        let restoreData = restoreData()
        switch restoreData {
        case .success:
            break
        case .failure(let error):
            onFinish(.failure(error))
            return
        }
        if let onProcess = onProcess { onProcess(.data) }
        
        // Image
        let restoreImages = restoreImages()
        switch restoreImages {
        case .success:
            break
        case .failure(let error):
            onFinish(.failure(error))
            return
        }
        if let onProcess = onProcess { onProcess(.image) }
        
        // Clean
        cleanTempFolder()
        if let onProcess = onProcess { onProcess(.clean) }
        
        onFinish(.success)
    }
    
    func deletePrevData() {
        do {
            for file in try FileManager.default.contentsOfDirectory(atPath: documentUrl.path()) {
                if file.hasSuffix("jpg") || file.hasSuffix("jpeg") {
                    try FileManager.default.removeItem(at: documentUrl.appending(path: file))
                }
            }
        } catch {
            print(error)
        }
        
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Journal")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print(error)
        }
    }
    
    private func fetch() -> LocalRestoreResult {
        do {
            let destination = tempFolderUrl.appending(path: BACKUP_FILE_NAME)
            try FileManager.default.copyItem(at: getICloudBackupFileUrl(), to: destination)
        } catch {
            print(#function, error)
            return .failure("백업 파일을 다운로드할 수 없습니다.")
        }
        return .success
    }
    
    private func unpack() -> LocalRestoreResult {
        let backupFileUrl = tempFolderUrl.appending(path: BACKUP_FILE_NAME)
        do {
            try FileManager().unzipItem(at: backupFileUrl, to: tempFolderUrl.appending(path: "contents"))
        } catch {
            print(#function, error)
            return .failure("백업 파일을 해제할 수 없습니다.")
        }
        return .success
    }
    
    private func restoreData() -> LocalRestoreResult {
        let rawJournals: [RawJournal]
        do {
            let backupFileUrl = tempFolderUrl.appending(path: "contents").appendingPathComponent(BACKUP_DATA_FILE_NAME, conformingTo: .text)
            guard let data = try String(contentsOf: backupFileUrl, encoding: .utf8).data(using: .utf8) else {
                print("nil data")
                return .failure("데이터를 해석하는데 실패했습니다.")
            }
            rawJournals = try JSONDecoder().decode([RawJournal].self, from: data)
        } catch {
            print(#function, error)
            return .failure("데이터를 해석하는데 실패했습니다.")
        }
        
        if let journals = fetchJournals() {
            for rawJournal in rawJournals {
                if !journals.contains(where: { $0.id == rawJournal.id }) {
                    Journal.insert(rawJournal)
                }
            }
        } else {
            Journal.insert(rawJournals)
        }
        
        return .success
    }
    
    private func restoreImages() -> LocalRestoreResult {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: tempFolderUrl.appending(path: "contents").path())
            for file in files {
                if file.hasSuffix("jpg") || file.hasSuffix("jpeg") {
                    let imageFile = tempFolderUrl.appending(path: "contents").appending(path: file)
                    let destination = documentUrl.appending(path: file)
                    if !FileManager.default.fileExists(atPath: destination.path()) {
                        try FileManager.default.copyItem(at: imageFile, to: destination)
                    }
                }
            }
        } catch {
            print(#function, error)
            return .failure("백업 파일을 읽을 수 없습니다.")
        }
        return .success
    }
    
    func cleanTempFolder() {
        do {
            for file in try FileManager.default.contentsOfDirectory(atPath: tempFolderUrl.path()) {
                let item = tempFolderUrl.appendingPathComponent(file)
                try FileManager.default.removeItem(at: item)
            }
        } catch {
            print(#function, error)
        }
    }
}
