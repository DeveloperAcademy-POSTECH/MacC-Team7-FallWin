//
//  JournalWritingView.swift
//  FallWin
//
//  Created by 최명근 on 11/14/23.
//

import SwiftUI
import ComposableArchitecture

enum JournalWritingTab: Hashable, Equatable {
    case mind
    case content
    case style
    case pick
}

struct JournalWritingView: View {
    let store: StoreOf<JournalWritingFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TabView(selection: viewStore.binding(get: \.selectedTab, send: JournalWritingFeature.Action.selectTab)) {
                MindView(tab: viewStore.binding(get: \.selectedTab, send: JournalWritingFeature.Action.selectTab),
                         selected: viewStore.binding(get: \.mind, send: JournalWritingFeature.Action.setMind))
                .tag(JournalWritingTab.mind)
                
                WritingContentView(tab: viewStore.binding(get: \.selectedTab, send: JournalWritingFeature.Action.selectTab),
                                   text: viewStore.binding(get: \.content, send: JournalWritingFeature.Action.setContent))
                .tag(JournalWritingTab.content)
                
                DrawStyleView(tab: viewStore.binding(get: \.selectedTab, send: JournalWritingFeature.Action.selectTab),
                              selected: viewStore.binding(get: \.drawingStyle, send: JournalWritingFeature.Action.setDrawingStyle))
                .tag(JournalWritingTab.style)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    NavigationStack {
        JournalWritingView(store: Store(initialState: JournalWritingFeature.State(), reducer: {
            JournalWritingFeature()
        }))
    }
}
