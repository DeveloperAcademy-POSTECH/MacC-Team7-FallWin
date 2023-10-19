//
//  JournalView.swift
//  FallWin
//
//  Created by 최명근 on 10/19/23.
//

import SwiftUI
import ComposableArchitecture

struct JournalView: View {
    let store: StoreOf<JournalFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
        }
    }
}

#Preview {
    let context = PersistenceController.debug.container.viewContext
    let journal = Journal(context: context)
    journal.id = UUID()
    journal.content = "blah blah blah"
    journal.image = nil
    journal.mind = 1
    journal.timestamp = Date()
    context.insert(journal)
    
    return JournalView(store: Store(initialState: JournalFeature.State(journal: journal), reducer: {
        JournalFeature()
    }))
}
