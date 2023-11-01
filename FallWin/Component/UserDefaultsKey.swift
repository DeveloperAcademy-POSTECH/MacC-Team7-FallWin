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
}

extension UserDefaultsKey.AppEnvironment {
    static let alreadyInstalled = "alreadyInstalled"
}

extension UserDefaultsKey.Settings {
    static let lock = "lock"
    static let biometric = "biometric"
}
