//
//  UserDefaultsKey.swift
//  FallWin
//
//  Created by 최명근 on 11/1/23.
//

import Foundation

class UserDefaultsKey {
    class AppEnvironment { }
    
    class Settings { }
    
    class User { }
}

extension UserDefaultsKey.AppEnvironment {
    static let alreadyInstalled = "alreadyInstalled"
    static let drawingCount = "drawingCount"
    static let isFirstLaunched = "isFirstLaunched"
}

extension UserDefaultsKey.Settings {
    static let lock = "lock"
    static let biometric = "biometric"
    static let haptic = "haptic"
}

extension UserDefaultsKey.User {
    static let nickname = "nickname"
    static let gender = "gender"
}
