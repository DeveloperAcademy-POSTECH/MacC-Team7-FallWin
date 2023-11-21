//
//  TextEditView+Feature.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/21/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct TextEditFeature: Reducer {
    struct State: Equatable {
        var journal: Journal
        var tempText: String
    }
    
    enum Action: Equatable {
        case updateTempText(String)
        case saveText
        case cancelEditing
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .updateTempText(tempText):
            state.tempText = tempText
            return .none
            
        case .saveText:
            state.journal.content = state.tempText
            let context = PersistenceController.shared.container.viewContext
            do {
                try context.save()
            } catch {
                print(error)
            }
            return .send(.cancelEditing)
            
        case .cancelEditing:
            return .none
        }
    }
}
