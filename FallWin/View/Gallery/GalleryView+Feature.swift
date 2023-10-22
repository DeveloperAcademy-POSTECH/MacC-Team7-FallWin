//
//  GalleryView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 10/17/23.
//

import Foundation
import SwiftUI
import CoreData
import ComposableArchitecture

struct GalleryFeature: Reducer {
    struct State: Equatable {
        var journals: [Journal] = []
        var carouselIndex: Int = 0
        var date: Date = Date()
        var hasNextMonth: Bool {
            date.year <= Date().year && date.month < Date().month
        }
        
        @PresentationState var journal: JournalFeature.State?
        @PresentationState var writing: WritingFeature.State?
    }
    
    enum Action: Equatable {
        case fetchAll
        case setCarouselIndex(Int)
        case prevMonth
        case nextMonth
        case showJournalView(Journal)
        case showWritingView
        case hideTabBar(Bool)
        
        case journal(PresentationAction<JournalFeature.Action>)
        case writing(PresentationAction<WritingFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchAll:
                let context = PersistenceController.debug.container.viewContext
                do {
                    let fetchRequest = NSFetchRequest<Journal>(entityName: "Journal")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Journal.timestamp), ascending: false)]
                    state.journals = try context.fetch(fetchRequest)
                } catch {
                    print(#function, error)
                }
                return .none
                
            case let .setCarouselIndex(index):
                state.carouselIndex = index
                return .none
                
            case .prevMonth:
                state.date = Calendar.current.date(byAdding: .month, value: -1, to: state.date) ?? Date()
                return .none
                
            case .nextMonth:
                state.date = Calendar.current.date(byAdding: .month, value: 1, to: state.date) ?? Date()
                return .none
                
            case let .showJournalView(journal):
                state.journal = .init(journal: journal)
                return .none
                
            case .showWritingView:
                state.writing = .init()
                return .none
                
            default: return .none
            }
        }
        .ifLet(\.$journal, action: /Action.journal) {
            JournalFeature()
        }
        .ifLet(\.$writing, action: /Action.writing) {
            WritingFeature()
        }
    }
}
