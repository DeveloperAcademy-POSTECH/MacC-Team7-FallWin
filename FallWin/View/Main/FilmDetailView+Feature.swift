//
//  FilmDetailView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 12/1/23.
//

import Foundation
import ComposableArchitecture

struct FilmDetailFeature: Reducer {
    struct State: Equatable {
        var showAdFailAlert: Bool = false
    }
    
    enum Action: Equatable {
        case showAdFailAlert(Bool)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .showAdFailAlert(show):
            state.showAdFailAlert = show
            return .none
            
        default:
            return .none
        }
    }
}
