//
//  FilmManager.swift
//  FallWin
//
//  Created by 최명근 on 11/22/23.
//

import Foundation
import Kronos

final class FilmManager {
    static let shared = FilmManager()
    static let INITIAL_COUNT = 3
    static let debug: Bool = false
    
    var drawingCount: DrawingCount? {
        didSet {
            NotificationCenter.default.post(name: .filmCountChanged, object: nil)
        }
    }
    
    private init() {
        self.drawingCount = nil
        
        Clock.sync { [self] date, _ in
            print(date)
            if let drawingCountValue = UserDefaults.standard.value(forKey: UserDefaultsKey.AppEnvironment.drawingCount) as? Data,
               let drawingCount = try? PropertyListDecoder().decode(DrawingCount.self, from: drawingCountValue), !FilmManager.debug {
                if drawingCount.date == date.dateString {
                    self.drawingCount = drawingCount
                } else {
                    self.drawingCount = DrawingCount(date: date.dateString, count: FilmManager.INITIAL_COUNT)
                    UserDefaults.standard.set(try! PropertyListEncoder().encode(self.drawingCount), forKey: UserDefaultsKey.AppEnvironment.drawingCount)
                }
            } else {
                self.drawingCount = DrawingCount(date: date.dateString, count: FilmManager.INITIAL_COUNT)
                UserDefaults.standard.set(try! PropertyListEncoder().encode(self.drawingCount), forKey: UserDefaultsKey.AppEnvironment.drawingCount)
            }
        }
    }
    
    func reduceCount() {
        if !FilmManager.debug && (self.drawingCount?.count ?? 0) > 0 {
            self.drawingCount?.count -= 1
            UserDefaults.standard.set(try! PropertyListEncoder().encode(self.drawingCount), forKey: UserDefaultsKey.AppEnvironment.drawingCount)
        }
    }
    
    func notify() {
        NotificationCenter.default.post(name: .filmCountChanged, object: nil)
    }
}
