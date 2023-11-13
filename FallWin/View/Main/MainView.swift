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
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack {
                            ForEach(viewStore.journals.indices, id: \.self) { i in
                                let journal = viewStore.journals[i]
                                
                                mainCell(journal: journal)
                                    .padding()
                                    .id(DateTagValue(date: journal.timestamp ?? Date()).tagValue)
                                    .onTapGesture {
                                        HapticManager.shared.impact()
                                        viewStore.send(.showJournalView(journal))
                                    }
                                    .onAppear {
                                        if let timestamp = journal.timestamp {
                                            viewStore.send(.updateYear(timestamp.year ))
                                            viewStore.send(.updateMonth(timestamp.month))
                                            let newTagValue = PickerManager.shared.getDateTagValue(date: journal.timestamp ?? Date())
                                            viewStore.send(.updateTagValue(newTagValue))
                                        }
                                    }
                            }
                        }
                        .padding()
                        .padding(.vertical, 40)
                        .onChange(of: viewStore.pickedDateTagValue.isChanged) { _ in
                            withAnimation(.default) {
                                proxy.scrollTo(viewStore.pickedDateTagValue.tagValue, anchor: .center)
                            }
                        }
                    }
                }
                
                writingActionButton
                    .padding()
                    .navigationDestination(store: store.scope(state: \.$writing, action: MainFeature.Action.writing)) { store in
                        WritingView(store: store)
                            .onAppear {
                                viewStore.send(.hideTabBar(true))
                            }
                    }
                    .alert(isPresented: viewStore.binding(get: \.showCountAlert, send: MainFeature.Action.showCountAlert), title: "오늘의 제한 도달") {
                        Text("오늘 쓸 수 있는 필름을 다 썼어요. 내일 더 그릴 수 있도록 필름을 더 드릴게요!")
                    } primaryButton: {
                        OhwaAlertButton(label: Text("확인").foregroundColor(.textOnButton), color: .button) {
                            viewStore.send(.showCountAlert(false))
                        }
                    }
                
                VStack {
                    toolbar
                        .sheet(isPresented: viewStore.binding(get: \.isPickerShown, send: MainFeature.Action.hidePickerSheet), onDismiss: { print("picker dismissed") }) {
                            YearMonthPickerView(yearRange: 1900...2023, isPickerShown: viewStore.binding(get: \.isPickerShown, send: MainFeature.Action.hidePickerSheet), pickedDateTagValue: viewStore.binding(get: \.pickedDateTagValue, send: MainFeature.Action.pickDate), journals: viewStore.binding(get: \.journals, send: MainFeature.Action.bindJournal))
                                .presentationDetents([.fraction(0.5)])
                        }
                    Spacer()
                }
            }
            .background(
                Color.backgroundPrimary.ignoresSafeArea()
            )
            .fullScreenCover(store: store.scope(state: \.$journal, action: MainFeature.Action.journal)) { store in
                NavigationStack {
                    JournalView(store: store)
                }
            }
            .onAppear {
                viewStore.send(.fetchAll)
                viewStore.send(.hideTabBar(false))
            }
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.visible, for: .tabBar)
            .onChange(of: viewStore.isPickerShown) { value in
                print(value)
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
                .shadow(color: Color.shadow.opacity(0.14), radius: 8, y: 4)
                
                HStack(spacing: 24) {
                    VStack {
                        Text(String(format: "%d", journal.timestamp?.day ?? 0))
                            .font(.pretendard(.bold, size: 28))
                        Text(journal.timestamp?.dayOfWeek ?? "")
                            .font(.pretendard(.semiBold, size: 16))
                    }
                    Divider()
                        .background(Color.separator)
                    Text(journal.content ?? "")
                    Spacer()
                }
                .foregroundStyle(Color.textPrimary)
                .padding(.horizontal, 12)
            }
            .padding()
            .background(
                Color.backgroundCard
                    .shadow(color: Color.shadow.opacity(0.14), radius: 8, y: 4)
            )
        }
    }
    
    private var toolbar: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack(alignment: .center) {
                Button {
                    print("picker clicked")
                    viewStore.send(.showPickerSheet)
                } label: {
                    HStack {
                        Text(String(format: "%d년 %d월", viewStore.pickedDateTagValue.year, viewStore.pickedDateTagValue.month))
                            .font(.pretendard(.bold, size: 24))
                        Image(systemName: "chevron.down")
                    }
                }
                .foregroundStyle(Color.textPrimary)
                
                Spacer()
                
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "film")
                            .resizable()
                            .frame(width: 20, height: 18)
                        Text("\(viewStore.remainingCount)")
                    }
                    .padding(10)
                    .background {
                        Capsule()
                            .fill(Color.backgroundCard)
                            .shadow(color: .shadow.opacity(0.14), radius: 8, y: 4)
                    }
                }
                .onAppear {
                    viewStore.send(.getRemainingCount)
                }
                
                //                Button {
                //
                //                } label: {
                //                    Image(systemName: "calendar")
                //                        .resizable()
                //                        .frame(width: 20, height: 18)
                //                        .padding(10)
                //                        .background {
                //                            Circle()
                //                                .fill(Color.backgroundCard)
                //                                .shadow(color: .shadow.opacity(0.14), radius: 8, y: 4)
                //                        }
                //                }
            }
            .padding(.top)
            .padding(.horizontal)
            .padding(.bottom, 8)
            .background(Color.backgroundPrimary)
        }
    }
    
    private var writingActionButton: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        if DrawingCountManager.shared.remainingCount <= 0 {
                            viewStore.send(.showCountAlert(true))
                        } else {
                            viewStore.send(.showWritingView)
                        }
                        
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.buttonFloating)
                                .shadow(color: Color.shadow.opacity(0.14), radius: 8, y: 4)
                            Image(systemName: "plus")
                                .resizable()
                                .foregroundStyle(Color.textOnFloatingButton)
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
