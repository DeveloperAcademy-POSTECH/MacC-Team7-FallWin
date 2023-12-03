//
//  NotificationInitView+Feature.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/28/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct NotificationInitFeature: Reducer {
    struct State: Equatable {
        var hour: Int = 21
        var minute: Int = 0
        
        var notificationCenter = UNUserNotificationCenter.current()
        var isPickerShown: Bool = false
        var isAlertShown: Bool = false
        
    }
    
    enum Action: Equatable {
        case setHour(Int)
        case setMinute(Int)
        case requestNotificationAuth
        case authorizationResponse(Bool)
        case showPicker(Bool)
        case showAlert(Bool)
        case addNotificationRequest(Int, Int)
        case doneInitSetting(Bool)
        
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
            
        case let .setHour(hour):
            state.hour = hour
            return .none
            
        case let .setMinute(minute):
            state.minute = minute
            return .none
            
        case let .addNotificationRequest(hour, minute):
            return .run { send in
                let manager = NotificationManager()
                manager.removeAllPendingNotifications()
                let _ = await manager.registerDailyNotification(hour: hour, minute: minute)
                await send(.doneInitSetting(false))
            }
            
        case let .showPicker(show):
            state.isPickerShown = show
            return .none
            
        case let .showAlert(show):
            state.isAlertShown = show
            return .none
            
        case let .doneInitSetting(isSkipped):
            if isSkipped {
                UserDefaults.standard.set(false, forKey: UserDefaultsKey.Settings.dailyNotification)
            } else {
                UserDefaults.standard.set(state.hour, forKey: UserDefaultsKey.Settings.dailyNotificationHour)
                UserDefaults.standard.set(state.minute, forKey: UserDefaultsKey.Settings.dailyNotificationMinute)
                UserDefaults.standard.set(true, forKey: UserDefaultsKey.Settings.dailyNotification)
            }
            UserDefaults.standard.set(false, forKey: UserDefaultsKey.AppEnvironment.isFirstLaunched)
            return .none
            
        default:
            return .none
        }
    }
}
