//
//  LockSettingView.swift
//  FallWin
//
//  Created by 최명근 on 11/7/23.
//

import SwiftUI
import ComposableArchitecture
import FirebaseAnalytics

struct LockSettingView: View {
    let store: StoreOf<LockSettingFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                Section {
                    Toggle(isOn: viewStore.binding(get: \.lock, send: LockSettingFeature.Action.setLock)) {
                        Text("settings_lock_enable")
                            .font(.pretendard(size: 18))
                            .padding(.vertical, 8)
                    }
                    .onTapGesture(perform: {
                        Tracking.logEvent(Tracking.Event.A5_1_1_설정뷰_화면잠금_비밀번호설정과해제.rawValue)
                        print("@Log : A5_1_1_설정뷰_화면잠금_비밀번호설정과해제")
                    })
                    .listRowBackground(Color.backgroundPrimary)
                    
                    if let biometricString = viewStore.biometricString {
                        Toggle(isOn: viewStore.binding(get: \.biometric, send: LockSettingFeature.Action.setBiometric)) {
                            Text(biometricString)
                                .font(.pretendard(size: 18))
                                .padding(.vertical, 8)
                        }
                        .disabled(!viewStore.lock)
                        .listRowBackground(Color.backgroundPrimary)
                    }
                } footer: {
                    Text("settings_lock_footer")
                        .foregroundStyle(.textSecondary)
                        .font(.pretendard(size: 14))
                        .listRowBackground(Color.backgroundPrimary)
                }
                .onAppear {
                    viewStore.send(.initBiometricString)
                }
            }
            .fullScreenCover(isPresented: viewStore.binding(get: \.showPasscodeView, send: LockSettingFeature.Action.showPasscodeView), content: {
                PasscodeView(initialMessage: "passcode_set".localized, dismissable: true, enableBiometric: false, authenticateOnLaunch: false) { typed, _ in
                    if viewStore.passcode.isEmpty {
                        if let typed = typed {
                            viewStore.send(.setFirstPasscode(typed))
                            return .retype("passcode_set_retype".localized)
                        } else {
                            return .dismiss
                        }
                    } else {
                        if viewStore.passcode == typed {
                            viewStore.send(.setPasscode(viewStore.passcode))
                            viewStore.send(.setFirstPasscode(""))
                            return .dismiss
                        } else {
                            viewStore.send(.setFirstPasscode(""))
                            return .retype("passcode_set_wrong".localized)
                        }
                    }
                }
            })
            .listStyle(.plain)
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("settings_lock")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        LockSettingView(store: Store(initialState: LockSettingFeature.State(), reducer: {
            LockSettingFeature()
        }))
    }
}
