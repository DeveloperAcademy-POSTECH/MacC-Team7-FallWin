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
            UserDefaultsKey.Settings.biometric: false
        ])
        
        if !UserDefaults.standard.bool(forKey: UserDefaultsKey.AppEnvironment.alreadyInstalled) {
            KeychainWrapper.standard.removeAllKeys()
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.AppEnvironment.alreadyInstalled)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: Feature.State(), reducer: {
                Feature()
            }))
        }
    }
}
