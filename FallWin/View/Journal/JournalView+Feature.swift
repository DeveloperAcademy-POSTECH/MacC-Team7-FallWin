//
//  JournalView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 10/19/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct JournalFeature: Reducer {
    struct State: Equatable {
        var journal: Journal
        var invisible: Bool = false
        var lock: Bool = false
        var showPasscodeView: Bool = false
        var showImageDetailView: Bool = false
        var showShareSheet: Bool = false
        var showDeleteAlert: Bool = false
        var shareItem: ShareImageWrapper? = nil
        var dismiss: Bool = false
        
        @PresentationState var textEdit: TextEditFeature.State?
    }
    
    enum Action: Equatable {
        case setInvisibility(Bool)
        case setLock(Bool)
        case showPasscodeView(Bool)
        case showImageDetailView(Bool)
        case showShareSheet(Bool)
        case showDeleteAlert(Bool)
        case shareItem(ShareImageWrapper?)
        case showTextEditView
        case cancelEditing
        
        case delete
        case dismiss
        
        case textEdit(PresentationAction<TextEditFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .delete:
                let context =  PersistenceController.shared.container.viewContext
                context.delete(state.journal)
                do {
                    try context.save()
                } catch {
                    print(error)
                }
                return .send(.dismiss)
                
            case let .setInvisibility(invisible):
                state.invisible = invisible
                return .none
                
            case let .setLock(lock):
                state.lock = lock
                return .none
                
            case let .showPasscodeView(show):
                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    state.showPasscodeView = show
                }
                return .none
                
            case let .showImageDetailView(show):
                state.showImageDetailView = show
                return .none
                
            case let .showShareSheet(show):
                state.showShareSheet = show
                return .none
                
            case let .showDeleteAlert(show):
                state.showDeleteAlert = show
                return .none
                
            case let .shareItem(item):
                state.shareItem = item
                return .none
                
            case .showTextEditView:
                state.textEdit = nil
                state.textEdit = .init(journal: state.journal, tempText: state.journal.content ?? "")
                return .none
                
            case .cancelEditing:
                state.textEdit = nil
                return .none
                
            case .dismiss:
                state.dismiss = true
                return .none
                
            case .textEdit(.presented(.cancelEditing)):
                return .send(.cancelEditing)
                
            default: return .none
            }
        }
        .ifLet(\.$textEdit, action: /Action.textEdit) {
            TextEditFeature()
        }
    }
//    func reduce(into state: inout State, action: Action) -> Effect<Action> {
//        switch action {
//        case .delete:
//            let context =  PersistenceController.shared.container.viewContext
//            context.delete(state.journal)
//            do {
//                try context.save()
//            } catch {
//                print(error)
//            }
//            return .send(.dismiss)
//            
//        case let .setInvisibility(invisible):
//            state.invisible = invisible
//            return .none
//            
//        case let .setLock(lock):
//            state.lock = lock
//            return .none
//            
//        case let .showPasscodeView(show):
//            var transaction = Transaction()
//            transaction.disablesAnimations = true
//            withTransaction(transaction) {
//                state.showPasscodeView = show
//            }
//            return .none
//            
//        case let .showImageDetailView(show):
//            state.showImageDetailView = show
//            return .none
//            
//        case let .showShareSheet(show):
//            state.showShareSheet = show
//            return .none
//            
//        case let .showDeleteAlert(show):
//            state.showDeleteAlert = show
//            return .none
//            
//        case let .shareItem(item):
//            state.shareItem = item
//            return .none
//            
//        case .showTextEditView:
//            state.textEdit = nil
//            state.textEdit = .init(journal: state.journal, tempText: state.journal.content ?? "")
//            return .none
//            
//        case .dismiss:
//            state.dismiss = true
//            return .none
//            
//        case .textEdit:
//            return .none
//        }
//    }
}
