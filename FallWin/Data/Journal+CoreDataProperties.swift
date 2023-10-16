//
//  Journal+CoreDataProperties.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//
//

import Foundation
import CoreData


extension Journal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var content: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var mind: Int64
    @NSManaged public var image: String?

}

extension Journal : Identifiable {

}
