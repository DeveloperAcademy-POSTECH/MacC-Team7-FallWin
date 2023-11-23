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
        var isPickerShown: Bool = false
        var showCountAlert: Bool = false
        var showCountInfo: Bool = false
        var remainingCount: Int = 0
        var pickedDateTagValue: DateTagValue = DateTagValue(date: Date())
        
        @PresentationState var journal: JournalFeature.State?
        @PresentationState var writing: WritingFeature.State?
    }
    
    enum Action: Equatable {
        case fetchAll
        case hideTabBar(Bool)
        case doneGenerating(Journal)
        case showJournalView(Journal)
        case showWritingView
        case showPickerSheet
        case hidePickerSheet
        case pickDate(DateTagValue)
        case updateYear(Int)
        case updateMonth(Int)
        case updateTagValue(Int)
        case updateScrolling
        case bindJournal
        case showCountAlert(Bool)
        case showCountInfo(Bool)
        case getRemainingCount
        
        case journal(PresentationAction<JournalFeature.Action>)
        case writing(PresentationAction<WritingFeature.Action>)
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
                
            case .showPickerSheet:
                state.isPickerShown = true
                return .none
                
            case .hidePickerSheet:
                state.isPickerShown = false
                return .none
                
            case let .pickDate(dateTagValue):
                state.pickedDateTagValue = dateTagValue
                return .none
                
            case let .updateYear(year):
                state.pickedDateTagValue.year = year
                return .none
                
            case let .updateMonth(month):
                state.pickedDateTagValue.month = month
                return .none
                
            case let .updateTagValue(tagValue):
                state.pickedDateTagValue.tagValue = tagValue
                return .none
                
            case .updateScrolling:
                state.pickedDateTagValue.isScrolling.toggle()
                return .none
                
            // PickerView에서 journals를 읽기 위한 바인딩용 action. set 작업은 하지 않음.
            case .bindJournal:
                return .none
                
            case let .showCountAlert(show):
                state.showCountAlert = show
                return .none
                
            case let .showCountInfo(show):
                state.showCountInfo = show
                return .none
                
            case .getRemainingCount:
                state.remainingCount = FilmManager.shared.drawingCount?.count ?? 0
                return .none
                
//            case .writing(let action):
//                return handleWritingAction(state: &state, action: action)
            case let .writing(.presented(.doneGenerating(journal))):
                state.writing = nil
                print("dismiss main")
                return .send(.doneGenerating(journal))
            
            case .writing(.presented(.cancelWriting)):
                state.writing?.mainText?.drawingStyle?.generatedDiary = nil
                state.writing?.mainText?.drawingStyle = nil
                state.writing?.mainText = nil
                state.writing = nil
                print("dismiss main")
                return .none
                
//            case .journal(let action):
//                return handleJournalAction(state: &state, action: action)
            case .journal(.presented(.delete)):
                return .send(.fetchAll)
                
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
