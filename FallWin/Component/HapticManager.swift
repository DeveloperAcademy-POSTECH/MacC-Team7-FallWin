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
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
