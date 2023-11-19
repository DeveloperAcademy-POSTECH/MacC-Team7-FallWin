//
//  DataManager.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//

import Foundation
import UIKit
import CoreData

final class DataManager {
    static let shared = DataManager()
    
    init() { }
}

// MARK: - Image
extension DataManager {
    func saveImage(_ image: UIImage) -> String? {
        let name = UUID().uuidString
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileUrl = documentUrl.appendingPathComponent(name, conformingTo: .jpeg)
        
        do {
            if let data = image.jpegData(compressionQuality: 1) {
                try data.write(to: fileUrl)
                print(#function, "Image saved at", fileUrl)
                
                return name
                
            } else {
                print(#function, "Cannot compress image")
            }
            
        } catch {
            print(#function, error)
        }
        
        return nil
    }
    
    func loadImage(name: String) -> UIImage? {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileUrl = documentUrl.appendingPathComponent(name, conformingTo: .jpeg)
        
        if FileManager.default.fileExists(atPath: fileUrl.path()) {
            return UIImage(contentsOfFile: fileUrl.path())
            
        } else {
            print(#function, "File not exists at path", fileUrl.path())
        }
        
        return nil
    }
    
    func deleteImage(name: String) -> Bool {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return false
        }
        let fileUrl = documentUrl.appendingPathComponent(name, conformingTo: .jpeg)
        
        do {
            try FileManager.default.removeItem(atPath: fileUrl.path())
            return true
            
        } catch {
            print(#function, error)
        }
        
        return false
    }
    
    func deleteAllData() {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
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
}
