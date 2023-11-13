//
//  BackupSettingView.swift
//  FallWin
//
//  Created by 최명근 on 11/8/23.
//

import SwiftUI
import ComposableArchitecture

struct BackupSettingView: View {
    @State var isclickedBackup: Bool = false
    @State var isclickedRestore: Bool = false
    @State var errorOccured: Bool = false
    @State var errorMessage: String = ""
    
    @State private var iCloudWorkMessage: String? = nil
    
    private let backupManager = ICloudBackupManager()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 9){
                VStack(alignment: .leading){
                    Text("- 픽다는 사용자가 작성한 일기 데이터를 저장하지 않아요.")
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(.textTertiary)
                    Text("- 데이터를 안전하게 보관하려면 iCloud에 주기적으로 백업해주세요.")
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(.textTertiary)
                }
                .padding(.top, 24)
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("최근 백업: ")
                    if let lastBackup = backupManager?.lastICloudBackup {
                        Text(lastBackup.fullString)
                    } else {
                        Text("없음")
                    }
                }
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(.textSecondary)
                
                
                
                Button(action: backup, label: {
                    Text("백업")
                        .font(.pretendard(.semiBold, size: 18))
                        .foregroundStyle(.textOnButton)
                        .frame(maxWidth: .infinity, minHeight: 45)
                })
                .buttonStyle(.borderedProminent)
                .alert(isPresented: $isclickedBackup, content: {
                    Alert(title: Text("iCloud 백업")
                        .font(.pretendard(.bold, size: 20))
                          , message: Text("iCloud 백업이 완료되었습니다.")
                        .font(.pretendard(.medium, size: 16))
                          , dismissButton: .default(Text("완료")))
                })
                
                
                Button(action: restore, label: {
                    Text("복원")
                        .font(.pretendard(.semiBold, size: 18))
                        .foregroundStyle(.textPrimary)
                        .frame(maxWidth: .infinity, minHeight: 45)
                })
                .buttonStyle(.bordered)
                .alert(isPresented: $isclickedRestore, content: {
                    Alert(title: Text("iCloud 복원")
                        .font(.pretendard(.bold, size: 20))
                          , message: Text("iCloud 복원이 완료되었습니다.")
                        .font(.pretendard(.medium, size: 16))
                          , dismissButton: .default(Text("완료")))
                })
                
            }
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 15)
            .padding(.top, 32)
            .padding(.horizontal, 15)
            .alert("작업 실패", isPresented: $errorOccured) {
                Button("확인") {
                    errorOccured = false
                }
            } message: {
                Text(errorMessage)
            }
            
            
            if let message = iCloudWorkMessage {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        ProgressView()
                        Text(message)
                    }
                    .frame(width: 160, height: 120)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.thinMaterial)
                    )
                }
                .onTapGesture { }
            }
        }
        .navigationTitle("iCloud")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func backup() {
        DispatchQueue.global().async {
            if let backupManager = backupManager {
                backupManager.backup { procedure in
                    DispatchQueue.main.async {
                        switch procedure {
                        case .fetch:
                            iCloudWorkMessage = "데이터 수집"
                        case .pack:
                            iCloudWorkMessage = "데이터 압축"
                        case .upload:
                            iCloudWorkMessage = "업로드"
                        case .register:
                            iCloudWorkMessage = "백업 등록"
                        case .clean:
                            iCloudWorkMessage = "임시 파일 삭제"
                        }
                    }
                    print(procedure)
                    
                } onFinish: { result in
                    switch result {
                    case .success:
                        print("backup success")
                        isclickedBackup = true
                        break
                    case .failure(let error):
                        print(error)
                        errorMessage = error
                        errorOccured = true
                        backupManager.cleanLocalBackupFolder()
                        break
                    }
                    iCloudWorkMessage = nil
                }
            } else {
                errorMessage = "설정에서 iCloud에 로그인한 후 '픽다'가 접근할 수 있도록 허용하십시오."
                errorOccured = true
            }
        }
    }
    
    private func restore() {
        DispatchQueue.global().async {
            if let backupManager = backupManager {
                backupManager.restore { procedure in
                    DispatchQueue.main.async {
                        switch procedure {
                        case .fetch:
                            iCloudWorkMessage = "다운로드"
                        case .unpack:
                            iCloudWorkMessage = "압축 해제"
                        case .data:
                            iCloudWorkMessage = "데이터 복원"
                        case .image:
                            iCloudWorkMessage = "이미지 복원"
                        case .clean:
                            iCloudWorkMessage = "임시 파일 삭제"
                        }
                    }
                    print(procedure)
                    
                } onFinish: { result in
                    switch result {
                    case .success:
                        print("backup success")
                        isclickedRestore = true
                        break
                    case .failure(let error):
                        print(error)
                        errorMessage = error
                        errorOccured = true
                        break
                    }
                    iCloudWorkMessage = nil
                    backupManager.cleanTempFolder()
                }
            } else {
                errorMessage = "설정에서 iCloud에 로그인한 후 '픽다'가 접근할 수 있도록 허용하십시오."
                errorOccured = true
            }
        }
    }
}

#Preview {
    BackupSettingView()
}
