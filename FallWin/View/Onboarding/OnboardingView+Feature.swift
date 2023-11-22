//
//  OnboardingView+Feature.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/22/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct OnboardingFeature: Reducer {
    struct State: Equatable {
        var showNicknameInitView: Bool = false

        @PresentationState var nicknameInit: NicknameInitFeature.State?
    }
    
    enum Action: Equatable {
        case showNicknameInitView(Bool)
        case doneInitSetting
        
        case nicknameInit(PresentationAction<NicknameInitFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .showNicknameInitView(show):
                state.nicknameInit = .init()
                state.showNicknameInitView = show
                return .none
                
            case .doneInitSetting:
                return .none
                
            case .nicknameInit(.presented(.doneInitSetting)):
                return .send(.doneInitSetting)
                
            default: return .none
            }
        }
        .ifLet(\.$nicknameInit, action: /Action.nicknameInit) {
            NicknameInitFeature()
        }
    }
}


