//
//  SettingsView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 11/7/23.
//

import Foundation
import ComposableArchitecture

struct SettingsFeature: Reducer {
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default: return .none
            }
        }
    }
}
