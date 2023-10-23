//
//  Color+Extension.swift
//  paste-wallet
//
//  Created by 최명근 on 9/6/23.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    init(hexCode: String, alpha: CGFloat = 1.0) {
        self.init(uiColor: .init(hexCode: hexCode, alpha: alpha))
    }
    
    var hex: String {
        return UIColor(self).hex
    }
    
    var isDark: Bool {
        return UIColor(self).isDark
    }
}
