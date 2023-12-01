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
                Text("settings_data_delete_journal")
                    .font(.pretendard(size: 18))
                    .padding(.vertical, 8)
            }
            .listRowBackground(Color.backgroundPrimary)
            .confirmationDialog("settings_data_delete_alert_title".localized, isPresented: $deleteAlert, titleVisibility: .visible, actions: {
                Button("cancel", role: .cancel) {
                    deleteAlert = false
                }
                Button("settings_data_delete", role: .destructive) {
                    DispatchQueue.main.async {
                        DataManager.shared.deleteAllData()
                        deleteComplete = true
                    }
                }
            }, message: {
                Text("settings_data_delete_alert_message")
            })
            .alert(isPresented: $deleteComplete, title: "settings_data_delete_alert_title".localized) {
                Text("settings_data_delete_result_alert")
            } primaryButton: {
                OhwaAlertButton(label: Text("settings_data_delete_result_alert_confirm").foregroundColor(.textOnButton), color: .button) {
                    exit(0)
                }
            }

        }
        .listStyle(.plain)
        .background(Color.backgroundPrimary.ignoresSafeArea())
        .navigationTitle("settings_data_manage")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DataSettingsView()
}
