//
//  Feature.swift
//  FallWin
//
//  Created by 최명근 on 10/17/23.
//

import Foundation
import SwiftUI
import SwiftKeychainWrapper
import ComposableArchitecture

struct Feature: Reducer {
    struct State: Equatable {
        var tabSelection: Int = 0
        var hideTabBar: Bool = false
        var invisible: Bool = false
        var lock: Bool = false
        var showPasscodeView: Bool = true
        
        @PresentationState var main: MainFeature.State? = .init()
        @PresentationState var search: SearchFeature.State? = .init()
        @PresentationState var settings: SettingsFeature.State? = .init()
        @PresentationState var onboarding: OnboardingFeature.State? = .init()
    }
    
    enum Action: Equatable {
        case tabSelect(Int)
        case hideTabBar(Bool)
        case setInvisibility(Bool)
        case setLock(Bool)
        case showPasscodeView(Bool)
        case setProfileNickname(String?)
        
        case main(PresentationAction<MainFeature.Action>)
        case search(PresentationAction<SearchFeature.Action>)
        case settings(PresentationAction<SettingsFeature.Action>)
        case onboarding(PresentationAction<OnboardingFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .tabSelect(tab):
                state.tabSelection = tab
                return .none
                
            case let .hideTabBar(hide):
                withAnimation {
                    state.hideTabBar = hide
                }
                return .none
                
            case let .setInvisibility(invisible):
                state.invisible = invisible
                return .none
                
            case let .setLock(lock):
                state.lock = lock
                return .none
                
            case let .showPasscodeView(show):
                state.showPasscodeView = show
                return .none
                
            case let .setProfileNickname(nickname):
                state.settings?.nickname = nickname ?? ""
                return .none
                
            case let .main(action):
                return handleMainAction(state: &state, action: action)
                
            case .onboarding(.presented(.doneInitSetting)):
                let nickname = state.onboarding?.nicknameInit?.nickname
                state.onboarding?.nicknameInit = nil
                state.onboarding = nil
                return .send(.setProfileNickname(nickname))
                
            default: return .none
            }
        }
        .ifLet(\.$main, action: /Action.main) {
            MainFeature()
        }
        .ifLet(\.$search, action: /Action.search) {
            SearchFeature()
        }
        .ifLet(\.$settings, action: /Action.settings) {
            SettingsFeature()
        }
        .ifLet(\.$onboarding, action: /Action.onboarding) {
            OnboardingFeature()
        }
    }
    
    private func handleMainAction(state: inout State, action: PresentationAction<MainFeature.Action>) -> Effect<Action> {
        switch action {
        case .presented(.hideTabBar(let hide)):
            return .send(.hideTabBar(hide))
            
        default:
            return .none
        }
    }
}
