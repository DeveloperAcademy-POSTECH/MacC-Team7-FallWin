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
        var pickedDateTagValue: DateTagValue = DateTagValue(date: Date())
        var isPickerShown: Bool = false

        @PresentationState var mainText: MainTextFeature.State?
    }
    
    enum Action: Equatable {
        case emotionSelection(_ selectedEmotion: String?)
        case pickDate(DateTagValue)
        case showMainTextView(_ selectedEmotion: String?)
        case doneGenerating(Journal)
        case showPickerSheet
        case cancelWriting
        
        case mainText(PresentationAction<MainTextFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .emotionSelection(selectedEmotion):
                state.selectedEmotion = selectedEmotion
                return .none
                
            case let .pickDate(dateTagValue):
                state.pickedDateTagValue = dateTagValue
                return .none
                
            case let .showMainTextView(emotion):
                state.mainText = .init(selectedEmotion: emotion ?? "", mainText: "", pickedDateTagValue: state.pickedDateTagValue, isKeyboardShown: true)
                return .none
                
            case .showPickerSheet:
                state.isPickerShown.toggle()
                return .none
                
            case .cancelWriting:
                return .none
                
            case .mainText(.presented(.doneGenerating(let journal))):
                return .send(.doneGenerating(journal))
                
            case .mainText(.presented(.cancelWriting)):
                return .send(.cancelWriting)
                
            case .mainText(.presented(.pickDate(let dateTagValue))):
                return .send(.pickDate(dateTagValue))
                
            default: return .none
            }
        }
        .ifLet(\.$mainText, action: /Action.mainText) {
            MainTextFeature()
        }
    }
}

