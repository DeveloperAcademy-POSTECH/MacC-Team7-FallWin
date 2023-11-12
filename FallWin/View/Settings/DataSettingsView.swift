//
//  DataSettingsView.swift
//  FallWin
//
//  Created by 최명근 on 11/12/23.
//

import SwiftUI

struct DataSettingsView: View {
    var body: some View {
        List {
            Button(role: .destructive) {
                ICloudBackupManager()?.deletePrevData()
                
            } label: {
                Text("일기 데이터 삭제")
                    .font(.pretendard(size: 18))
                    .padding(.vertical, 8)
            }
            .listRowBackground(Color.backgroundPrimary)
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
