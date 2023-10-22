//
//  WritingView+Feature.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/18/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct WritingFeature: Reducer {
    struct State: Equatable {
        var selectedEmotion: String?
        @PresentationState var mainText: MainTextFeature.State?
    }
    
    enum Action: Equatable {
        case emotionSelection(_ selectedEmotion: String?)
        case showMainTextView(_ selectedEmotion: String?)
        case mainText(PresentationAction<MainTextFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .emotionSelection(selectedEmotion):
                state.selectedEmotion = selectedEmotion
                return .none
                
            case let .showMainTextView(emotion):
                state.mainText = .init(selectedEmotion: emotion ?? "", mainText: "")
                return .none
                
            default: return .none
            }
        }
        .ifLet(\.$mainText, action: /Action.mainText) {
            MainTextFeature()
        }
    }
}

