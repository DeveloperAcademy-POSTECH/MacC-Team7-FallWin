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
                Section("프로필") {
                    HStack {
                        Text(viewStore.nickname)
                            .font(.pretendard(.bold, size: 18))
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Button {
                            viewStore.send(.showNicknameAlert(true))
                        } label: {
                            Text("변경")
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
                            Text("남은 필름")
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
                                Text("\(viewStore.remainingDrawingCount)")
                                    .font(.pretendard(.bold, size: 16))
                                    .foregroundColor(.textPrimary)
                            }
                        }
                        
                        Rectangle()
                            .fill(Color(hexCode: "#E9E4E3"))
                            .frame(height: 8)
                            .padding(.top, 16)
                            .padding(.horizontal, -20)
                    }
                    .foregroundColor(.textPrimary)
                    .padding(.vertical, 8)
                    .listRowBackground(Color.backgroundPrimary)
                }
                .listSectionSeparator(.hidden)
                .alert("닉네임 변경", isPresented: viewStore.binding(get: \.showNicknameAlert, send: SettingsFeature.Action.showNicknameAlert), actions: {
                    
                })
//                .alert(isPresented: viewStore.binding(get: \.showNicknameAlert, send: SettingsFeature.Action.showNicknameAlert), title: "닉네임 변경") {
//                    TextField("닉네임", text: viewStore.binding(get: \.tempNickname, send: SettingsFeature.Action.setTempNickname))
//                } primaryButton: {
//                    OhwaAlertButton(label: Text("취소"), color: .clear) {
//                        viewStore.send(.setTempNickname(""))
//                        viewStore.send(.showNicknameAlert(false))
//                    }
//                } secondaryButton: {
//                    OhwaAlertButton(label: Text("변경").foregroundColor(viewStore.tempNickname.isEmpty ? .textTertiary : .textOnButton), tempNickname: viewStore.tempNickname) {
//                        if !viewStore.tempNickname.isEmpty {
//                            viewStore.send(.setNickname(viewStore.tempNickname))
//                            viewStore.send(.setTempNickname(""))
//                            viewStore.send(.showNicknameAlert(false))
//                        }
//                    }
//                }
                .alert(isPresented: viewStore.binding(get: \.showCountInfo, send: SettingsFeature.Action.showCountInfo), title: "남은 필름") {
                    Text("일기를 작성하고 그림을 생성할 때 마다 필름이 하나씩 소모되어요.\n필름은 매일 \(DrawingCountManager.INITIAL_COUNT)개로 리셋되니, 필름이 떨어지지 않게 유의하세요!")
                        .multilineTextAlignment(.center)
                } primaryButton: {
                    OhwaAlertButton(label: Text("확인").foregroundColor(.textOnButton), color: .button) {
                        viewStore.send(.showCountInfo(false))
                    }
                }
                
                Section("잠금") {
                    NavigationLink {
                        IfLetStore(store.scope(state: \.$lockSetting, action: SettingsFeature.Action.lockSetting)) { store in
                            LockSettingView(store: store)
                        }
                    } label: {
                        Text("화면 잠금")
                            .font(.pretendard(size: 18))
                            .foregroundColor(.textPrimary)
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
                            .foregroundColor(.textPrimary)
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                    
                    NavigationLink {
                        DataSettingsView()
                        
                    } label: {
                        Text("데이터 관리")
                            .font(.pretendard(size: 18))
                            .foregroundColor(.textPrimary)
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
                            .foregroundColor(.textPrimary)
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                    
                    NavigationLink {
                        WebView(url: "https://instagram.com/ohwa_todaysart")
                            .toolbar(.hidden, for: .tabBar)
                        
                    } label: {
                        Text("소통 창구")
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
//                        IfLetStore(store.scope(state: \.$feedback, action: SettingsFeature.Action.feedback)) { store in
//                            FeedbackView(store: store)
//                        }
                        WebView(url: "https://instagram.com/ohwa_todaysart")
                            .toolbar(.hidden, for: .tabBar)
                        
                    } label: {
                        Text("피드백 남기기")
                            .font(.pretendard(size: 18))
                            .foregroundColor(.textPrimary)
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                    
                    NavigationLink {
                        WebView(url: "https://instagram.com/ohwa_todaysart")
                            .toolbar(.hidden, for: .tabBar)
                        
                    } label: {
                        HStack {
                            Text("픽다에 대하여")
                            Spacer()
                            Text("\(viewStore.appVersion) (\(viewStore.appBuild))")
                                .foregroundStyle(.textSecondary)
                        }
                        .font(.pretendard(size: 18))
                        .foregroundColor(.textPrimary)
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                }
            }
            .listStyle(.plain)
            .listRowSeparatorTint(.separator)
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Tracking.logScreenView(screenName: Tracking.Screen.V5__설정뷰.rawValue)
            print("@Log : V5__설정뷰")
           }
    }
    
    @ViewBuilder
    func nicknameSettingHStack() -> Alert {
        HStack {
            nicknameSettingView(buttonType: .cancel)
            nicknameSettingView(buttonType: .update)
        }
    }
    
    @ViewBuilder
    func nicknameSettingView(buttonType: NicknameButtonType) -> some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            if buttonType == .cancel {
                Button {
                    viewStore.send(.setTempNickname(""))
                    viewStore.send(.showNicknameAlert(false))
                } label: {
                    Text("취소")
                }
                .background(Color.clear)
                .cornerRadius(4)
            } else {
                Button {
                    if !viewStore.tempNickname.isEmpty {
                        viewStore.send(.setNickname(viewStore.tempNickname))
                        viewStore.send(.setTempNickname(""))
                        viewStore.send(.showNicknameAlert(false))
                    }
                } label: {
                    Text("변경")
                        .foregroundStyle(viewStore.tempNickname.isEmpty ? .textTertiary : .textOnButton)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                }
                .background(viewStore.tempNickname.isEmpty ? .buttonDisabled : .button)
                .cornerRadius(4)
            }
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
