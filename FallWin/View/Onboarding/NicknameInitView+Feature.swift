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

    }
    
    enum Action: Equatable {
        case setNickname(String)
        case showNotificationSettingView
        case doneInitSetting
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setNickname(nickname):
                state.nickname = nickname
                return .none
                
//            case .showNotificationSettingView:
                
            case .doneInitSetting:
                return .none
                
            default: return .none
            }
        }
    }
}
