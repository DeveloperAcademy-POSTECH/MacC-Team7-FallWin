//
//  Journal+DrawingStyle.swift
//  FallWin
//
//  Created by 최명근 on 11/7/23.
//

import Foundation

extension Journal {
    var wrappedDrawingStyle: DrawingStyle {
        return DrawingStyle(rawValue: self.drawingStyle) ?? .none
    }
}

enum DrawingStyle: Int64 {
    case none = 0
    case oilPainting = 1
    case sketch = 2
    case renoir = 3
    case chagall = 4
    case anime = 5
    case vanGogh = 6
    case kandinsky = 7
    case gauguin = 8
    case picasso = 9
    case rembrandt = 10
    case henriRousseau = 11
}

extension DrawingStyle {
    init(rawName: String) {
        switch rawName {
        case "oilPainting": self = .oilPainting
        case "sketch": self = .sketch
        case "renoir": self = .renoir
        case "chagall": self = .chagall
        case "anime": self = .anime
        case "vanGogh": self = .vanGogh
        case "kandinsky": self = .kandinsky
        case "gauguin": self = .gauguin
        case "picasso": self = .picasso
        case "rembrandt": self = .rembrandt
        case "henriRousseau": self = .henriRousseau
        default: self = .none
        }
    }
    
    func name() -> String? {
        switch self {
        case .none: return "화풍 없음"
        case .oilPainting:
            return "유화"
        case .sketch:
            return "스케치"
        case .renoir:
            return "르누아르"
        case .chagall:
            return "샤갈"
        case .anime:
            return "애니메이션"
        case .vanGogh:
            return "반 고흐"
        case .kandinsky:
            return "칸딘스키"
        case .gauguin:
            return "고갱"
        case .picasso:
            return "피카소"
        case .rembrandt:
            return "램브란트"
        case .henriRousseau:
            return "앙리루소"
        default: return "화풍 없음"
        }
    }
}
