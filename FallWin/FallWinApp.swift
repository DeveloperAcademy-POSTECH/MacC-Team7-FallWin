//
//  FallWinApp.swift
//  FallWin
//
//  Created by 최명근 on 10/12/23.
//

import SwiftUI
import SwiftKeychainWrapper
import ComposableArchitecture
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct FallWinApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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
    
    @State private var locked: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lock)
    
    var body: some Scene {
        WindowGroup {
            if !locked {
                ContentView(store: Store(initialState: Feature.State(), reducer: {
                    Feature()
                }))
            } else {
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
