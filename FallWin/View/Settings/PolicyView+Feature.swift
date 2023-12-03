//
//  PolicySettingView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 11/8/23.
//

import Foundation
import ComposableArchitecture

struct PolicyFeature: Reducer {
    struct State: Equatable {
        var license: LicenseFeature.State = .init()
    }
    
    enum Action: Equatable {
        case license(LicenseFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.license, action: /Action.license) {
            LicenseFeature()
        }
        
        Reduce { state, action in
            switch action {
            default: return .none
            }
        }
    }
}
