//
//  SearchView.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//

import SwiftUI
import ComposableArchitecture
import CoreData
import FirebaseAnalytics

struct SearchView: View {
    let store: StoreOf<SearchFeature>
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    let dataInsertNotification = NotificationCenter.default.publisher(for: Notification.Name.NSManagedObjectContextDidSave)
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                
                if viewStore.searchResults.isEmpty {
                    EmptyPlaceholderView()
                } else {
                    ScrollView {
                        if viewStore.searchTerm.isEmpty {
                            LazyVGrid(columns: columns, spacing: 4, pinnedViews: [.sectionHeaders]) {
                                ForEach(viewStore.groupedSearchResults.sorted(by: { $0.key > $1.key }), id: \.key) { key, searchResults in
                                    if !searchResults.isEmpty {
                                        Section(header: HStack {
                                            Text(key.string)
                                                .font(.pretendard(.semiBold, size: 20))
                                            Spacer()
                                        }
                                            .padding(.top, 12)
                                            .padding(.bottom, 6)
                                            .background {
                                                Rectangle()
                                                    .fill(.backgroundPrimary)
                                            }
                                        ){
                                            ForEach(searchResults, id: \.self) { journal in
                                                ZStack {
                                                    if let image = journal.wrappedImage {
                                                        Image(uiImage: image)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .cornerRadius(4)
                                                            .frame(width: 115, height: 115)
                                                            .padding(4)
                                                    } else {
                                                        Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
                                                            .cornerRadius(4)
                                                            .frame(width: 110, height: 110)
                                                            .padding(.vertical, 1.5)
                                                        
                                                    }
                                                }
                                                .onTapGesture {
                                                    viewStore.send(.showJournalView(journal))
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                        } else {
                            LazyVGrid(columns: columns, spacing: 4) {
                                
                                ForEach((viewStore.searchResults), id: \.self) { journal in
                                    ZStack {
                                        if let image = journal.wrappedImage {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(4)
                                                .frame(width: 115, height: 115)
                                                .padding(4)
                                        } else {
                                            
                                        }
                                    }
                                    .onTapGesture {
                                        viewStore.send(.showJournalView(journal))
                                    }
                                    
                                    
                                }
                            }
                            .padding(.horizontal, 12)
                        }
                    }
                }
            }
            .fullScreenCover(store: store.scope(state: \.$journal, action: SearchFeature.Action.journal)) { store in
                NavigationStack {
                    JournalView(store: store)
                }
            }
            .onAppear {
                viewStore.send(.fetchData)
            }
            .onReceive(dataInsertNotification) { output in
                viewStore.send(.fetchData)
            }
            .onChange(of: viewStore.searchTerm) { newValue in
                viewStore.send(.filterData(newValue))
            }
            .navigationTitle(
                Text("tab_album")
            )
            .searchable(text: viewStore.binding(get: { $0.searchTerm }, send: { .setSearchTerm($0) }), placement: .navigationBarDrawer(displayMode: .always), prompt: Text("album_search_placeholder"))
            .onTapGesture {
                Tracking.logEvent(Tracking.Event.A4_1__검색뷰_피드검색.rawValue)
                print("@Log : A4_1__검색뷰_피드검색")
            }
        }
        .onAppear {
            Tracking.logScreenView(screenName: Tracking.Screen.V4__검색뷰.rawValue)
            print("@Log : V4__검색뷰")
        }
        
    }
    
    // 삭제할 데이터를 검색
    func deleteData() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            for journal in results {
                context.delete(journal) // 데이터 삭제
            }
            
            try context.save() // 변경 내용 저장
            print("Data deleted")
        } catch {
            print("Error deleting data: \(error)")
        }
    }
    
}

#Preview {
    SearchView(store: Store(initialState: SearchFeature.State(), reducer: {
        SearchFeature()
    }))
    
}
