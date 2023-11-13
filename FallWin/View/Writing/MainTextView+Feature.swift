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
        var mainText: String
        var pickedDateTagValue: DateTagValue = DateTagValue(date: Date())
        var isKeyboardShown: Bool
        
        @PresentationState var drawingStyle: DrawingStyleFeature.State?
    }
    
    enum Action: Equatable {
        case inputMainText(_ mainText: String)
        case showDrawingStyleView
        case pickDate(DateTagValue)
        case doneGenerating(Journal)
        case cancelWriting
        
        case drawingStyle(PresentationAction<DrawingStyleFeature.Action>)
        case showKeyboard(_ isKeyboardShown: Bool)
        
    }
    
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .inputMainText(mainText):
                state.mainText = mainText
                return .none
                
            case .showDrawingStyleView:
                state.drawingStyle = .init(selectedEmotion: state.selectedEmotion, mainText: state.mainText, pickedDateTagValue: state.pickedDateTagValue)
                return .none
                
            case let .pickDate(dateTagValue):
                state.pickedDateTagValue = dateTagValue
                return .none
                
            case .cancelWriting:
                return .none
                
            case .drawingStyle(.presented(.doneGenerating(let journal))):
                return .send(.doneGenerating(journal))
                
            case let .showKeyboard(isKeyboardShown):
                state.isKeyboardShown =  isKeyboardShown
                return .none
                
            case .drawingStyle(.presented(.cancelWriting)):
                return .send(.cancelWriting)
                
            case .drawingStyle(.presented(.pickDate(let dateTagValue))):
                return .send(.pickDate(dateTagValue))
                
            default: return .none
            }
        }
        .ifLet(\.$drawingStyle, action: /Action.drawingStyle) {
            DrawingStyleFeature()
        }
    }
}
