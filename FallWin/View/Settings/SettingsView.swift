//
//  SettingsView.swift
//  FallWin
//
//  Created by 최명근 on 11/7/23.
//

import SwiftUI
import ComposableArchitecture
import FirebaseAnalytics

struct SettingsView: View {
    let store: StoreOf<SettingsFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                Section("잠금") {
                    NavigationLink {
                        IfLetStore(store.scope(state: \.$lockSetting, action: SettingsFeature.Action.lockSetting)) { store in
                            LockSettingView(store: store)
                        }
                    } label: {
                        Text("화면 잠금")
                            .font(.pretendard(size: 18))
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                }
                
                Section("데이터 관리") {
                    NavigationLink {
                        BackupSettingView()
                        
                    } label: {
                        Text("iCloud 백업/ 복원")
                            .font(.pretendard(size: 18))
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                }
                
                Section("애플리케이션 정보") {
                    NavigationLink {
                        IfLetStore(store.scope(state: \.$policy, action: SettingsFeature.Action.policy)) { store in
                            PolicyView(store: store)
                        }
                        
                    } label: {
                        Text("이용약관")
                            .font(.pretendard(size: 18))
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                    
                    NavigationLink {
                        WebView(url: "https://instagram.com/ohwa_todaysart")
                            .toolbar(.hidden, for: .tabBar)
                        
                    } label: {
                        Text("소통 창구")
                            .font(.pretendard(size: 18))
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                    .onTapGesture {
                        Tracking.logEvent(Tracking.Event.A5_3_1_설정뷰_소통창구.rawValue)
                        print("@Log : A5_3_1_설정뷰_소통창구")
                    }
                    
                    NavigationLink {
//                        IfLetStore(store.scope(state: \.$feedback, action: SettingsFeature.Action.feedback)) { store in
//                            FeedbackView(store: store)
//                        }
                        WebView(url: "https://instagram.com/ohwa_todaysart")
                            .toolbar(.hidden, for: .tabBar)
                        
                    } label: {
                        Text("피드백 남기기")
                            .font(.pretendard(size: 18))
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                    
                    NavigationLink {
                        WebView(url: "https://instagram.com/ohwa_todaysart")
                            .toolbar(.hidden, for: .tabBar)
                        
                    } label: {
                        HStack {
                            Text("오화에 대하여")
                            Spacer()
                            Text("\(viewStore.appVersion) (\(viewStore.appBuild))")
                                .foregroundStyle(.textSecondary)
                        }
                        .font(.pretendard(size: 18))
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                }
            }
            .listStyle(.plain)
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Tracking.logScreenView(screenName: Tracking.Screen.V5__설정뷰.rawValue)
            print("@Log : V5__설정뷰")
           }
    }
}

#Preview {
    NavigationStack {
        SettingsView(store: Store(initialState: SettingsFeature.State(), reducer: {
            SettingsFeature()
        }))
    }
}
