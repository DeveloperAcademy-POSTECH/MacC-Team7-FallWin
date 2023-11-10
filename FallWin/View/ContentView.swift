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
                TabView(selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect)) {
                    Group {
                        IfLetStore(store.scope(state: \.$main, action: Feature.Action.main)) { store in
                            NavigationStack {
                                MainView(store: store)
                            }
                            .tabItem {
                                Text("Main")
                                viewStore.tabSelection == 0 ? Image("MainDefault") : Image("MainDisabled")
                            }
                            .tag(0)
                        }
                        
                        IfLetStore(store.scope(state: \.$search, action: Feature.Action.search)) { store in
                            NavigationStack {
                                SearchView(store: store)
                            }
                            .tabItem {
                                Text("Album")
                                viewStore.tabSelection == 1 ? Image("AlbumDefault") : Image("AlbumDisabled")
                            }
                            .tag(1)
                        }
                        
                        IfLetStore(store.scope(state: \.$settings, action: Feature.Action.settings)) { store in
                            NavigationStack {
                                SettingsView(store: store)
                            }
                            .tabItem {
                                Text("Settings")
                                viewStore.tabSelection == 2 ? Image("SettingsDefault") : Image("SettingsDisabled")
                            }
                            .tag(2)
                        }
                    }
                    .toolbarBackground(Color.backgroundPrimary, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarColorScheme(.light, for: .tabBar)
                }
                
                if viewStore.invisible {
                    Rectangle()
                        .fill(.regularMaterial)
                        .ignoresSafeArea()
                }
            }
            .onChange(of: scenePhase) { value in
                if !UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lock) {
                    return
                }
                
                DispatchQueue.main.async {
                    switch value {
                    case .inactive:
                        viewStore.send(.setInvisibility(true))
                        break
                        
                    case .active:
                        viewStore.send(.setInvisibility(false))
                        break
                        
                    case .background:
                        break
                        
                    @unknown default: break
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
