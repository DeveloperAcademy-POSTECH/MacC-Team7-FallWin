//
//  MainView+Extension.swift
//  FallWin
//
//  Created by 최명근 on 11/1/23.
//

import Foundation
import CoreData
import ComposableArchitecture

struct MainFeature: Reducer {
    struct State: Equatable {
        var journals: [Journal] = []
        var year: Int = Date().year
        var month: Int = Date().month
        
        @PresentationState var journal: JournalFeature.State?
        @PresentationState var writing: WritingFeature.State?
        @PresentationState var settings: SettingsFeature.State?
    }
    
    enum Action: Equatable {
        case fetchAll
        case hideTabBar(Bool)
        case doneGenerating(Journal)
        case showJournalView(Journal)
        case showWritingView
        case showSettingsView
        
        case journal(PresentationAction<JournalFeature.Action>)
        case writing(PresentationAction<WritingFeature.Action>)
        case settings(PresentationAction<SettingsFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchAll:
                let context = PersistenceController.shared.container.viewContext
                do {
                    let fetchRequest = NSFetchRequest<Journal>(entityName: "Journal")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Journal.timestamp), ascending: false)]
                    state.journals = try context.fetch(fetchRequest)
                } catch {
                    print(#function, error)
                }
                return .none
                
            case let .showJournalView(journal):
                state.journal = .init(journal: journal)
                return .none
                
            case let .doneGenerating(journal):
                return .run { send in
                    sleep(1)
                    await send(.showJournalView(journal))
                }
                
            case .showWritingView:
                state.writing = WritingFeature.State()
                return .none
                
            case .showSettingsView:
                state.settings = .init()
                return .none
                
            case .writing(let action):
                return handleWritingAction(state: &state, action: action)
                
            case .journal(let action):
                return handleJournalAction(state: &state, action: action)
                
            default: return .none
            }
        }
        .ifLet(\.$journal, action: /Action.journal) {
            JournalFeature()
        }
        .ifLet(\.$writing, action: /Action.writing) {
            WritingFeature()
        }
        .ifLet(\.$settings, action: /Action.settings) {
            SettingsFeature()
        }
    }
    
    private func handleWritingAction(state: inout State, action: PresentationAction<WritingFeature.Action>) -> Effect<Action> {
        switch action {
        case .presented(.doneGenerating(let journal)):
            state.writing = nil
            return .send(.doneGenerating(journal))
            
        default: return .none
        }
    }
    
    private func handleJournalAction(state: inout State, action: PresentationAction<JournalFeature.Action>) -> Effect<Action> {
        switch action {
        case .presented(.delete):
            return .send(.fetchAll)
        default: return .none
        }
    }
}
