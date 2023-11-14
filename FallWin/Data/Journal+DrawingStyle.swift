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
    case waterColor = 12
    case crayon = 13
    case pixelArt = 14
    case monet = 15
    case dali = 16
}

extension DrawingStyle {
    init(rawName: String) {
        switch rawName {
        case "oilPainting": self = .oilPainting
        case "Oil Painting": self = .oilPainting
        case "sketch": self = .sketch
        case "Sketch": self = .sketch
        case "anime": self = .anime
        case "Anime": self = .anime
        case "vanGogh": self = .vanGogh
        case "Vincent Van Gogh": self = .vanGogh
        case "Childlike crayon": self = .crayon
        case "Water Color": self = .waterColor
        case "Pixel Art": self = .pixelArt
        case "Monet": self = .monet
        case "Salvador Dali": self = .dali
        case "renoir": self = .renoir
        case "chagall": self = .chagall
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
        case .waterColor:
            return "수채화"
        case .crayon:
            return "크레용"
        case .pixelArt:
            return "픽셀아트"
        case .monet:
            return "클로드 모네"
        case .dali:
            return "살바도르 달리"
        default: return "화풍 없음"
        }
    }
}
