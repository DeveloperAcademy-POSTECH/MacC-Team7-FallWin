//
//  DataSettingsView.swift
//  FallWin
//
//  Created by 최명근 on 11/12/23.
//

import SwiftUI

struct DataSettingsView: View {
    @State private var deleteAlert: Bool = false
    @State private var deleteComplete: Bool = false
    
    var body: some View {
        List {
            Button(role: .destructive) {
                deleteAlert = true
                
            } label: {
                Text("일기 데이터 삭제")
                    .font(.pretendard(size: 18))
                    .padding(.vertical, 8)
            }
            .listRowBackground(Color.backgroundPrimary)
            .confirmationDialog("데이터 삭제", isPresented: $deleteAlert, titleVisibility: .visible, actions: {
                Button("취소", role: .cancel) {
                    deleteAlert = false
                }
                Button("데이터 삭제", role: .destructive) {
                    DispatchQueue.main.async {
                        DataManager.shared.deleteAllData()
                        deleteComplete = true
                    }
                }
            }, message: {
                Text("일기 데이터와 그림을 모두 삭제합니다.\n이 작업은 되돌릴 수 없습니다.\n계속하기 전 iCloud에 데이터가 백업되었는지 확인하십시오.\n\n정말로 삭제합니까?")
            })
            .alert(isPresented: $deleteComplete, title: "데이터 삭제") {
                Text("모든 데이터를 삭제했습니다.\n애플리케이션을 종료합니다.")
            } primaryButton: {
                OhwaAlertButton(label: Text("애플리케이션 종료").foregroundColor(.textOnButton), color: .button) {
                    exit(0)
                }
            }

        }
        .listStyle(.plain)
        .background(Color.backgroundPrimary.ignoresSafeArea())
        .navigationTitle("데이터 관리")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DataSettingsView()
}
