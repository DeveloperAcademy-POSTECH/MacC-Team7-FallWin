//
//  Journal+CoreDataProperties.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//
//

import Foundation
import CoreData
import UIKit

extension Journal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var content: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var mind: Int64
    @NSManaged public var image: String?
    
    var wrappedImage: UIImage? {
        if let image = self.image {
            return DataManager.shared.loadImage(name: image)
        } else {
            return nil
        }
    }

}

extension Journal : Identifiable {
}

extension Journal {
    func setImage(_ uiImage: UIImage) {
        self.image = DataManager.shared.saveImage(uiImage)
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
    
    func string() -> String? {
        switch self {
        case .none:
            return nil
        case .happy:
            return "행복한"
        case .nervous:
            return "불안한"
        case .grateful:
            return "감사한"
        case .sad:
            return "슬픈"
        case .joyful:
            return "신나는"
        case .lonely:
            return "외로운"
        case .proud:
            return "뿌듯함"
        case .suffocated:
            return "답답함"
        case .touched:
            return "감동받은"
        case .shy:
            return "부끄러운"
        case .exciting:
            return "기대되는"
        case .lazy:
            return "귀찮음"
        case .annoyed:
            return "짜증나는"
        case .frustrated:
            return "당황한"
        }
    }
    
    func iconName() -> String? {
        switch self {
        case .none:
            return nil
        case .happy:
            return "IconHappy"
        case .nervous:
            return "IconNervous"
        case .grateful:
            return "IconGrateful"
        case .sad:
            return "IconSad"
        case .joyful:
            return "IconJoyful"
        case .lonely:
            return "IconLonely"
        case .proud:
            return "IconProud"
        case .suffocated:
            return "IconSuffocated"
        case .touched:
            return "IconTouched"
        case .shy:
            return "IconShy"
        case .exciting:
            return "IconExciting"
        case .lazy:
            return "IconLazy"
        case .annoyed:
            return "IconAnnoyed"
        case .frustrated:
            return "IconFrustrated"
        }
    }
}
