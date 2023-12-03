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
                    WebView(url: "policy_service_url".localized)
                        .toolbar(.hidden, for: .tabBar)
                    
                } label: {
                    Text("settings_policy_service")
                        .font(.pretendard(size: 18))
                        .padding(.vertical, 8)
                }
                .listRowBackground(Color.backgroundPrimary)
                
                NavigationLink {
                    WebView(url: "policy_privacy_url".localized)
                        .toolbar(.hidden, for: .tabBar)
                    
                } label: {
                    Text("settings_policy_privacy")
                        .font(.pretendard(size: 18))
                        .padding(.vertical, 8)
                }
                .listRowBackground(Color.backgroundPrimary)
                
                NavigationLink {
                    WebView(url: "policy_privacy_optional_url".localized)
                        .toolbar(.hidden, for: .tabBar)
                    
                } label: {
                    Text("settings_policy_privacy_optional")
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
