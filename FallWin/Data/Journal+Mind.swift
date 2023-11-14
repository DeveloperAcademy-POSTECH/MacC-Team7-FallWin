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
        case .happy: return "행복한"
        case .nervous: return "불안한"
        case .grateful: return "감사한"
        case .sad: return "슬픈"
        case .joyful: return "신나는"
        case .lonely: return "외로운"
        case .proud: return "뿌듯함"
        case .suffocated: return "답답함"
        case .touched: return "감동받은"
        case .shy: return "부끄러운"
        case .exciting: return "기대되는"
        case .lazy: return "귀찮음"
        case .annoyed: return "짜증나는"
        case .frustrated: return "당황한"
        case .tough: return "힘든"
        case .peaceful: return "평온한"
        case .surprised: return "놀란"
        case .reassuring: return "안심되는"
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
