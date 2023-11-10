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
    
    func getDateTagValue(date: Date) -> Int {
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

struct DateTagValue: Identifiable, Equatable, Hashable {
    
    var id: Int
    
    var date: Date
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var second: Int

    var tagValue: Int
    
    init(date: Date) {
        let tagValue = PickerManager.shared.getDateTagValue(date: date)
        
        self.date = date
        self.year = date.year
        self.month = date.month
        self.day = date.day
        self.hour = date.hour
        self.minute = date.minute
        self.second = date.second
        
        self.tagValue = tagValue
        self.id = tagValue
    }
    
    mutating func reCalculate() {
        let year: Int = self.year * Int(1e10)
        let month: Int = self.month * Int(1e8)
        let day: Int = self.day * Int(1e6)
        let hour: Int = self.hour * Int(1e4)
        let minute: Int = self.minute * Int(1e2)
        let second: Int = self.second
        
        let date = year + month + day
        let time = hour + minute + second
        
        self.tagValue = date + time
    }
}

