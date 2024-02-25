//
//  DrawCountManager.swift
//  FallWin
//
//  Created by 최명근 on 2/23/24.
//

import Foundation

final class DrawCountManager {
    static let shared = DrawCountManager()
    
    private init() { }
    
    func getCount() -> Int {
        if let drawCount = DrawCount.fetch(date: Date().drawCountString) {
            return Int(drawCount.count)
        } else {
            DrawCount.setCount(date: Date())
            return 0
        }
    }
    
    func setCount(count: Int = 1) {
        DrawCount.setCount(date: Date())
    }
}
