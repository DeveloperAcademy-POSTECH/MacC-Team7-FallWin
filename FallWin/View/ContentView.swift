//
//  ContentView.swift
//  FallWin
//
//  Created by 최명근 on 10/12/23.
//

import SwiftUI
import SwiftKeychainWrapper
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<Feature>
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                CvasTabView(selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect),
                            hideTabBar: viewStore.binding(get: \.hideTabBar, send: Feature.Action.hideTabBar)) {
                    
                    //                IfLetStore(store.scope(state: \.$gallery, action: Feature.Action.gallery)) { store in
                    //                    NavigationStack {
                    //                        GalleryView(store: store)
                    //                    }
                    //                    .tabItem(.init(title: "Gallery", enabledImage: "MainEnabled", disabledImage: "MainDisabled", tabItem: .gallery), selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect))
                    //                }
                    
                    IfLetStore(store.scope(state: \.$main, action: Feature.Action.main)) { store in
                        NavigationStack {
                            MainView(store: store)
                        }
                        .tabItem(.init(title: "Gallery", enabledImage: "MainEnabled", disabledImage: "MainDisabled", tabItem: .gallery), selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect))
                    }
                    
                    IfLetStore(store.scope(state: \.$search, action: Feature.Action.search)) { store in
                        NavigationStack {
                            SearchView(store: store)
                        }
                        .tabItem(.init(title: "Feed", enabledImage: "FeedEnabled", disabledImage: "FeedDisabled", tabItem: .search), selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect))
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
                
                if viewStore.invisible {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                }
            }
            .onAppear {
                viewStore.send(.initViews)
            }
            .onChange(of: scenePhase) { value in
                if !UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lock) {
                    return
                }
                
                switch value {
                case .background:
                    viewStore.send(.setLock(true))
                    break
                    
                case .inactive:
                    viewStore.send(.setInvisibility(true))
                    break
                    
                case .active:
                    if viewStore.lock {
                        viewStore.send(.showPasscodeView(true))
                    }
                    viewStore.send(.setInvisibility(false))
                    break
                    
                @unknown default: break
                }
            }
            .fullScreenCover(isPresented: viewStore.binding(get: \.showPasscodeView, send: Feature.Action.showPasscodeView)) {
                PasscodeView(initialMessage: "비밀번호를 입력하세요.", dismissable: false, enableBiometric: true, authenticateOnLaunch: true) { typed, biometric in
                    if typed == KeychainWrapper.standard[.password] || biometric ?? false {
                        viewStore.send(.setLock(false))
                        return .dismiss
                        
                    } else {
                        return .retype("비밀번호가 다릅니다.\n다시 입력해주세요.")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(store: Store(initialState: Feature.State(), reducer: {
        Feature()
    }))
}
