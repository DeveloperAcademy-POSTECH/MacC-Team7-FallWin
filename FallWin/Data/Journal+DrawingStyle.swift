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
        case .none: return "ds_none".localized
        case .oilPainting:
            return "ds_oil_painting".localized
        case .sketch:
            return "ds_sketch".localized
        case .renoir:
            return "ds_renior".localized
        case .chagall:
            return "ds_chagall".localized
        case .anime:
            return "ds_anime".localized
        case .vanGogh:
            return "ds_van_gogh".localized
        case .kandinsky:
            return "ds_kandinsky".localized
        case .gauguin:
            return "ds_gauguin".localized
        case .picasso:
            return "ds_picasso".localized
        case .rembrandt:
            return "ds_rembrandt".localized
        case .henriRousseau:
            return "ds_henri_rousseau".localized
        case .waterColor:
            return "ds_water_color".localized
        case .crayon:
            return "ds_crayon".localized
        case .pixelArt:
            return "ds_pixel_art".localized
        case .monet:
            return "ds_monet".localized
        case .dali:
            return "ds_dali".localized
        default: return "ds_none".localized
        }
    }
}
