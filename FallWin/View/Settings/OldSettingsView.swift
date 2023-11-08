//
//  SettingsView.swift
//  FallWin
//
//  Created by 최명근 on 11/1/23.
//

import SwiftUI
import ComposableArchitecture

struct OldSettingsView: View {
    let store: StoreOf<OldSettingsFeature>
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                Section {
                    Toggle("햅틱 피드백 사용", isOn: viewStore.binding(get: \.haptic, send: OldSettingsFeature.Action.setHaptic))
                } header: {
                    Text("환경")
                }
                
                Section {
                    Toggle("앱 잠금", isOn: viewStore.binding(get: \.lock, send: OldSettingsFeature.Action.setLock))
                    
                    if let biometricString = viewStore.biometricString {
                        Toggle(biometricString, isOn: viewStore.binding(get: \.biometric, send: OldSettingsFeature.Action.setBiometric))
                            .disabled(!viewStore.lock)
                    }
                    
                } header: {
                    Text("보안")
                }
                .onAppear {
                    viewStore.send(.initBiometricString)
                }
                
                Section {
                    Link(destination: URL(string: "https://mgdgc.notion.site/6c94fdf60c3f413db4d5d0bbd6b751cb?pvs=4")!) {
                        Text("개인정보처리방침")
                    }
                    .foregroundStyle(.blue)
                }
            }
            .listStyle(.plain)
            .fullScreenCover(isPresented: viewStore.binding(get: \.showPasscodeView, send: OldSettingsFeature.Action.showPasscodeView), content: {
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
            .navigationTitle("설정")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("닫기") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        OldSettingsView(store: Store(initialState: OldSettingsFeature.State(), reducer: {
            OldSettingsFeature()
        }))
    }
}
