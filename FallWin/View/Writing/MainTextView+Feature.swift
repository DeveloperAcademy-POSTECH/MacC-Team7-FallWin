//
//  MainTextView+Feature.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/20/23.
//

import Foundation
import ComposableArchitecture

struct MainTextFeature: Reducer {
    struct State: Equatable {
        var selectedEmotion: String
        var mainText: String?
    }
    
    enum Action: Equatable {
        case inputMainText(_ mainText: String?)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .inputMainText(mainText):
            state.mainText = mainText
            return .none
            
        default: return .none
        }
    }
}
