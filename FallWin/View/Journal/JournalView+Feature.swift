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
        var invisible: Bool = false
        var lock: Bool = false
        var showPasscodeView: Bool = false
        var dismiss: Bool = false
    }
    
    enum Action: Equatable {
        case setInvisibility(Bool)
        case setLock(Bool)
        case showPasscodeView(Bool)
        
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
            
        case let .setInvisibility(invisible):
            state.invisible = invisible
            return .none
            
        case let .setLock(lock):
            state.lock = lock
            return .none
            
        case let .showPasscodeView(show):
            state.showPasscodeView = show
            return .none
            
        case .dismiss:
            state.dismiss = true
            return .none
        }
    }
}
