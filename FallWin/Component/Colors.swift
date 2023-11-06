//
//  Colors.swift
//  FallWin
//
//  Created by 최명근 on 10/12/23.
//

import SwiftUI

enum Colors: String {
    // Background
    case backgroundPrimary
    // TabBar
    case tabBar
    case tabBarItem
    // Button
    case button
    case buttonDisabled
    // Symbol
    case symbol
    case symbolDisabled
    // Text
    case textPrimary
    case textSecondary
    case textTertiary
    // Emotions
    case emotionHappy
    case emotionGrateful
    case emotionJoyful
    case emotionProud
    case emotionTouched
    case emotionExciting
    case emotionAnnoyed
    case emotionNervous
    case emotionSad
    case emotionLonely
    case emotionSuffocated
    case emotionLazy
    case emotionShy
    case emotionFrustrated
    case emotionTough
    case emotionReassuring
    case emotionPeaceful
    case emotionSurprised
    
    func color() -> Color {
        return Color(self.rawValue)
    }
}
