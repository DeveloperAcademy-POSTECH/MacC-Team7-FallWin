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
    @State private var searchTerm: String = ""
    @State private var searchResults: [Journal] = []

    @State private var renderId: UUID = UUID()
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                ScrollView() {
                    LazyVGrid(columns: columns, spacing: 4, pinnedViews: [.sectionHeaders]) {
                        Section(header:
                            HStack(){
                            ZStack{
                                Text("2023년 10월")
                            }

                                .font(
                                    Font.custom("Pretendard", size: 20)
                                        .weight(.semibold)
                                )
                            Spacer()
                        }
                                
                                
                        ){
                            ForEach((searchResults.prefix(2)), id: \.self) { _ in
                                Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
                                    .cornerRadius(4)
                                    .frame(width: 115, height: 115)
                                    .padding(4)
                                
                            }
                        }
                        Section(header:
                                    HStack(){
                            
                            Text("2023년 9월")
                                .font(
                                    Font.custom("Pretendard", size: 20)
                                        .weight(.semibold)
                                )
                            Spacer()
                            
                            
                        }.padding(.top, 32)
                            .padding(.bottom, 16)
                                
                                
                                
                        ){
                            ForEach((searchResults.dropFirst(2)), id: \.self) { _ in
                                Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
                                    .cornerRadius(4)
                                    .frame(width: 115, height: 115)
                                    .padding(4)
                                
                            }
                        }
                        
                    }
                }
                .id(renderId)
                
                Button(action: {
                    let context = PersistenceController.shared.container.viewContext
                    
                    let j1 = Journal(context: context)
                    j1.content = "apple is good"
                    j1.id = UUID()
                    j1.image = nil
                    j1.mind = 1
                    j1.timestamp = Date()
                    context.insert(j1)
                    do {
                        try context.save() // 변경 내용 저장
                        print("Data saved")
                    } catch {
                        print("Error saving data: \(error)")
                    }
                    searchResults = fetchData()
                    print(searchResults)
                    renderId = UUID()
                    print("clicked")
                }, label: {
                    Text("더미데이터 추가")
                    
                })
                Spacer()
                .onAppear {
//                    viewStore.send(.fetchData)
                    searchResults = fetchData()
                    print(searchResults)
                }
//                .onChange(of: viewStore.searchTerm) { newValue in
//                    viewStore.send(.filterData(newValue))
//                }
                .onChange(of: searchTerm) { newValue in
                               searchResults = filterData(for: newValue)
                           }
                .padding(.horizontal, 12)
                .navigationTitle("검색")
                .searchable(text: viewStore.binding(get: { $0.searchTerm }, send: { .setSearchTerm($0) }), placement: .navigationBarDrawer(displayMode: .always), prompt: Text("찾고 싶은 추억을 입력해보세요"))
                
                
            }
            
            
        }
        
    }
    
    func fetchData() -> [Journal] {
        // Core Data에서 저장된 Journal 엔터티를 가져옵니다.
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Journal> = Journal.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching data: \(error)")
            return []
        }
    }


    func filterData(for query: String) -> [Journal] {
        // 검색 쿼리에 따라 결과를 필터링하는 논리를 추가합니다.
        // Journal 엔터티에서 데이터를 가져오도록 수정합니다.
        let allJournals = fetchData()
        
        return searchTerm.isEmpty ? allJournals : allJournals.filter { journal in
            if let content = journal.content {
                return content.lowercased().contains(query.lowercased())
            }
            return false
        }
    }
}



#Preview {
    let context = PersistenceController.shared.container.viewContext
    
    let j1 = Journal(context: context)
    j1.content = "apple is good"
    j1.id = UUID()
    j1.image = nil
    j1.mind = 1
    j1.timestamp = Date()
    context.insert(j1)
    
    return SearchView(store: Store(initialState: SearchFeature.State(), reducer: {
        SearchFeature()
    }))
}
