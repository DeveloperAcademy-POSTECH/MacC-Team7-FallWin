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
        
    }
    
    enum Action: Equatable {
        case setHour(Int)
        case setMinute(Int)
        case requestNotificationAuth
        case authorizationResponse(Bool)
        case showPicker(Bool)
        case addNotificationRequest(Int, Int)
        case doneInitSetting
        
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
            state.notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if let error = error {
                    print(error)
                } else {
                    if granted {
                        let content = UNMutableNotificationContent()
                        content.title = "PICDA 푸시 알림 title"
                        content.subtitle = "PICDA 푸시 알림 subtitle"
                        content.body = "PICDA 푸시 알림 body"
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: hour, minute: minute), repeats: true)
                        
                        let request = UNNotificationRequest(identifier: "daily", content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request)
                    }
                }
            }
            return .send(.doneInitSetting)
            
        case let .showPicker(show):
            state.isPickerShown = show
            return .none
            
        case .doneInitSetting:
            UserDefaults.standard.set(state.hour, forKey: UserDefaultsKey.Settings.dailyNotificationHour)
            UserDefaults.standard.set(state.minute, forKey: UserDefaultsKey.Settings.dailyNotificationMinute)
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.Settings.dailyNotification)
            UserDefaults.standard.set(false, forKey: UserDefaultsKey.AppEnvironment.isFirstLaunched)
            return .none
            
        default:
            return .none
        }
    }
}
