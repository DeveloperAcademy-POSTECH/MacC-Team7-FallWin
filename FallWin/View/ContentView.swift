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
            if UserDefaults.standard.bool(forKey: UserDefaultsKey.AppEnvironment.isFirstLaunched) {
                IfLetStore(store.scope(state: \.$onboarding, action: Feature.Action.onboarding)) { store in
                    OnboardingView(store: store)
                }
            } else {
                ZStack {
                    TabView(selection: viewStore.binding(get: \.tabSelection, send: Feature.Action.tabSelect)) {
                        Group {
                            IfLetStore(store.scope(state: \.$main, action: Feature.Action.main)) { store in
                                NavigationStack {
                                    MainView(store: store)
                                }
                                .tabItem {
                                    Text("tab_feed")
                                    viewStore.tabSelection == 0 ? Image("MainDefault") : Image("MainDisabled")
                                }
                                .tag(0)
                            }
                            
                            IfLetStore(store.scope(state: \.$search, action: Feature.Action.search)) { store in
                                NavigationStack {
                                    SearchView(store: store)
                                }
                                .tabItem {
                                    Text("tab_album")
                                    viewStore.tabSelection == 1 ? Image("AlbumDefault") : Image("AlbumDisabled")
                                }
                                .tag(1)
                            }
                            
                            IfLetStore(store.scope(state: \.$settings, action: Feature.Action.settings)) { store in
                                NavigationStack {
                                    SettingsView(store: store)
                                }
                                .tabItem {
                                    Text("tab_more")
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
                
                /*
                 * **Remove After**
                 * v1.1.1 region error alert
                 */
                .alert(String("Notification"), isPresented: viewStore.binding(get: { $0.showRegionErrorAlert }, send: { .showRegionErrorAlert($0, nil)})) {
                    Button(String("Do Not Show"), role: .cancel) {
                        viewStore.send(.showRegionErrorAlert(false, true))
                    }
                    
                    Button("confirm") {
                        viewStore.send(.showRegionErrorAlert(false, false))
                    }
                    
                } message: {
                    Text(String(
"""
We apologize for any inconvenience this may cause. Based on user reviews, we've identified access issues in certain countries and regions, and we're working to determine the exact cause. As a result, we're now adding a notice within the app that there may be restrictions on access to the service based on country and region. We value your interest and opinions on PICDA and will strive to provide better service.

Мы приносим извинения за возможные неудобства. Основываясь на отзывах пользователей, мы обнаружили проблемы с доступом в некоторых странах и регионах и работаем над определением точной причины. В результате мы добавили в приложение уведомление о том, что доступ к сервису может быть ограничен в зависимости от страны и региона. Мы ценим ваш интерес и мнения о PICDA и будем стараться предоставлять лучший сервис.

서비스 이용에 불편을 드려 죄송합니다. 사용자 리뷰를 토대로 특정 국가 및 지역에서의 접속 문제를 확인했고 정확한 원인을 파악하고 있습니다. 따라서 현재 앱 내에서 국가 및 지역에 따라 서비스 이용에 제한이 있을 수 있다는 안내를 추가하고 있습니다. PICDA에 대한 여러분 관심과 의견을 소중히 여기고 더 나은 서비스를 제공하기 위해 노력하겠습니다.
"""))
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
}

#Preview {
    ContentView(store: Store(initialState: Feature.State(), reducer: {
        Feature()
    }))
}
