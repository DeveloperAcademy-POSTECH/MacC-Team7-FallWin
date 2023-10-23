//
//  SearchView.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//

import SwiftUI
import ComposableArchitecture
import CoreData

struct SearchView: View {
    let store: StoreOf<SearchFeature>
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                ScrollView() {
                    if viewStore.searchTerm.isEmpty {
                        LazyVGrid(columns: columns, spacing: 4) {
                            ForEach(viewStore.groupedSearchResults.sorted(by: { $0.key < $1.key }), id: \.key) { key, searchResults in
                                if !searchResults.isEmpty {
                                    Section(header: HStack {
                                        Text(key)
                                            .font(Font.custom("Pretendard", size: 20).weight(.semibold))
                                        Spacer()
                                    }
                                        .padding(.vertical, 12)
                                        .padding(.top, 12)
                                        
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
                    }else {
                        LazyVGrid(columns: columns, spacing: 4) {
                            
                            ForEach((viewStore.searchResults), id: \.self) { journal in
                                if let image = journal.wrappedImage {
                                    Image(uiImage: image)
                                        .cornerRadius(4)
                                        .frame(width: 115, height: 115)
                                        .padding(4)
                                } else {
                                    
                                }
                                
                            }
                        }
                    }
                }
                .fullScreenCover(store: store.scope(state: \.$journal, action: SearchFeature.Action.journal)) { store in
                    JournalView(store: store)
                }
                .navigationTitle(
                    Text("검색")
                )
                .padding(.horizontal, 12)
                .padding(.top, -12)
                
                
                
#if targetEnvironment(simulator)
                HStack{
                    Button(action: {
                        let context = PersistenceController.shared.container.viewContext
                        
                        let j1 = Journal(context: context)
                        j1.content = "apple is good"
                        j1.id = UUID()
                        j1.image = nil
                        j1.mind = 1
                        j1.timestamp = Date()
//                        j1.timestamp = Calendar.current.date(byAdding: .month, value: -1, to: Date())
//                        context.insert(j1)
                        do {
                            try context.save() // 변경 내용 저장
                            print("Data saved")
                        } catch {
                            print("Error saving data: \(error)")
                        }
                        viewStore.send(.fetchData)
                        print("clicked")
                    }, label: {
                        Text("더미데이터 추가")
                        
                    }).padding(.bottom, 63)
                    Button(action: {
                        
                        deleteData()
                        
                    }, label: {
                        Text("더미데이터 삭제")
                        
                    }).padding(.bottom, 63)
                }
                //TODO: 테스트 이후 삭제
#endif
            }
            .onAppear {
                viewStore.send(.fetchData)
            }
            .onChange(of: viewStore.searchTerm) { newValue in
                viewStore.send(.filterData(newValue))
            }
            .padding(.horizontal, 12)
            
            .searchable(text: viewStore.binding(get: { $0.searchTerm }, send: { .setSearchTerm($0) }), placement: .navigationBarDrawer(displayMode: .always), prompt: Text("찾고 싶은 추억을 입력해보세요"))
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

// TODO: 테스트 이후에 더미데이터에 관련한 기능들 삭제



#Preview {
    SearchView(store: Store(initialState: SearchFeature.State(), reducer: {
        SearchFeature()
    }))
    
}
