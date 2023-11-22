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
}

extension UserDefaultsKey.Settings {
    static let lock = "lock"
    static let biometric = "biometric"
    static let haptic = "haptic"
    static let dailyNotification = "daily_notification"
    static let dailyNotificationHour = "daily_notification_hour"
    static let dailyNotificationMinute = "daily_notification_minute"
}

extension UserDefaultsKey.User {
    static let nickname = "nickname"
    static let gender = "gender"
}
