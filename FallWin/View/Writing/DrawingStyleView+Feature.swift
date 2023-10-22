//
//  DrawingStyleView+Feature.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/22/23.
//

import Foundation
import ComposableArchitecture

struct DrawingStyleFeature: Reducer {
    struct State: Equatable {
        var selectedEmotion: String
        var mainText: String
    }
    
    enum Action: Equatable {
        
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
            
        default: return .none
        }
    }
}
