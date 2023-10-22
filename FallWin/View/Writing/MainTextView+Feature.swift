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
        var navPath: NavigationPath
    }
    
    enum Action: Equatable {
        case inputMainText(_ mainText: String?)
        case appendNavPath(_ navPathState: NavPathState)
        case clearNavPath
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .inputMainText(mainText):
            state.mainText = mainText
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
