//
//  FallWinApp.swift
//  FallWin
//
//  Created by 최명근 on 10/12/23.
//

import SwiftUI
import SwiftKeychainWrapper
import ComposableArchitecture

@main
struct FallWinApp: App {
    init() {
        UserDefaults.standard.register(defaults: [
            UserDefaultsKey.Settings.lock: false,
            UserDefaultsKey.Settings.biometric: false,
            UserDefaultsKey.Settings.haptic: true
        ])
        
        if !UserDefaults.standard.bool(forKey: UserDefaultsKey.AppEnvironment.alreadyInstalled) {
            KeychainWrapper.standard.removeAllKeys()
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.AppEnvironment.alreadyInstalled)
        }
    }
    
    @State private var locked: Bool = true
    var body: some Scene {
        WindowGroup {
            if !locked {
                ContentView(store: Store(initialState: Feature.State(), reducer: {
                    Feature()
                }))
            } else {
                if UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lock) &&
                    KeychainWrapper.standard.hasValue(forKey: KeychainWrapper.Key.password.rawValue) {
                    PasscodeView(initialMessage: "비밀번호를 입력하세요.", dismissable: false, enableBiometric: true, authenticateOnLaunch: true) { typed, biometric in
                        if typed == KeychainWrapper.standard[.password] || biometric ?? false {
                            locked = false
                            return .dismiss
                            
                        } else {
                            return .retype("비밀번호가 다릅니다.\n다시 입력해주세요.")
                        }
                    }
                }
            }
        }
    }
}
