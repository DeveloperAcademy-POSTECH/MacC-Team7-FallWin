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
    
    let filmCountPublisher = NotificationCenter.default.publisher(for: .filmCountChanged)
    let networkModel = NetworkModel()
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                Section("setting_section_profile") {
                    HStack {
                        Text(viewStore.nickname)
                            .font(.pretendard(.bold, size: 18))
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Button {
                            viewStore.send(.showNicknameAlert(true))
                        } label: {
                            Text("change")
                                .font(.pretendard(size: 16))
                                .foregroundColor(.textPrimary)
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.backgroundPrimary)
                    
                    VStack {
                        HStack {
                            Text("settings_film")
                            Button {
                                viewStore.send(.showCountInfo(true))
                            } label: {
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "film")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                if networkModel.isConnected {
                                    if let remainingCount = viewStore.remainingDrawingCount {
                                        Text("\(remainingCount)")
                                            .font(.pretendard(.bold, size: 16))
                                            .foregroundColor(.textPrimary)
                                    } else {
                                        ProgressView()
                                    }
                                } else {
                                    Image(systemName: "network.slash")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .opacity(0.6)
                                }
                            }
                        }
                        
                        Rectangle()
                            .fill(Color(hexCode: "#E9E4E3").opacity(0.4))
                            .frame(height: 8)
                            .padding(.top, 16)
                            .padding(.horizontal, -20)
                    }
                    .foregroundColor(.textPrimary)
                    .padding(.vertical, 8)
                    .listRowBackground(Color.backgroundPrimary)
                    .onReceive(filmCountPublisher) { _ in
                        viewStore.send(.getRemainingDrawingCount)
                    }
                }
                .listSectionSeparator(.hidden)

                .alert(isPresented: viewStore.binding(get: \.showNicknameAlert, send: SettingsFeature.Action.showNicknameAlert), title: "settings_nickname_change_title".localized) {
                    TextField("settings_nickname_change_placeholder", text: viewStore.binding(get: \.tempNickname, send: SettingsFeature.Action.setTempNickname))
                } primaryButton: {
                    OhwaAlertButton(label: Text("cancel"), color: .clear) {
                        viewStore.send(.setTempNickname(""))
                        viewStore.send(.showNicknameAlert(false))
                    }
                } secondaryButton: {
                    OhwaAlertButton(label: Text("change").foregroundColor(viewStore.tempNickname.isEmpty ? .textTertiary : .textOnButton), color: .button) {
                        if !viewStore.tempNickname.isEmpty {
                            viewStore.send(.setNickname(viewStore.tempNickname))
                            viewStore.send(.setTempNickname(""))
                            viewStore.send(.showNicknameAlert(false))
                        }
                    }
                }
                .alert(isPresented: viewStore.binding(get: \.showCountInfo, send: SettingsFeature.Action.showCountInfo), title: "film_alert_title".localized) {
                    Text("film_alert_message".localized.replacingOccurrences(of: "{initial_count}", with: "\(FilmManager.INITIAL_COUNT)"))
                        .multilineTextAlignment(.center)
                } primaryButton: {
                    OhwaAlertButton(label: Text("confirm").foregroundColor(.textOnButton), color: .button) {
                        viewStore.send(.showCountInfo(false))
                    }
                }
                
                Section("setting_section_settings") {
                    NavigationLink {
                        IfLetStore(store.scope(state: \.$lockSetting, action: SettingsFeature.Action.lockSetting)) { store in
                            LockSettingView(store: store)
                        }
                    } label: {
                        Text("settings_lock")
                            .font(.pretendard(size: 18))
                            .foregroundColor(.textPrimary)
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                    
                    NavigationLink {
                        IfLetStore(store.scope(state: \.$notification, action: SettingsFeature.Action.notification)) { store in
                            NotificationSettingView(store: store)
                        }
                    } label: {
                        Text("settings_notification")
                            .font(.pretendard(size: 18))
                            .foregroundColor(.textPrimary)
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                }
                
                Section("setting_section_data") {
                    NavigationLink {
                        BackupSettingView()
                        
                    } label: {
                        Text("settings_icloud")
                            .font(.pretendard(size: 18))
                            .foregroundColor(.textPrimary)
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                    
                    NavigationLink {
                        DataSettingsView()
                        
                    } label: {
                        Text("settings_data_manage")
                            .font(.pretendard(size: 18))
                            .foregroundColor(.textPrimary)
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                }
                
                Section("setting_section_info") {
                    NavigationLink {
                        IfLetStore(store.scope(state: \.$policy, action: SettingsFeature.Action.policy)) { store in
                            PolicyView(store: store)
                        }
                        
                    } label: {
                        Text("settings_policy")
                            .font(.pretendard(size: 18))
                            .foregroundColor(.textPrimary)
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                    
                    NavigationLink {
                        WebView(url: "https://instagram.com/picda_official")
                            .toolbar(.hidden, for: .tabBar)
                        
                    } label: {
                        Text("settings_instagram")
                            .font(.pretendard(size: 18))
                            .foregroundColor(.textPrimary)
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                    .onTapGesture {
                        Tracking.logEvent(Tracking.Event.A5_3_1_설정뷰_소통창구.rawValue)
                        print("@Log : A5_3_1_설정뷰_소통창구")
                    }
                    
                    NavigationLink {
                        WebView(url: "https://forms.gle/DxFtstGew7zctnWm9")
                            .toolbar(.hidden, for: .tabBar)
                        
                    } label: {
                        Text("settings_feedback")
                            .font(.pretendard(size: 18))
                            .foregroundColor(.textPrimary)
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                    
                    HStack {
                        Text("settings_info")
                            .font(.pretendard(size: 18))
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text("\(viewStore.appVersion) (\(viewStore.appBuild))")
                            .font(.pretendard(size: 18))
                            .foregroundStyle(.textSecondary)
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.backgroundPrimary)
                }
                
                #if DEBUG
                Section(String("디버깅")) {
                    NavigationLink {
                        DebuggingView()
                    } label: {
                        Text(String("디버그 메뉴"))
                            .font(.pretendard(size: 18))
                            .foregroundColor(.textPrimary)
                            .padding(.vertical, 8)
                    }

                }
                #endif
            }
            .listStyle(.plain)
            .listRowSeparatorTint(.separator)
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("tab_more")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Tracking.logScreenView(screenName: Tracking.Screen.V5__설정뷰.rawValue)
                print("@Log : V5__설정뷰")
                viewStore.send(.fetchAppInfo)
                viewStore.send(.getRemainingDrawingCount)
            }
        }
    }
    
//    @ViewBuilder
//    func nicknameSettingHStack() -> Alert {
//        HStack {
//            nicknameSettingView(buttonType: .cancel)
//            nicknameSettingView(buttonType: .update)
//        }
//    }
//    
//    @ViewBuilder
//    func nicknameSettingView(buttonType: NicknameButtonType) -> some View {
//        
//        WithViewStore(store, observe: { $0 }) { viewStore in
//            if buttonType == .cancel {
//                Button {
//                    viewStore.send(.setTempNickname(""))
//                    viewStore.send(.showNicknameAlert(false))
//                } label: {
//                    Text("취소")
//                }
//                .background(Color.clear)
//                .cornerRadius(4)
//            } else {
//                Button {
//                    if !viewStore.tempNickname.isEmpty {
//                        viewStore.send(.setNickname(viewStore.tempNickname))
//                        viewStore.send(.setTempNickname(""))
//                        viewStore.send(.showNicknameAlert(false))
//                    }
//                } label: {
//                    Text("변경")
//                        .foregroundStyle(viewStore.tempNickname.isEmpty ? .textTertiary : .textOnButton)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .padding()
//                }
//                .background(viewStore.tempNickname.isEmpty ? .buttonDisabled : .button)
//                .cornerRadius(4)
//            }
//        }
//    }
}

#Preview {
    NavigationStack {
        SettingsView(store: Store(initialState: SettingsFeature.State(), reducer: {
            SettingsFeature()
        }))
    }
}
