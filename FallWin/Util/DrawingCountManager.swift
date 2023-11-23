//
//  DrawingCountManager.swift
//  FallWin
//
//  Created by 최명근 on 11/9/23.
//

import Foundation
import Kronos

struct DrawingCount: Hashable, Codable {
    var date: String
    var count: Int
}
//
//final class DrawingCountManager {
//    static let shared = DrawingCountManager()
//    static let INITIAL_COUNT = 3
//    static let debug: Bool = false
//    
//    private var drawingCount: DrawingCount?
//    
//    private init() {
//        Clock.sync { [self] date, _ in
//            let formatter = DateFormatter()
//            formatter.locale = .init(identifier: Locale.current.identifier)
//            formatter.timeZone = .init(identifier: TimeZone.current.identifier)
//            formatter.dateFormat = "yyyy-MM-dd"
//            let dateString = formatter.string(from: date)
//            
//            if let drawingCountValue = UserDefaults.standard.value(forKey: UserDefaultsKey.AppEnvironment.drawingCount) as? Data,
//               let drawingCount = try? PropertyListDecoder().decode(DrawingCount.self, from: drawingCountValue) {
//                if drawingCount.date == dateString {
//                    self.drawingCount = drawingCount
//                } else {
//                    self.drawingCount = DrawingCount(date: dateString, count: DrawingCountManager.INITIAL_COUNT)
//                    UserDefaults.standard.set(try! PropertyListEncoder().encode(self.drawingCount), forKey: UserDefaultsKey.AppEnvironment.drawingCount)
//                }
//            } else {
//                self.drawingCount = DrawingCount(date: dateString, count: DrawingCountManager.INITIAL_COUNT)
//                UserDefaults.standard.set(try! PropertyListEncoder().encode(self.drawingCount), forKey: UserDefaultsKey.AppEnvironment.drawingCount)
//            }
//        }
//    }
//    
//    var remainingCount: Int {
//        DrawingCountManager.debug ? 1 : drawingCount?.count ?? 0
//    }
//    
//    func reduceCount() {
//        if !DrawingCountManager.debug && (self.drawingCount?.count ?? 0) > 0 {
//            self.drawingCount?.count -= 1
//            UserDefaults.standard.set(try! PropertyListEncoder().encode(self.drawingCount), forKey: UserDefaultsKey.AppEnvironment.drawingCount)
//        }
//    }
//}
