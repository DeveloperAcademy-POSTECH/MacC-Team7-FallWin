//
//  LockSettingView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 11/7/23.
//

import Foundation
import LocalAuthentication
import ComposableArchitecture
import SwiftKeychainWrapper

struct LockSettingFeature: Reducer {
    struct State: Equatable {
        let laContext: LAContext = LAContext()
        var biometricString: String? = nil
        var lock: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lock)
        var biometric: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.biometric)
        var showPasscodeView: Bool = false
        var passcode: String = ""
    }
    
    enum Action: Equatable {
        case setLock(Bool)
        case saveLockSettings(Bool)
        case setBiometric(Bool)
        case showPasscodeView(Bool)
        case initBiometricString
        case setFirstPasscode(String)
        case setPasscode(String)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {            
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
