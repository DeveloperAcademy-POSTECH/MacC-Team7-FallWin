//
//  GalleryView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 10/17/23.
//

import Foundation
import SwiftUI
import CoreData
import ComposableArchitecture

struct GalleryFeature: Reducer {
    struct State: Equatable {
        var journals: [Journal] = []
        var renderId: UUID = UUID()
    }
    
    enum Action: Equatable {
        case fetchAll
        case updateView
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .fetchAll:
            let context = PersistenceController.debug.container.viewContext
            do {
                let fetchRequest = NSFetchRequest<Journal>(entityName: "Journal")
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Journal.timestamp), ascending: false)]
                state.journals = try context.fetch(fetchRequest)
            } catch {
                print(#function, error)
            }
            return .none
            
        case .updateView:
            
            return .none
            
        default: return .none
        }
    }
}
