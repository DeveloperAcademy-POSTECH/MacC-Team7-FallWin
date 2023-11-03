//
//  MainView.swift
//  FallWin
//
//  Created by 최명근 on 11/1/23.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    let store: StoreOf<MainFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                ScrollView {
                    LazyVStack {
                        ForEach(viewStore.journals.indices, id: \.self) { i in
                            let journal = viewStore.journals[i]
                            
                            mainCell(journal: journal)
                                .padding()
                                .onTapGesture {
                                    HapticManager.shared.impact()
                                    viewStore.send(.showJournalView(journal))
                                }
                        }
                    }
                    .padding()
                }
                
                writingActionButton
                    .padding()
                    .navigationDestination(store: store.scope(state: \.$writing, action: MainFeature.Action.writing)) { store in
                        WritingView(store: store)
                            .onAppear {
                                viewStore.send(.hideTabBar(true))
                            }
                    }
            }
            .fullScreenCover(store: store.scope(state: \.$journal, action: MainFeature.Action.journal)) { store in
                JournalView(store: store)
            }
            .onAppear {
                viewStore.send(.fetchAll)
                viewStore.send(.hideTabBar(false))
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("설정", systemImage: "gearshape") {
                        viewStore.send(.showSettingsView)
                    }
                    .sheet(store: store.scope(state: \.$settings, action: MainFeature.Action.settings)) { store in
                        NavigationStack {
                            SettingsView(store: store)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func mainCell(journal: Journal) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                Group {
                    if let image = journal.wrappedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Rectangle()
                            .fill(Color.blue)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
                .shadow(color: Color(hexCode: "#191919").opacity(0.14), radius: 8, y: 4)
                
                HStack {
                    VStack {
                        Text(String(format: "%d", journal.timestamp?.day ?? 0))
                        Text(journal.timestamp?.dayOfWeek ?? "")
                    }
                    Divider()
                    Text(journal.content ?? "")
                    Spacer()
                }
                .padding(.horizontal)
            }
            .padding()
            .background(
                Color.white
                    .shadow(color: Color(hexCode: "#191919").opacity(0.14), radius: 8, y: 4)
            )
        }
    }
    
    private var writingActionButton: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        viewStore.send(.showWritingView)
                        
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Colors.button.color())
                            Image(systemName: "pencil")
                                .resizable()
                                .foregroundStyle(Colors.tabBarItem.color())
                                .frame(width: 24, height: 24)
                        }
                    }
                    .frame(width: 56, height: 56)
                }
            }
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
    
    let journal2 = Journal(context: context)
    journal2.id = UUID()
    journal2.content = "blah blah blah"
    journal2.image = nil
    journal2.mind = 1
    journal2.timestamp = Date()
    context.insert(journal2)
    
    let journal3 = Journal(context: context)
    journal3.id = UUID()
    journal3.content = "blah blah blah"
    journal3.image = nil
    journal3.mind = 1
    journal3.timestamp = Date()
    context.insert(journal3)
    
    return NavigationStack {
        MainView(store: Store(initialState: MainFeature.State(), reducer: {
            MainFeature()
        }))
    }
}
