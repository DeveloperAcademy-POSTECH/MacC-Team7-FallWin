//
//  Date+Exntesion.swift
//  FallWin
//
//  Created by 최명근 on 10/12/23.
//


import Foundation

extension Date {
    
    init(timeInMillis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(timeInMillis) / 1000)
    }
    
    init(timeInMillis: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(timeInMillis) / 1000)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    var dateString: String {
        return "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))"
    }
    
    var timeString: String {
        return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second))"
    }
    
    var fullString: String {
        return "\(dateString) \(timeString)"
    }
    
    var fullStringWithoutSpaces: String {
        return "\(dateString)-\(timeInMillis)"
    }
    
    var journalShareString: String {
        return "\(year).\(String(format: "%02d", month)).\(String(format: "%02d", day)). \(dayOfWeek)요일"
    }
    
    var timeInMillis: Int64 {
        get {
            return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        }
    }
    
    var dayOfWeek: String {
        let dayOfWeek = Calendar.current.component(.weekday, from: self)
        switch dayOfWeek {
        case 1: return "week_sunday_short".localized
        case 2: return "week_monday_short".localized
        case 3: return "week_tuesday_short".localized
        case 4: return "week_wednesday_short".localized
        case 5: return "week_thursday_short".localized
        case 6: return "week_friday_short".localized
        case 7: return "week_saturday_short".localized
        default: return ""
        }
    }
    
}
