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
                        Text("비밀번호 잠금")
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
                    Text("비밀번호를 분실한 경우 되찾을 수 없어요.")
                        .foregroundStyle(.textSecondary)
                        .font(.pretendard(size: 14))
                        .listRowBackground(Color.backgroundPrimary)
                }
            }
            .fullScreenCover(isPresented: viewStore.binding(get: \.showPasscodeView, send: LockSettingFeature.Action.showPasscodeView), content: {
                PasscodeView(initialMessage: "설정할 비밀번호를 입력하세요.", dismissable: true, enableBiometric: false, authenticateOnLaunch: false) { typed, _ in
                    if viewStore.passcode.isEmpty {
                        if let typed = typed {
                            viewStore.send(.setFirstPasscode(typed))
                            return .retype("입력한 비밀번호를 확인해 주세요.")
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
                            return .retype("비밀번호가 다릅니다.\n다시 입력해주세요.")
                        }
                    }
                }
            })
            .listStyle(.plain)
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("화면 잠금")
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
