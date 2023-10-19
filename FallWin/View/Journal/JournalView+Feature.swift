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
    }
    
    enum Action: Equatable {
        
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        
    }
}
