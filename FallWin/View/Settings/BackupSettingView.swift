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
    
    private let backupManager = ICloudBackupManager()
    
    var body: some View {
        VStack(alignment: .center, spacing: 9){
            
            
            VStack(alignment: .leading){
                Text("- 픽다는 사용자가 작성한 일기 데이터를 저장하지 않아요.")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(.textTeritary)
                Text("- 데이터를 안전하게 보관하려면 iCloud에 주기적으로 백업해주세요.")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(.textTeritary)
            }
            .padding(.top, 24)
            
            Spacer()
            
            HStack(spacing: 0) {
                Text("최근 백업: ")
                if let lastBackup = backupManager?.lastICloudBackup {
                    Text(String(format: "%d년 %02d월 %02일 %02d:%02d", lastBackup.year, lastBackup.month, lastBackup.day, lastBackup.hour, lastBackup.minute))
                } else {
                    Text("없음")
                }
            }
            .font(.pretendard(.medium, size: 14))
            .foregroundStyle(.textSecondary)
            
            
            
            Button(action: {
                if let backupManager = backupManager {
                    backupManager.backup { procedure in
                        print(procedure)
                        
                    } onFinish: { result in
                        switch result {
                        case .success:
                            print("backup success")
                            break
                        case .failure(let error):
                            print(error)
                            break
                        }
                    }

                }
                isclickedBackup.toggle()
                Tracking.logEvent(Tracking.Event.A5_2_1_설정뷰_iCloud백업_백업.rawValue)
                print("@Log : A5_2_1_설정뷰_iCloud백업_백업")
            }, label: {
                Text("iCloud 백업")
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
            
            
            Button(action: {
                isclickedRestore.toggle()
                Tracking.logEvent(Tracking.Event.A5_2_2_설정뷰_iCloud백업_복원.rawValue)
                print("@Log : A5_2_2_설정뷰_iCloud백업_복원")
            }, label: {
                Text("iCloud 복원")
                    .font(.pretendard(.semiBold, size: 18))
                    .foregroundStyle(.textOnButton)
                    .frame(maxWidth: .infinity, minHeight: 45)
            })
            .buttonStyle(.borderedProminent)
            .alert(isPresented: $isclickedRestore, content: {
                Alert(title: Text("iCloud 복원")
                    .font(.pretendard(.bold, size: 20))
                      , message: Text("iCloud 복원이 완료되었습니다.")
                    .font(.pretendard(.medium, size: 16))
                      , dismissButton: .default(Text("완료")))
            })
            
        }
        
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], 20)
        .padding(.bottom, 15)
        .padding(.top, 32)
        .padding(.horizontal, 15)
        .navigationTitle("화면 잠금")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    BackupSettingView()
}
