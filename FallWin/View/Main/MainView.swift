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
                        ForEach(viewStore.journals) { journal in
                            ZStack {
                                ZStack {
                                    if let image = journal.wrappedImage {
                                        Image(uiImage: image)
                                    } else {
                                        Rectangle()
                                            .fill(Color.blue)
                                    }
                                }
                                .overlay(.ultraThinMaterial)
                                
                                VStack(spacing: 0) {
                                    if let image = journal.wrappedImage {
                                        Image(uiImage: image)
                                            .clipShape(RoundedRectangle(cornerRadius: 24))
                                    } else {
                                        Rectangle()
                                            .fill(Color.blue)
                                            .aspectRatio(1, contentMode: .fit)
                                            .clipShape(RoundedRectangle(cornerRadius: 24))
                                    }
                                    
                                    HStack(alignment: .center) {
                                        if let date = journal.timestamp {
                                            Text(date.dateString)
                                                .font(.pretendard(.medium, size: 16))
                                                .padding(.vertical, 8)
                                                .padding(.horizontal)
                                                .background(
                                                    Capsule()
                                                        .fill(.ultraThinMaterial)
                                                )
                                        }
                                        Spacer()
                                        if let mind = Mind(rawValue: journal.mind), let string = mind.string(), let icon = mind.iconName() {
                                            HStack {
                                                Image(icon)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 36, height: 36)
                                                Text(string)
                                                    .font(.pretendard(.medium, size: 16))
                                            }
                                            .padding(.vertical, 4)
                                            .padding(.horizontal)
                                            .background(
                                                Capsule()
                                                    .fill(.ultraThinMaterial)
                                            )
                                        }
                                    }
                                    .padding()
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .padding()
                            .shadow(color: Color(hexCode: "#191919").opacity(0.14), radius: 8, y: 4)
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
            .onAppear {
                viewStore.send(.fetchAll)
            }
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
