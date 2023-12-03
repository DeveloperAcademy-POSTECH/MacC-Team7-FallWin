//
//  NicknameInitView+Feature.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/22/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct NicknameInitFeature: Reducer {
    struct State: Equatable {
        var nickname: String = ""
        
        @PresentationState var notificationInit: NotificationInitFeature.State?

    }
    
    enum Action: Equatable {
        case setNickname(String)
        case clearNickname
        case showNotificationInitView
        case doneInitSetting
        
        case notificationInit(PresentationAction<NotificationInitFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setNickname(nickname):
                state.nickname = nickname
                return .none
                
            case let .clearNickname:
                state.nickname = ""
                return .none
                
            case .showNotificationInitView:
                state.notificationInit = .init()
                return .none
                
            case .doneInitSetting:
                UserDefaults.standard.set(state.nickname, forKey: UserDefaultsKey.User.nickname)
                return .none
                
            case .notificationInit(.presented(.doneInitSetting)):
                return .send(.doneInitSetting)
                
            default: return .none
            }
        }
        .ifLet(\.$notificationInit, action: /Action.notificationInit) {
            NotificationInitFeature()
        }
    }
}
