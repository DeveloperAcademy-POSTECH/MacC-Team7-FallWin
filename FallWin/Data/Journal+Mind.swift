//
//  Journal+Mind.swift
//  FallWin
//
//  Created by 최명근 on 11/7/23.
//

import Foundation

extension Journal {
    var wrappedMind: Mind {
        return Mind(rawValue: self.mind) ?? .none
    }
}

enum Mind: Int64 {
    case none = 0
    case happy = 1
    case nervous = 2
    case grateful = 3
    case sad = 4
    case joyful = 5
    case lonely = 6
    case proud = 7
    case suffocated = 8
    case touched = 9
    case shy = 10
    case exciting = 11
    case lazy = 12
    case annoyed = 13
    case frustrated = 14
    case tough = 15
    case peaceful = 16
    case surprised = 17
    case reassuring = 18
}

extension Mind {
    init(rawName: String) {
        switch rawName {
        case "happy": self = Mind.happy
        case "nervous": self = .nervous
        case "grateful": self = .grateful
        case "sad": self = .sad
        case "joyful": self = .joyful
        case "lonely": self = .lonely
        case "proud": self = .proud
        case "suffocated": self = .suffocated
        case "touched": self = .touched
        case "shy": self = .shy
        case "exciting": self = .exciting
        case "lazy": self = .lazy
        case "annoyed": self = .annoyed
        case "frustrated": self = .frustrated
        case "tough": self = .tough
        case "peaceful": self = .peaceful
        case "surprised": self = .surprised
        case "reassuring": self = .reassuring
        default: self = .none
        }
    }
    
    func string() -> String? {
        switch self {
        case .none: return nil
        case .happy: return "emotion_happy".localized
        case .nervous: return "emotion_nervous".localized
        case .grateful: return "emotion_grateful".localized
        case .sad: return "emotion_sad".localized
        case .joyful: return "emotion_joyful".localized
        case .lonely: return "emotion_lonely".localized
        case .proud: return "emotion_proud".localized
        case .suffocated: return "emotion_suffocated".localized
        case .touched: return "emotion_touched".localized
        case .shy: return "emotion_shy".localized
        case .exciting: return "emotion_exciting".localized
        case .lazy: return "emotion_lazy".localized
        case .annoyed: return "emotion_annoyed".localized
        case .frustrated: return "emotion_frustrated".localized
        case .tough: return "emotion_tough".localized
        case .peaceful: return "emotion_peaceful".localized
        case .surprised: return "emotion_surprise".localized
        case .reassuring: return "emotion_reassuring".localized
        default: return nil
        }
    }
    
    func iconName() -> String? {
        switch self {
        case .none: return nil
        case .happy: return "IconHappy"
        case .nervous: return "IconNervous"
        case .grateful: return "IconGrateful"
        case .sad: return "IconSad"
        case .joyful: return "IconJoyful"
        case .lonely: return "IconLonely"
        case .proud: return "IconProud"
        case .suffocated: return "IconSuffocated"
        case .touched: return "IconTouched"
        case .shy: return "IconShy"
        case .exciting: return "IconExciting"
        case .lazy: return "IconLazy"
        case .annoyed: return "IconAnnoyed"
        case .frustrated: return "IconFrustrated"
        case .tough: return "IconTough"
        case .peaceful: return "IconPeaceful"
        case .surprised: return "IconSurprised"
        case .reassuring: return "IconReassuring"
        default: return nil
        }
    }
}
