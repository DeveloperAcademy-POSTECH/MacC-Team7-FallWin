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
        
        var scrollRatio: CGFloat = 0
    }
    
    enum Action: Equatable {
        case setScrollRatio(CGFloat)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .setScrollRatio(ratio):
            state.scrollRatio = ratio
            return .none
            
        default:
            return .none
        }
    }
}
