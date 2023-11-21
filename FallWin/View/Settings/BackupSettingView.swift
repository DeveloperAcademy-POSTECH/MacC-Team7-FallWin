//
//  BackupSettingView.swift
//  FallWin
//
//  Created by 최명근 on 11/8/23.
//

import SwiftUI
import ComposableArchitecture
import FirebaseAnalytics

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
                    Text("settings_icloud_message_1")
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(.textSecondary)
                        .multilineTextAlignment(.leading)
                    Text("settings_icloud_message_2")
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(.textSecondary)
                        .multilineTextAlignment(.leading)
                }
                .padding(.top, 0)
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("settings_icloud_recent")
                    if let lastBackup = backupManager?.lastICloudBackup {
                        Text(lastBackup.fullString)
                    } else {
                        Text("settings_icloud_recent_none")
                    }
                }
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(.textTertiary)
                
                
                
                Button(action: backup, label: {
                    Text("settings_icloud_backup")
                        .font(.pretendard(.semiBold, size: 18))
                        .foregroundStyle(.textOnButton)
                        .frame(maxWidth: .infinity, minHeight: 45)
                })
                .buttonStyle(.borderedProminent)
                .alert(isPresented: $isclickedBackup, content: {
                    Alert(title: Text("settings_icloud_backup_alert_title")
                        .font(.pretendard(.bold, size: 20))
                          , message: Text("settings_icloud_backup_alert_message")
                        .font(.pretendard(.medium, size: 16))
                          , dismissButton: .default(Text("done")))
                })
                
                
                Button(action: restore, label: {
                    Text("settings_icloud_restore")
                        .font(.pretendard(.semiBold, size: 18))
                        .foregroundStyle(.textPrimary)
                        .frame(maxWidth: .infinity, minHeight: 45)
                })
                .buttonStyle(.bordered)
                .alert(isPresented: $isclickedRestore, content: {
                    Alert(title: Text("settings_icloud_restore_alert_title")
                        .font(.pretendard(.bold, size: 20))
                          , message: Text("settings_icloud_restore_alert_message")
                        .font(.pretendard(.medium, size: 16))
                          , dismissButton: .default(Text("done")))
                })
                
            }
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 15)
            .padding(.top, 32)
            .padding(.horizontal, 15)
            .alert("settings_icloud_fail_alert_title", isPresented: $errorOccured) {
                Button("confirm") {
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
        .navigationTitle("settings_icloud")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func backup() {
        Tracking.logEvent(Tracking.Event.A5_2_1_설정뷰_iCloud백업_백업.rawValue)
        print("@Log : A5_2_1_설정뷰_iCloud백업_백업")
        DispatchQueue.global().async {
            if let backupManager = backupManager {
                backupManager.backup { procedure in
                    DispatchQueue.main.async {
                        switch procedure {
                        case .fetch:
                            iCloudWorkMessage = "icloud_fetch".localized
                        case .pack:
                            iCloudWorkMessage = "icloud_pack".localized
                        case .upload:
                            iCloudWorkMessage = "icloud_upload".localized
                        case .register:
                            iCloudWorkMessage = "icloud_register".localized
                        case .clean:
                            iCloudWorkMessage = "icloud_clean".localized
                            iCloudWorkMessage = nil
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
                    sleep(1)
                    iCloudWorkMessage = nil
                }
            } else {
                errorMessage = "settings_icloud_permission_error".localized
                errorOccured = true
            }
        }
    }
    
    private func restore() {
        Tracking.logEvent(Tracking.Event.A5_2_2_설정뷰_iCloud백업_복원.rawValue)
        print("@Log : A5_2_2_설정뷰_iCloud백업_복원")
        DispatchQueue.global().async {
            if let backupManager = backupManager {
                backupManager.restore { procedure in
                    DispatchQueue.main.async {
                        switch procedure {
                        case .fetch:
                            iCloudWorkMessage = "icloud_download".localized
                        case .unpack:
                            iCloudWorkMessage = "icloud_unpack".localized
                        case .data:
                            iCloudWorkMessage = "icloud_restore".localized
                        case .image:
                            iCloudWorkMessage = "icloud_restore_image".localized
                        case .clean:
                            iCloudWorkMessage = "icloud_clean".localized
                            iCloudWorkMessage = nil
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
                    sleep(1)
                    iCloudWorkMessage = nil
                    backupManager.cleanTempFolder()
                }
            } else {
                errorMessage = "settings_icloud_permission_error".localized
                errorOccured = true
            }
        }
    }
}

#Preview {
    BackupSettingView()
}
