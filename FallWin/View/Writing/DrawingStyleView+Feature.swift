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
        var priorSteps: Double = 25.0
        var priorScale: Double = 5.0
        var steps: Double = 25.0
        var scale: Double = 5.0
        @PresentationState var generatedDiary: GeneratedDiaryFeature.State?
    }
    
    enum Action: Equatable {
        case selectDrawingStyle(_ selectedDrawingStyle: String?)
        case showGeneratedDiaryView
        case doneGenerating(Journal)
        case setPriorSteps(_ priorSteps: Double)
        case setPriorScale(_ priorScale: Double)
        case setSteps(_ steps: Double)
        case setScale(_ scale: Double)
        
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
                    state.generatedDiary = .init(selectedEmotion: state.selectedEmotion, mainText: state.mainText, selectedDrawingStyle: selectedDrawingStyle, priorSteps: state.priorSteps, priorScale: state.priorScale, steps: state.steps, scale: state.scale)
                }
                return .none
                
            case let .setPriorSteps(priorSteps):
                state.priorSteps = priorSteps
                return .none
            
            case let .setPriorScale(priorScale):
                state.priorScale = priorScale
                return .none
                
            case let .setSteps(steps):
                state.steps = steps
                return .none
                
            case let .setScale(scale):
                state.scale = scale
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
