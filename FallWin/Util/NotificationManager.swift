//
//  NotificationManager.swift
//  FallWin
//
//  Created by 최명근 on 11/30/23.
//

import Foundation
import UserNotifications

class NotificationManager {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    init() {
        notificationCenter.getPendingNotificationRequests { requests in
            for request in requests {
                print(request)
            }
        }
    }
    
    func removeAllPendingNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func makeNotificationContent(title: String = "notification_title".localized, subtitle: String? = nil, body: String = "notification_body".localized) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        content.body = body
        content.sound = .default
        
        return content
    }
    
    private func addDailyNotification(hour: Int, minute: Int) {
        let content = self.makeNotificationContent()
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: hour, minute: minute), repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
    
    func registerDailyNotification(hour: Int, minute: Int, onRegister: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                self.addDailyNotification(hour: hour, minute: minute)
                onRegister(true)
                
            } else {
                self.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { didAllow, error in
                    if let error = error, !didAllow {
                        print(error)
                        onRegister(false)
                        return
                    } else {
                        self.addDailyNotification(hour: hour, minute: minute)
                        onRegister(true)
                    }
                }
            }
        }
    }
    
    func registerDailyNotification(hour: Int, minute: Int) async -> Bool {
        return await withCheckedContinuation { continuation in
            registerDailyNotification(hour: hour, minute: minute) { registered in
                continuation.resume(returning: registered)
            }
        }
    }
    
    private func addTestNotification() {
        let content = self.makeNotificationContent()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
    
    func registerTestNotification(onRegister: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                self.addTestNotification()
                onRegister(true)
                
            } else {
                self.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { didAllow, error in
                    if let error = error, !didAllow {
                        print(error)
                        onRegister(false)
                        return
                    } else {
                        self.addTestNotification()
                        onRegister(true)
                    }
                }
            }
        }
    }
    
    func registerTestNotification() async -> Bool {
        return await withCheckedContinuation { continuation in
            registerTestNotification { registered in
                continuation.resume(returning: registered)
            }
        }
    }
}
