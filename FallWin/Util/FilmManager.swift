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
    static let INITIAL_COUNT = 1
    static var unlimited: Bool = false
    var drawingCount: DrawingCount? {
        didSet {
            NotificationCenter.default.post(name: .filmCountChanged, object: nil)
        }
    }
    
    private init() {
        self.drawingCount = nil
        
        let _ = NetworkModel { isConnected in
            if !isConnected {
                return
            }
            
            Clock.sync(completion: { [self] date, _ in
                guard let date = date else {
                    return
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                var dateString: String = formatter.string(from: date)
                #if DEBUG
                print("real: \(dateString)")
                dateString = formatter.string(from: Date())
                print("sim: \(dateString)")
                #endif
                
                if let drawingCountValue = UserDefaults.standard.value(forKey: UserDefaultsKey.AppEnvironment.drawingCount) as? Data,
                   let drawingCount = try? PropertyListDecoder().decode(DrawingCount.self, from: drawingCountValue) {
                    if drawingCount.date == dateString {
                        self.drawingCount = drawingCount
                    } else {
                        self.drawingCount = DrawingCount(date: dateString, count: FilmManager.INITIAL_COUNT)
                        UserDefaults.standard.set(try! PropertyListEncoder().encode(self.drawingCount), forKey: UserDefaultsKey.AppEnvironment.drawingCount)
                    }
                } else {
                    self.drawingCount = DrawingCount(date: dateString, count: FilmManager.INITIAL_COUNT)
                    UserDefaults.standard.set(try! PropertyListEncoder().encode(self.drawingCount), forKey: UserDefaultsKey.AppEnvironment.drawingCount)
                }
            })
        }
    }
    
    func reduceCount() {
        if (self.drawingCount?.count ?? 0) > 0 && !FilmManager.unlimited {
            self.drawingCount?.count -= 1
            UserDefaults.standard.set(try! PropertyListEncoder().encode(self.drawingCount), forKey: UserDefaultsKey.AppEnvironment.drawingCount)
        }
    }
    
    func increaseCount(_ amount: Int = 1) {
        self.drawingCount?.count += amount
        UserDefaults.standard.set(try! PropertyListEncoder().encode(self.drawingCount), forKey: UserDefaultsKey.AppEnvironment.drawingCount)
    }
    
    func resetCount() {
        self.drawingCount?.count = FilmManager.INITIAL_COUNT
        UserDefaults.standard.set(try! PropertyListEncoder().encode(self.drawingCount), forKey: UserDefaultsKey.AppEnvironment.drawingCount)
    }
    
    func notify() {
        NotificationCenter.default.post(name: .filmCountChanged, object: nil)
    }
}
