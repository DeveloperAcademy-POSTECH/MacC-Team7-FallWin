//
//  JournalWritingView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 11/14/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct JournalWritingFeature: Reducer {
    struct State: Equatable {
        var selectedTab: JournalWritingTab = .mind
        var mind: Mind? = nil
        var content: String = ""
        var drawingStyle: DrawingStyle? = nil
    }
    
    enum Action: Equatable {
        case selectTab(JournalWritingTab)
        case setMind(Mind?)
        case setContent(String)
        case setDrawingStyle(DrawingStyle?)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .selectTab(tab):
            withAnimation {
                state.selectedTab = tab
            }
            return .none
            
        case let .setMind(mind):
            state.mind = mind
            return .none
            
        case let .setContent(content):
            state.content = content
            return .none
            
        case let .setDrawingStyle(style):
            state.drawingStyle = style
            return .none
        }
    }
}
