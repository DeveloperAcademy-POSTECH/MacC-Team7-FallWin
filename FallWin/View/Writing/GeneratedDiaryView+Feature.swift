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
    struct State: Equatable{
        var selectedEmotion: String
        var mainText: String
        var selectedDrawingStyle: String
        var image: UIImage?
        var imageSet: [UIImage?] = []
        var priorSteps: Double = 25.0
        var priorScale: Double = 5.0
        var steps: Double = 25.0
        var scale: Double = 5.0
    }
    
    
    enum Action: Equatable {
        case selectDrawingStyle(_ selectedDrawingStyle: String)
        case setImage(UIImage?)
        case setImages([UIImage?])
        case reduceCount
        case doneGenerating
        case doneImage(Journal)
        case setPriorSteps(_ priorSteps: Double)
        case setPriorScale(_ priorScale: Double)
        case setSteps(_ steps: Double)
        case setScale(_ scale: Double)
        case cancelWriting
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .selectDrawingStyle(selectedDrawingStyle):
            state.selectedDrawingStyle = selectedDrawingStyle
            return .none
            
        case let .setImage(image):
            state.image = image
            return .none
            
        case let .setImages(imageSet):
            state.imageSet = imageSet
            return .send(.reduceCount)
            
        case .reduceCount:
            DrawingCountManager.shared.reduceCount()
            return .none
            
        case .doneGenerating:
            let context = PersistenceController.shared.container.viewContext
            let journal = Journal(context: context)
            journal.content = state.mainText
            journal.mind = Mind(rawName: state.selectedEmotion).rawValue
            if let image = state.image {
                journal.setImage(image)
            }
            journal.drawingStyle = DrawingStyle(rawName: state.selectedDrawingStyle).rawValue
            journal.timestamp = Date()
            context.insert(journal)
            PersistenceController.shared.saveContext()
            return .send(.doneImage(journal))
            
        case let .setPriorSteps(priorSteps):
            state.priorSteps = priorSteps
            return .none
        
        case let .setPriorScale(priorScale):
            state.priorScale = priorScale
            return .none
            
        case let .setSteps(steps):
            state.steps = steps
            return .none
            
        case let .setScale(scale):
            state.scale = scale
            return .none
            
        case .cancelWriting:
            return .none
            
        default: return .none
        }
    }
}
//
//extension Equatable {
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        var isAllElementEqual: Bool = true
//        if lhs.count == rhs.count {
//            for i in 0..<lhs.count {
//                if lhs[i] != rhs[i] {
//                    isAllElementEqual = false
//                }
//            }
//        }
//        return isAllElementEqual
//    }
//}

