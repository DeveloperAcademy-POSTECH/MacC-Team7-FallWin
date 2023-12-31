//
//  NotificationSettingView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 11/22/23.
//

import Foundation
import UserNotifications
import ComposableArchitecture

struct NotificationSettingFeature: Reducer {
    struct State: Equatable {
        var notification: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.dailyNotification)
        var notificationHour: Int? = {
            UserDefaults.standard.object(forKey: UserDefaultsKey.Settings.dailyNotificationHour) == nil ?
            nil : UserDefaults.standard.integer(forKey: UserDefaultsKey.Settings.dailyNotificationHour)
        }()
        var notificationMinute: Int? = {
            UserDefaults.standard.object(forKey: UserDefaultsKey.Settings.dailyNotificationMinute) == nil ?
            nil : UserDefaults.standard.integer(forKey: UserDefaultsKey.Settings.dailyNotificationMinute)
        }()
        var showTimePicker: Bool = false
        
        var timeString: String? {
            if let hour = notificationHour, let min = notificationMinute {
                return "\(hour / 12 == 0 ? "time_am".localized : "time_pm".localized) \(String(format: "%02d", hour % 12)):\(String(format: "%02d", min))"
            } else {
                return nil
            }
        }
    }
    
    enum Action: Equatable {
        case setNotification(Bool)
        case setNotificationTime(Int, Int)
        case turnOffNotificationSetting
        case showTimePicker(Bool)
        case setDailyNotification(Int, Int)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .setNotification(set):
            UserDefaults.standard.set(set, forKey: UserDefaultsKey.Settings.dailyNotification)
            state.notification = set
            if set {
                return .send(.showTimePicker(true))
            } else {
                return .send(.turnOffNotificationSetting)
            }
            
        case let .setNotificationTime(hour, min):
            UserDefaults.standard.set(hour, forKey: UserDefaultsKey.Settings.dailyNotificationHour)
            state.notificationHour = hour
            UserDefaults.standard.set(min, forKey: UserDefaultsKey.Settings.dailyNotificationMinute)
            state.notificationMinute = min
            return .send(.setDailyNotification(hour, min))
            
        case .turnOffNotificationSetting:
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.Settings.dailyNotificationHour)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.Settings.dailyNotificationMinute)
            NotificationManager().removeAllPendingNotifications()
            return .none
            
        case let .showTimePicker(show):
            state.showTimePicker = show
            return .none
            
        case let .setDailyNotification(hour, minute):
            return .run { send in
                NotificationManager().removeAllPendingNotifications()
                let registered = await NotificationManager().registerDailyNotification(hour: hour, minute: minute)
                if !registered {
                    await send(.setNotification(false))
                }
            }
        }
    }
}
