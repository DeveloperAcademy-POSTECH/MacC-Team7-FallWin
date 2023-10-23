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
        var selectedDrawingStyle: String?
        @PresentationState var generatedDiary: GeneratedDiaryFeature.State?
    }
    
    enum Action: Equatable {
        case selectDrawingStyle(_ selectedDrawingStyle: String?)
        case showGeneratedDiaryView
        case doneGenerating(Journal)
        
        case generatedDiary(PresentationAction<GeneratedDiaryFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .selectDrawingStyle(style):
                state.selectedDrawingStyle = style
                return .none
                
            case .showGeneratedDiaryView:
                if let selectedDrawingStyle = state.selectedDrawingStyle {
                    state.generatedDiary = .init(selectedEmotion: state.selectedEmotion, mainText: state.mainText, selectedDrawingStyle: selectedDrawingStyle)
                }
                return .none
                
            case .generatedDiary(.presented(.doneImage(let journal))):
                return .send(.doneGenerating(journal))
                
            default: return .none
            }
        }
        .ifLet(\.$generatedDiary, action: /Action.generatedDiary) {
            GeneratedDiaryFeature()
        }
    }
}
