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
