//
//  FeedbackView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 11/8/23.
//

import Foundation
import ComposableArchitecture

struct FeedbackFeature: Reducer {
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        default: return .none
        }
    }
}
