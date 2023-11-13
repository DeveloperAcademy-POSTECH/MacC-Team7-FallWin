//
//  MainView.swift
//  FallWin
//
//  Created by 최명근 on 11/1/23.
//

import SwiftUI
import ComposableArchitecture
import FirebaseAnalytics

struct MainView: View {
    let store: StoreOf<MainFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                ScrollViewReader { proxy in
                    if viewStore.journals.isEmpty {
                        EmptyPlaceholderView()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 28) {
                                ForEach(viewStore.journals.indices, id: \.self) { i in
                                    let journal = viewStore.journals[i]
                                    
                                    mainCell(journal: journal)
                                        .id(DateTagValue(date: journal.timestamp ?? Date()).tagValue)
                                        .onTapGesture {
                                            HapticManager.shared.impact()
                                            viewStore.send(.showJournalView(journal))
                                        }
                                        .onAppear {
                                            print("timestamp: \(journal.timestamp)")
                                            if let timestamp = journal.timestamp {
                                                if !viewStore.pickedDateTagValue.isScrolling {
                                                    viewStore.send(.updateYear(timestamp.year ))
                                                    viewStore.send(.updateMonth(timestamp.month))
                                                    let newTagValue = PickerManager.shared.getDateTagValue(date: timestamp)
                                                    viewStore.send(.updateTagValue(newTagValue))
                                                }
                                            }
                                        }
                                }
                            }
                            .padding(.top)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 60)
                            .onChange(of: viewStore.pickedDateTagValue.isScrolling) { value in
                                if value {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        proxy.scrollTo(viewStore.pickedDateTagValue.tagValue, anchor: .center)
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(500))) {
                                        viewStore.send(.updateScrolling)
                                    }
                                }
                            }
                            .onTapGesture {
                                Tracking.logEvent(Tracking.Event.A1_2__메인_일기아이템.rawValue)
                                print("@Log : A1_2__메인_일기아이템")
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
                    .onTapGesture {
                        Tracking.logEvent(Tracking.Event.A1_3__메인_새일기쓰기.rawValue)
                        print("@Log : A1_3__메인_새일기쓰기")
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
                        .sheet(isPresented: viewStore.binding(get: \.isPickerShown, send: MainFeature.Action.hidePickerSheet), onDismiss: {  }) {
                            YearMonthPickerView(isPickerShown: viewStore.binding(get: \.isPickerShown, send: MainFeature.Action.hidePickerSheet), pickedDateTagValue: viewStore.binding(get: \.pickedDateTagValue, send: MainFeature.Action.pickDate), journals: viewStore.binding(get: \.journals, send: MainFeature.Action.bindJournal))
                                .presentationDetents([.fraction(0.5)])
                        }
                        .alert(isPresented: viewStore.binding(get: \.showCountInfo, send: MainFeature.Action.showCountInfo), title: "남은 필름") {
                            Text("일기를 작성하고 그림을 생성할 때 마다 필름이 하나씩 소모되어요.\n필름은 매일 \(DrawingCountManager.INITIAL_COUNT)개로 리셋되니, 필름이 떨어지지 않게 유의하세요!")
                                .multilineTextAlignment(.center)
                        } primaryButton: {
                            OhwaAlertButton(label: Text("확인").foregroundColor(.textOnButton), color: .button) {
                                viewStore.send(.showCountInfo(false))
                            }
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
        }
        .onAppear {
            Tracking.logScreenView(screenName: Tracking.Screen.V1__메인뷰.rawValue)
            print("@Log : V1__메인뷰")
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
                        .lineLimit(2)
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
                    viewStore.send(.showPickerSheet)
                    Tracking.logEvent(Tracking.Event.A1_1__메인_날짜선택.rawValue)
                    print("@Log : A1_1__메인_날짜선택")
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
                    viewStore.send(.showCountInfo(true))
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
            }
            .padding(.top)
            .padding(.horizontal, 20)
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

extension ScrollViewProxy {
    
    
}
