//
//  UIApplication+Extension.swift
//  FallWin
//
//  Created by semini on 2023/11/06.
//

import Foundation
import UIKit
extension UIApplication{
    var keyWindow: UIWindow?{
        return UIApplication.shared.connectedScenes.filter ({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene}).compactMap {$0}.first?.windows.filter { $0.isKeyWindow }.first ??  UIApplication.shared.connectedScenes.compactMap{$0 as? UIWindowScene}.first?.keyWindow
       
    }
}

