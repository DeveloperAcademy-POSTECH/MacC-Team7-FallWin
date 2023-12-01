//
//  PolicySettingView.swift
//  FallWin
//
//  Created by 최명근 on 11/8/23.
//

import SwiftUI
import ComposableArchitecture

struct PolicyView: View {
    let store: StoreOf<PolicyFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                NavigationLink {
                    WebView(url: "https://el-capitan.notion.site/4fdc74d2d58b441199e945b100befe10?pvs=4")
                        .toolbar(.hidden, for: .tabBar)
                    
                } label: {
                    Text("settings_policy_service")
                        .font(.pretendard(size: 18))
                        .padding(.vertical, 8)
                }
                .listRowBackground(Color.backgroundPrimary)
                
                NavigationLink {
                    WebView(url: "https://el-capitan.notion.site/de1c30b56c874f01b97e8e1c23aaa33b?pvs=4")
                        .toolbar(.hidden, for: .tabBar)
                    
                } label: {
                    Text("settings_policy_privacy")
                        .font(.pretendard(size: 18))
                        .padding(.vertical, 8)
                }
                .listRowBackground(Color.backgroundPrimary)
                
                NavigationLink {
                    LicenseView(store: store.scope(state: \.license, action: PolicyFeature.Action.license))
                    
                } label: {
                    Text("settings_policy_license")
                        .font(.pretendard(size: 18))
                        .padding(.vertical, 8)
                }
                .listRowBackground(Color.backgroundPrimary)
            }
            .listStyle(.plain)
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("settings_policy")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        PolicyView(store: Store(initialState: PolicyFeature.State(), reducer: {
            PolicyFeature()
        }))
    }
}
