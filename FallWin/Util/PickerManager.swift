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
    
    func getTagValuePeriod(year: Int, month: Int) -> [Int] {
        if month == 12 {
            let minYear: Int = year * Int(1e10)
            let maxYear: Int = (year + 1) * Int(1e10)
            let minMonth: Int = month * Int(1e8)
            let maxMonth: Int = 1 * Int(1e8)
            let day: Int = 1 * Int(1e6)
            
            let minTagValue = minYear + minMonth + day
            let maxTagValue = maxYear + maxMonth + day
            
            return [minTagValue, maxTagValue]
            
        } else {
            let year: Int = year * Int(1e10)
            let minMonth: Int = month * Int(1e8)
            let maxMonth: Int = (month + 1) * Int(1e8)
            let day: Int = 1 * Int(1e6)
            
            let minTagValue = year + minMonth + day
            let maxTagValue = year + maxMonth + day
            
            return [minTagValue, maxTagValue]
        }
    }
    
//    func getLastTagValue(journals: [Journal], dateTagValue: DateTagValue) -> Int {
//        let tagValues = journals.map{ self.getDateTagValue(date: $0.timestamp ?? Date()) }
//        
//        let tagValuePeriod = self.getTagValuePeriod(year: dateTagValue.year, month: dateTagValue.month)
//        
////        print(tagValues.filter({ tagValuePeriod[0] <= $0 && $0 <= tagValuePeriod[1] }))
//        
//        if let lastTagValue = tagValues.filter({ tagValuePeriod[0] <= $0 && $0 <= tagValuePeriod[1] }).first {
//            return lastTagValue
//        } else {
//            return dateTagValue.tagValue
//        }
//        
//    }
}

extension PickerManager {
    
    func getDateFromDateTagValue(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, dayOfWeek: String) -> Date? {
        
        var weekday = 1
        switch dayOfWeek {
        case "일": weekday = 1
        case "월": weekday = 2
        case "화": weekday = 3
        case "수": weekday = 4
        case "목": weekday = 5
        case "금": weekday = 6
        case "토": weekday = 7
        default: weekday = 1
        }

        let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second, weekday: weekday)
        let date = Calendar.current.date(from: dateComponents) // "Feb 22, 2222 at 12:00 AM"
        
        return date
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
    
    var dayOfWeek: String

    var tagValue: Int
    var isScrolling: Bool = false
    
    init(date: Date) {
        let tagValue = PickerManager.shared.getDateTagValue(date: date)
        
        self.date = date
        self.year = date.year
        self.month = date.month
        self.day = date.day
        self.hour = date.hour
        self.minute = date.minute
        self.second = date.second
        
        self.dayOfWeek = date.dayOfWeek
        
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
    
    mutating func updateTagValue(journals: [Journal]) {
        let tagValues = journals.map{ PickerManager.shared.getDateTagValue(date: $0.timestamp ?? Date()) }
        
        let tagValuePeriod = PickerManager.shared.getTagValuePeriod(year: self.year, month: self.month)
        
        let lastTagValue = tagValues.filter{ tagValuePeriod[0] <= $0 && $0 <= tagValuePeriod[1] }
        
        self.tagValue = lastTagValue.first ?? self.tagValue
    }
}

