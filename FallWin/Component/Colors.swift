//
//  Colors.swift
//  FallWin
//
//  Created by 최명근 on 10/12/23.
//

import SwiftUI

enum Colors: String {
    case backgroundPrimary
    case backgroundSecondary
    case backgroundTertiary
    case backgroundTabBar
    case backgroundOnTabBar
    
    func color() -> Color {
        return Color(self.rawValue)
    }
}
