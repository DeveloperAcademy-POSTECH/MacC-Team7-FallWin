//
//  PickerManager.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/9/23.
//

import Foundation

final class PickerManager {
    static let shared = PickerManager()
    let sessionID = UUID().uuidString
    
    private init() {}
}

extension PickerManager {
    
    func initDateValue(date: Date) -> Int {
        let year = date.year
        let month = date.month
        let day = date.day
        let hour = date.hour
        let minute = date.minute
        let second = date.second
        
        return year * 1e10 + month * 1e8 + day * 1e6 + hour * 1e4 + minute * 1e2 + second
    }
    
    
}
