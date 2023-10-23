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
//        DallEApiTestView()
//        WritingView(store: store)
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            CvasTabView(selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect),
                        hideTabBar: viewStore.binding(get: \.hideTabBar, send: Feature.Action.hideTabBar)) {
                
                IfLetStore(store.scope(state: \.$gallery, action: Feature.Action.gallery)) { store in
                    NavigationStack {
                        GalleryView(store: store)
                    }
                    .tabItem(.init(title: "Gallery", enabledImage: "MainEnabled", disabledImage: "MainDisabled", tabItem: .gallery), selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect))
                }
                
                IfLetStore(store.scope(state: \.$search, action: Feature.Action.search)) { store in
                    SearchView(store: store)
                        .tabItem(.init(title: "Search", enabledImage: "FeedEnabled", disabledImage: "FeedDisabled", tabItem: .search), selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect))
                }
                
//                IfLetStore(store.scope(state: \.$surf, action: Feature.Action.surf)) { store in
//                    SurfView(store: store)
//                        .tabItem(.init(title: "Surf", enabledImage: "SurfEnabled", disabledImage: "SurfDisabled", tabItem: .surf), selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect))
//                }
//                
//                IfLetStore(store.scope(state: \.$profile, action: Feature.Action.profile)) { store in
//                    ProfileView(store: store)
//                        .tabItem(.init(title: "Profile", enabledImage: "ProfileEnabled", disabledImage: "ProfileDisabled", tabItem: .profile), selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect))
//                }
                
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
