//
//  HapticManager.swift
//  FallWin
//
//  Created by 최명근 on 11/2/23.
//

import Foundation
import UIKit

final class HapticManager {
    static let shared = HapticManager()
    
    private init() { }
    
    var isHapticEnabled: Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.haptic)
    }
    
    func notification(_ style: UINotificationFeedbackGenerator.FeedbackType) {
        if isHapticEnabled {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(style)
        }
    }
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        if isHapticEnabled {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
    }
}
