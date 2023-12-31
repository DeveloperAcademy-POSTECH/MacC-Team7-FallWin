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
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}

@main
struct FallWinApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        // MARK: AppEnvironment
        UserDefaults.standard.register(defaults: [
            UserDefaultsKey.AppEnvironment.isFirstLaunched: true,
            UserDefaultsKey.AppEnvironment.devMode: false
        ])
        
        // MARK: Settings
        UserDefaults.standard.register(defaults: [
            UserDefaultsKey.Settings.lock: false,
            UserDefaultsKey.Settings.biometric: false,
            UserDefaultsKey.Settings.haptic: true,
            UserDefaultsKey.Settings.dailyNotification: false,
        ])
        
        // MARK: User
        UserDefaults.standard.register(defaults: [
            UserDefaultsKey.User.nickname: "PICDA",
            UserDefaultsKey.User.gender: "none",
        ])
        
        if !UserDefaults.standard.bool(forKey: UserDefaultsKey.AppEnvironment.alreadyInstalled) {
            KeychainWrapper.standard.removeAllKeys()
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.AppEnvironment.alreadyInstalled)
        }
        
        ICloudBackupManager()?.test()
    }
    
    @State private var locked: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lock)
    
    var body: some Scene {
        WindowGroup {
            if !locked {
                ContentView(store: Store(initialState: Feature.State(), reducer: {
                    Feature()
                }))
            } else {
                PasscodeView(initialMessage: "passcode_enter".localized, dismissable: false, enableBiometric: true, authenticateOnLaunch: true) { typed, biometric in
                    if typed == KeychainWrapper.standard[.password] || biometric ?? false {
                        locked = false
                        return .dismiss
                        
                    } else {
                        return .retype("passcode_enter_fail".localized)
                    }
                }
            }
        }
    }
}
