//
//  NotificationInitView+Feature.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/28/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct NotificationInitFeature: Reducer {
    struct State: Equatable {
        var time: String = ""
        
    }
    
    enum Action: Equatable {
        case setTime
        case doneInitSetting
        
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .setTime:
            return .none
            
        case .doneInitSetting:
            return .none
            
        default:
            return .none
        }
    }
}
