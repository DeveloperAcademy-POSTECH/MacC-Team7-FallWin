//
//  Feature.swift
//  FallWin
//
//  Created by 최명근 on 10/17/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct Feature: Reducer {
    struct State: Equatable {
        var tabSelection: TabItem = .gallery
        
        @PresentationState var gallery: GalleryFeature.State?
        @PresentationState var search: SearchFeature.State?
        @PresentationState var surf: SurfFeature.State?
        @PresentationState var profile: ProfileFeature.State?
    }
    
    enum Action: Equatable {
        case initViews
        case tabSelect(TabItem)
        
        case gallery(PresentationAction<GalleryFeature.Action>)
        case search(PresentationAction<SearchFeature.Action>)
        case surf(PresentationAction<SurfFeature.Action>)
        case profile(PresentationAction<ProfileFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .initViews:
                state.gallery = .init()
                state.search = .init()
                state.surf = .init()
                state.profile = .init()
                return .none
                
            case let .tabSelect(tab):
                state.tabSelection = tab
                return .none
                
            default: return .none
            }
        }
        .ifLet(\.$gallery, action: /Action.gallery) {
            GalleryFeature()
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
}
