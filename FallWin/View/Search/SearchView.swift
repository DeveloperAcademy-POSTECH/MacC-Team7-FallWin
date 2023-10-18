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
    @State private var searchTerm: String = ""
    @State private var searchResults: [String] = []

    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                ScrollView() {
                    LazyVGrid(columns: columns, spacing: 4) {
                        Section(header:
                                    
                                    HStack(){
                            
                            Text("2023년 10월 \(searchTerm)")
                                .font(
                                    Font.custom("Pretendard", size: 20)
                                        .weight(.semibold)
                                )
                            Spacer()
                            
                            
                        }
                                
                                
                        ){
                            ForEach((0...9), id: \.self) { _ in
                                Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
                                    .cornerRadius(4)
                                    .frame(width: 115, height: 115)
                                    .padding(4)
                                    .overlay(Text(["r", "b", "c", "s"].randomElement() ?? ""))
                                
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
                            ForEach((10...19), id: \.self) { _ in
                                Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
                                    .cornerRadius(4)
                                    .frame(width: 115, height: 115)
                                    .padding(4)
                                
                            }
                        }
                        
                    }
                }
                .padding(.horizontal, 12)
                .navigationTitle("검색")
                .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("찾고 싶은 추억을 입력해보세요"))
                
                
            }
            
            
        }
    }
}

//
//struct Month {
//    let name : String
//    let numberOfDays: Int
//    var days : [Day]
//
//    init(name: String, numberOfDays: Int) {
//        self.name = name
//        self.numberOfDays = numberOfDays
//        self.days = []
//
//        for n in 1...numberOfDays {
//            self.days.append(Day(value: n))
//        }
//
//    }
//}
//
//struct Day: Identifiable {
//    let id = UUID()
//    let value : Int
//}
//
//let year = [
//    Month(name: "January", numberOfDays: 31),
//    Month(name: "February", numberOfDays: 28),
//    Month(name: "March", numberOfDays: 31),
//    Month(name: "April", numberOfDays: 30),
//    Month(name: "May", numberOfDays: 31),
//    Month(name: "June", numberOfDays: 30),
//    Month(name: "July", numberOfDays: 31),
//    Month(name: "August", numberOfDays: 31),
//    Month(name: "September", numberOfDays: 30),
//    Month(name: "October", numberOfDays: 31),
//    Month(name: "November", numberOfDays: 30),
//    Month(name: "December", numberOfDays: 31),
//]

#Preview {
    SearchView(store: Store(initialState: SearchFeature.State(), reducer: {
        SearchFeature()
    }))
}
