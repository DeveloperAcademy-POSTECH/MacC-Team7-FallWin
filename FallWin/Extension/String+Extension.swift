//
//  String+Extension.swift
//  FallWin
//
//  Created by 최명근 on 10/12/23.
//

import Foundation

extension String {
    
    var localized: String {
        get {
            return NSLocalizedString(self, comment: "")
        }
    }
    
}
