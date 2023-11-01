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
        var tabSelection: TabItem = .gallery
        var hideTabBar: Bool = false
        var invisible: Bool = false
        var lock: Bool = false
        var showPasscodeView: Bool = true
        
        @PresentationState var gallery: GalleryFeature.State?
        @PresentationState var main: MainFeature.State?
        @PresentationState var search: SearchFeature.State?
        @PresentationState var surf: SurfFeature.State?
        @PresentationState var profile: ProfileFeature.State?
    }
    
    enum Action: Equatable {
        case initViews
        case tabSelect(TabItem)
        case hideTabBar(Bool)
        case setInvisibility(Bool)
        case setLock(Bool)
        case showPasscodeView(Bool)
        
        case gallery(PresentationAction<GalleryFeature.Action>)
        case main(PresentationAction<MainFeature.Action>)
        case search(PresentationAction<SearchFeature.Action>)
        case surf(PresentationAction<SurfFeature.Action>)
        case profile(PresentationAction<ProfileFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .initViews:
                state.gallery = .init()
                state.main = .init()
                state.search = .init()
                state.surf = .init()
                state.profile = .init()
                return .none
                
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
                
            case let .gallery(action):
                return handleGalleryAction(state: &state, action: action)
                
            default: return .none
            }
        }
        .ifLet(\.$gallery, action: /Action.gallery) {
            GalleryFeature()
        }
        .ifLet(\.$main, action: /Action.main) {
            MainFeature()
        }
        .ifLet(\.$search, action: /Action.search) {
            SearchFeature()
        }
        .ifLet(\.$surf, action: /Action.surf) {
            SurfFeature()
        }
        .ifLet(\.$profile, action: /Action.profile) {
            ProfileFeature()
        }
    }
    
    private func handleGalleryAction(state: inout State, action: PresentationAction<GalleryFeature.Action>) -> Effect<Action> {
        switch action {
        case .presented(.hideTabBar(let hide)):
            return .send(.hideTabBar(hide))
            
        default:
            return .none
        }
    }
}
