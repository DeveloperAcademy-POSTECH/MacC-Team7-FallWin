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
        let year: Int = date.year * Int(1e10)
        let month: Int = date.month * Int(1e8)
        let day: Int = date.day * Int(1e6)
        let hour: Int = date.hour * Int(1e4)
        let minute: Int = date.minute * Int(1e2)
        let second: Int = date.second
        
        let date = year + month + day
        let time = hour + minute + second
        
        return date + time
    }
    
    
}
