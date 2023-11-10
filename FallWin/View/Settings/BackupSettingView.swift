//
//  BackupSettingView.swift
//  FallWin
//
//  Created by 최명근 on 11/8/23.
//

import SwiftUI
import ComposableArchitecture

struct BackupSettingView: View {
    let store: StoreOf<BackupSettingFeature>
    @State var isclickedBackup: Bool = false
    @State var isclickedRestore: Bool = false
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
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
                
                Text("최근에 성공한 백업: 2023년 10월 16일 9:41")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.textSecondary)
                
                
                  
                Button(action: {
                    isclickedBackup.toggle()
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
            
              
        }
        .navigationTitle("화면 잠금")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    BackupSettingView(store: Store(initialState: BackupSettingFeature.State(), reducer: {
        BackupSettingFeature()
    }))
}
