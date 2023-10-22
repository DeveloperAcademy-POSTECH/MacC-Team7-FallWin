//
//  GeneratedDiaryView+Feature.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/22/23.
//

import Foundation
import ComposableArchitecture

struct GeneratedDiaryFeature: Reducer {
    struct State: Equatable {
        var selectedEmotion: String
        var mainText: String
        var selectedDrawingStyle: String
    }
    
    enum Action: Equatable {
        case selectDrawingStyle(_ selectedDrawingStyle: String)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .selectDrawingStyle(selectedDrawingStyle):
            state.selectedDrawingStyle = selectedDrawingStyle
            return .none
            
        default: return .none
        }
    }
}

