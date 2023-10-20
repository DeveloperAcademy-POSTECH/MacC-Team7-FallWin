//
//  ContentView.swift
//  FallWin
//
//  Created by 최명근 on 10/12/23.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<Feature>
    
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            CvasTabView(selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect)) {
                
                IfLetStore(store.scope(state: \.$gallery, action: Feature.Action.gallery)) { store in
                    GalleryView(store: store)
                        .tabItem(.init(title: "Gallery", image: "circle.fill", tabItem: .gallery), selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect))
                }
                
                IfLetStore(store.scope(state: \.$search, action: Feature.Action.search)) { store in
                    SearchView(store: store)
                        .tabItem(.init(title: "Search", image: "circle.fill", tabItem: .search), selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect))
                }
                
                IfLetStore(store.scope(state: \.$surf, action: Feature.Action.surf)) { store in
                    SurfView(store: store)
                        .tabItem(.init(title: "Surf", image: "circle.fill", tabItem: .surf), selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect))
                }
                
                IfLetStore(store.scope(state: \.$profile, action: Feature.Action.profile)) { store in
                    ProfileView(store: store)
                        .tabItem(.init(title: "Profile", image: "circle.fill", tabItem: .profile), selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect))
                }
                
            }
            .onAppear {
                viewStore.send(.initViews)
            }
        }
    }
}

#Preview {
    ContentView(store: Store(initialState: Feature.State(), reducer: {
        Feature()
    }))

}


//struct ContentView: View {
//    let store: StoreOf<WritingFeature>
//    
//    var body: some View {
////        DallEApiTestView()
//        WritingView(store: store)
//    }
//}

//#Preview {
//    ContentView(store: Store(initialState: WritingFeature.State(), reducer: {
//        WritingFeature()
//    }))
//}
