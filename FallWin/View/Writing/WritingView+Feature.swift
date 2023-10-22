//
//  WritingView+Feature.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/18/23.
//

import Foundation
import ComposableArchitecture

struct WritingFeature: Reducer {
    struct State: Equatable {
        var selectedEmotion: String?
    }
    
    enum Action: Equatable {
        case emotionSelection(_ selectedEmotion: String?)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .emotionSelection(selectedEmotion):
            state.selectedEmotion = selectedEmotion
            return .none
            
        default: return .none
        }
    }
}

