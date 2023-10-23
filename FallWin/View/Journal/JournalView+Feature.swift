//
//  JournalView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 10/19/23.
//

import Foundation
import ComposableArchitecture

struct JournalFeature: Reducer {
    struct State: Equatable {
        var journal: Journal
        var dismiss: Bool = false
    }
    
    enum Action: Equatable {
        case delete
        case dismiss
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .delete:
            let context = PersistenceController.shared.container.viewContext
            context.delete(state.journal)
            do {
                try context.save()
            } catch {
                print(error)
            }
            return .send(.dismiss)
            
        case .dismiss:
            state.dismiss = true
            return .none
        }
    }
}
