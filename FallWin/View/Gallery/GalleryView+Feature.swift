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
    }
    
    enum Action: Equatable {
        case fetchAll
        case setCarouselIndex(Int)
        case prevMonth
        case nextMonth
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
                
            default: return .none
            }
        }
    }
}
