//
//  DrawCount+CoreDataProperties.swift
//  FallWin
//
//  Created by 최명근 on 2/23/24.
//
//

import Foundation
import CoreData


extension DrawCount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrawCount> {
        return NSFetchRequest<DrawCount>(entityName: "DrawCount")
    }

    @NSManaged public var date: String
    @NSManaged public var count: Int64

}

extension DrawCount : Identifiable {

}

extension DrawCount {
    static func fetch(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext, date: String) -> DrawCount? {
        do {
            let fetchRequest = NSFetchRequest<DrawCount>(entityName: "DrawCount")
            fetchRequest.predicate = NSPredicate(format: "date == %@", date)
            return try context.fetch(fetchRequest).first
        } catch {
            print(#function, error)
            return nil
        }
    }
    
    static func setCount(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext, date: Date) {
        let dateString = date.drawCountString
        if let drawCount = DrawCount.fetch(context: context, date: dateString) {
            drawCount.count += 1
            
        } else {
            let drawCount = DrawCount(context: context)
            drawCount.date = dateString
            drawCount.count = 0
            context.insert(drawCount)
        }
    }
}
