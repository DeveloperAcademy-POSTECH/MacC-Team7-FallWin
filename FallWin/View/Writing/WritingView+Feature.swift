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
        var navPath: NavigationPath = .init()
    }
    
    enum Action: Equatable {
        case emotionSelection(_ selectedEmotion: String?)
        case appendNavPath(_ navPathState: NavPathState)
        case clearNavPath
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .emotionSelection(selectedEmotion):
            state.selectedEmotion = selectedEmotion
            return .none
            
        case let .appendNavPath(navPathState):
            state.navPath.append(navPathState)
            return .none
            
        case .clearNavPath:
            state.navPath = .init()
            return .none
            
        default: return .none
        }
    }
}

