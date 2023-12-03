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
        var showPolicyAlert: Bool = false
        var showMarketingPolicyView: Bool = false
        
        @PresentationState var nicknameInit: NicknameInitFeature.State?
    }
    
    enum Action: Equatable {
        case showPolicyAlert(Bool)
        case showMarketingPolicyView(Bool)
        case showNicknameInitView
        case doneInitSetting
        
        case nicknameInit(PresentationAction<NicknameInitFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .showPolicyAlert(show):
                state.showPolicyAlert = show
                return .none
                
            case let .showMarketingPolicyView(show):
                state.showMarketingPolicyView = show
                return .none
                
            case .showNicknameInitView:
                state.nicknameInit = .init()
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


