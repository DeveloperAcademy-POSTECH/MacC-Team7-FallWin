//
//  Journal+JSON.swift
//  FallWin
//
//  Created by 최명근 on 11/10/23.
//

import Foundation

extension Journal {
    static func insert(_ raw: RawJournal) {
        let context = PersistenceController.shared.container.viewContext
        
        let journal = Journal(context: context)
        journal.id = raw.id
        journal.content = raw.content
        journal.timestamp = raw.timestamp
        journal.mind = Int64(raw.mind)
        journal.drawingStyle = Int64(raw.drawingStyle)
        journal.image = raw.image
        
        context.insert(journal)
        
        do {
            try context.save()
        } catch {
            print(#function, error)
        }
    }
    
    static func insert(_ raws: [RawJournal]) {
        let context = PersistenceController.shared.container.viewContext
        
        for raw in raws {
            let journal = Journal(context: context)
            journal.id = raw.id
            journal.content = raw.content
            journal.timestamp = raw.timestamp
            journal.mind = Int64(raw.mind)
            journal.drawingStyle = Int64(raw.drawingStyle)
            journal.image = raw.image
            
            context.insert(journal)
        }
        
        do {
            try context.save()
        } catch {
            print(#function, error)
        }
    }
}
