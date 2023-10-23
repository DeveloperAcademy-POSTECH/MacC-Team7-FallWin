//
//  GeneratedDiaryView+Feature.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/22/23.
//

import Foundation
import UIKit
import ComposableArchitecture

struct GeneratedDiaryFeature: Reducer {
    struct State: Equatable {
        var selectedEmotion: String
        var mainText: String
        var selectedDrawingStyle: String
        var image: UIImage?
    }
    
    enum Action: Equatable {
        case selectDrawingStyle(_ selectedDrawingStyle: String)
        case setImage(UIImage)
        case doneGenerating
        case doneImage(Journal)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .selectDrawingStyle(selectedDrawingStyle):
            state.selectedDrawingStyle = selectedDrawingStyle
            return .none
            
        case let .setImage(image):
            state.image = image
            return .none
            
        case .doneGenerating:
            let context = PersistenceController.shared.container.viewContext
            let journal = Journal(context: context)
            journal.content = state.mainText
            journal.mind = getMind(mind: state.selectedEmotion).rawValue
            if let image = state.image {
                journal.setImage(image)
            }
            journal.timestamp = Date()
            context.insert(journal)
            PersistenceController.shared.saveContext()
            return .send(.doneImage(journal))
            
        default: return .none
        }
    }
    
    private func getMind(mind: String) -> Mind {
        switch mind {
        case "happy":
            return Mind.happy
            
        case "nervous":
            return .nervous
            
        case "grateful":
            return .grateful
            
        case "sad":
            return .sad
            
        case "joyful":
            return .joyful
            
        case "lonely":
            return .lonely
            
        case "proud":
            return .proud
            
        case "suffocated":
            return .suffocated
            
        case "touched":
            return .touched
            
        case "shy":
            return .shy
            
        case "exciting":
            return .exciting
            
        case "lazy":
            return .lazy
            
        case "annoyed":
            return .annoyed
            
        case "frustrated":
            return .frustrated
            
        default:
            return .none
        }
    }
}

