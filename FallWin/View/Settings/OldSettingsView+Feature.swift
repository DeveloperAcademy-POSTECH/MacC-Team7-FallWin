//
//  SettingsView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 11/1/23.
//

import Foundation
import LocalAuthentication
import SwiftKeychainWrapper
import ComposableArchitecture

struct OldSettingsFeature: Reducer {
    struct State: Equatable {
        // Constants
        let laContext: LAContext = LAContext()
        var biometricString: String? = nil
        
        // Settings
        var haptic: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.haptic)
        var lock: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lock)
        var biometric: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.biometric)
        
        // States
        var showPasscodeView: Bool = false
        
        // Passcode
        var passcode: String = ""
    }
    
    enum Action: Equatable {
        // Settings
        case setHaptic(Bool)
        case setLock(Bool)
        case saveLockSettings(Bool)
        case setBiometric(Bool)
        // Actions
        case showPasscodeView(Bool)
        case initBiometricString
        case setFirstPasscode(String)
        case setPasscode(String)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setHaptic(haptic):
                UserDefaults.standard.setValue(haptic, forKey: UserDefaultsKey.Settings.haptic)
                state.haptic = haptic
                return .none
                
            case .initBiometricString:
                if state.laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                    if state.laContext.biometryType == .touchID {
                        state.biometricString = "Touch ID"
                    } else if state.laContext.biometryType == .faceID {
                        state.biometricString = "Face ID"
                    } else if #available(iOS 17, *), state.laContext.biometryType == .opticID {
                        state.biometricString = "Optic ID"
                    } else {
                        state.biometricString = nil
                    }
                }
                return .none
                
            case let .setLock(lock):
                if lock {
                    return .send(.showPasscodeView(true))
                } else {
                    KeychainWrapper.standard.remove(forKey: .password)
                    return .send(.saveLockSettings(lock))
                }
                
            case let .saveLockSettings(lock):
                UserDefaults.standard.setValue(lock, forKey: UserDefaultsKey.Settings.lock)
                state.lock = lock
                return .none
                
            case let .setBiometric(biometric):
                UserDefaults.standard.setValue(biometric, forKey: UserDefaultsKey.Settings.biometric)
                state.biometric = biometric
                return .none
                
            case let .showPasscodeView(show):
                state.showPasscodeView = show
                return .none
                
            case let .setFirstPasscode(passcode):
                state.passcode = passcode
                return .none
                
            case let .setPasscode(passcode):
                KeychainWrapper.standard[.password] = passcode
                return .send(.saveLockSettings(true))
                
            default: return .none
            }
        }
    }
}
