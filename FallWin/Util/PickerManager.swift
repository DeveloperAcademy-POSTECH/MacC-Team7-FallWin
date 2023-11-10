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

//extension PickerManager {
//    
//    func initDateValue(date: Date) -> Int {
//        let year: Int = date.year
//        let month: Int = date.month
//        let day: Int = date.day
//        let hour: Int = date.hour
//        let minute: Int = date.minute
//        let second: Int = date.second
//        
//        return year * 1e10 + month * 1e8 + day * 1e6 + hour * 1e4 + minute * 1e2 + second
//    }
//    
//    
//}
