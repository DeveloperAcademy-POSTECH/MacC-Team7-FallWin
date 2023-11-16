//
//  DrawingCountManager.swift
//  FallWin
//
//  Created by 최명근 on 11/9/23.
//

import Foundation

struct DrawingCount: Hashable, Codable {
    var date: String
    var count: Int
}

final class DrawingCountManager {
    static let shared = DrawingCountManager()
    static let INITIAL_COUNT = 3
    static let debug: Bool = false
    
    private var drawingCount: DrawingCount
    
    private init() {
        if let drawingCountValue = UserDefaults.standard.value(forKey: UserDefaultsKey.AppEnvironment.drawingCount) as? Data,
           let drawingCount = try? PropertyListDecoder().decode(DrawingCount.self, from: drawingCountValue) {
            if drawingCount.date == Date().dateString {
                self.drawingCount = drawingCount
            } else {
                self.drawingCount = DrawingCount(date: Date().dateString, count: DrawingCountManager.INITIAL_COUNT)
                UserDefaults.standard.set(try! PropertyListEncoder().encode(self.drawingCount), forKey: UserDefaultsKey.AppEnvironment.drawingCount)
            }
        } else {
            self.drawingCount = DrawingCount(date: Date().dateString, count: DrawingCountManager.INITIAL_COUNT)
            UserDefaults.standard.set(try! PropertyListEncoder().encode(self.drawingCount), forKey: UserDefaultsKey.AppEnvironment.drawingCount)
        }
    }
    
    var remainingCount: Int {
        DrawingCountManager.debug ? 1 : drawingCount.count
    }
    
    func reduceCount() -> Int {
        if !DrawingCountManager.debug && self.drawingCount.count > 0 {
            self.drawingCount.count -= 1
            print("count saved", drawingCount)
            UserDefaults.standard.set(try! PropertyListEncoder().encode(self.drawingCount), forKey: UserDefaultsKey.AppEnvironment.drawingCount)
            print("count saved", drawingCount)
        }
        print(self.drawingCount)
        return self.drawingCount.count
    }
}
