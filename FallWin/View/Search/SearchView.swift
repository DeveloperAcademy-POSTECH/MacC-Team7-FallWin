//
//  SearchView.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    let store: StoreOf<SearchFeature>
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
//    @State private var searchTerm: String = ""
//    @State private var searchResults: [String] = []

    
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
                            ForEach((viewStore.searchResults.prefix(2)), id: \.self) { _ in
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
                            ForEach((viewStore.searchResults.dropFirst(2)), id: \.self) { _ in
                                Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
                                    .cornerRadius(4)
                                    .frame(width: 115, height: 115)
                                    .padding(4)
                                
                            }
                        }
                        
                    }
                }
                .onAppear {
                    viewStore.send(.fetchData)
                }
                .onChange(of: viewStore.searchTerm) { newValue in
                    viewStore.send(.filterData(newValue))
                }
                .padding(.horizontal, 12)
                .navigationTitle("검색")
                .searchable(text: viewStore.binding(get: { $0.searchTerm }, send: { .setSearchTerm($0) }), placement: .navigationBarDrawer(displayMode: .always), prompt: Text("찾고 싶은 추억을 입력해보세요"))
                
                
            }
            
            
        }
        
    }
}


#Preview {
    let context = PersistenceController.debug.container.viewContext
    
    let j1 = Journal(context: context)
    j1.content = ""
    j1.id = UUID()
    j1.image = nil
    j1.mind = 1
    j1.timestamp = Date()
    context.insert(j1)
    
    return SearchView(store: Store(initialState: SearchFeature.State(), reducer: {
        SearchFeature()
    }))
}
