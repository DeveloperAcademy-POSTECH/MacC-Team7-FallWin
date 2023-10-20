//
//  PersistenceManager.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//

import Foundation
import CoreData

final class PersistenceController {
    static let shared = PersistenceController()
    static let debug = PersistenceController(inMemory: true)
    let container: NSPersistentContainer
    
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Journal")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                print(#function, error)
            }
        }
    }
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(#function, error)
            }
        }
    }
    
}
