//
//  MainTextView+Feature.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/20/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct MainTextFeature: Reducer {
    struct State: Equatable {
        var selectedEmotion: String
        var mainText: String?
        @PresentationState var drawingStyle: DrawingStyleFeature.State?
    }
    
    enum Action: Equatable {
        case inputMainText(_ mainText: String?)
        case showDrawingStyleView
        case drawingStyle(PresentationAction<DrawingStyleFeature.Action>)
    }
    
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .inputMainText(mainText):
                state.mainText = mainText
                return .none
                
            case .showDrawingStyleView:
                state.drawingStyle = .init(selectedEmotion: state.selectedEmotion, mainText: state.mainText ?? "")
                return .none
                
            default: return .none
            }
        }
        .ifLet(\.$drawingStyle, action: /Action.drawingStyle) {
            DrawingStyleFeature()
        }
    }
}
