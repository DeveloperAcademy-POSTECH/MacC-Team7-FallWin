//
//  MainTextView+Feature.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/20/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct FeedbackFeature: Reducer {
    struct State: Equatable {
        var feedbackText: String
    }
    
    enum Action: Equatable {
        case inputFeedbackText(_ mainText: String)
    }
    
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .inputFeedbackText(feedbackText):
                state.feedbackText = feedbackText
                return .none
                
            default: return .none
            }
        }
    }
}
