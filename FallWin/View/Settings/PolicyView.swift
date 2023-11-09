//
//  PolicySettingView.swift
//  FallWin
//
//  Created by 최명근 on 11/8/23.
//

import SwiftUI
import ComposableArchitecture

struct PolicyView: View {
    let store: StoreOf<PolicyFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                NavigationLink {
                    WebView(url: "https://instagram.com/ohwa_todaysart")
                        .toolbar(.hidden, for: .tabBar)
                    
                } label: {
                    Text("서비스 이용약관")
                        .font(.pretendard(size: 18))
                        .padding(.vertical, 8)
                }
                .listRowBackground(Color.backgroundPrimary)
                
                NavigationLink {
                    WebView(url: "https://instagram.com/ohwa_todaysart")
                        .toolbar(.hidden, for: .tabBar)
                    
                } label: {
                    Text("개인정보처리방침")
                        .font(.pretendard(size: 18))
                        .padding(.vertical, 8)
                }
                .listRowBackground(Color.backgroundPrimary)
                
                NavigationLink {
                    LicenseView()
                    
                } label: {
                    Text("오픈소스 라이선스")
                        .font(.pretendard(size: 18))
                        .padding(.vertical, 8)
                }
                .listRowBackground(Color.backgroundPrimary)
            }
            .listStyle(.plain)
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("이용약관")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct LicenseView: View {
    var body: some View {
        List {
            NavigationLink {
                WebView(url: "https://github.com/pointfreeco/swift-composable-architecture")
                    .toolbar(.hidden, for: .tabBar)
                
            } label: {
                cell("Swift Composable Architecture", license: "MIT", url: "https://github.com/pointfreeco/swift-composable-architecture")
            }
            .listRowBackground(Color.backgroundPrimary)
            
            NavigationLink {
                WebView(url: "https://github.com/jrendel/SwiftKeychainWrapper")
                    .toolbar(.hidden, for: .tabBar)
                
            } label: {
                cell("SwiftKeychainWrapper", license: "MIT", url: "https://github.com/jrendel/SwiftKeychainWrapper")
            }
            .listRowBackground(Color.backgroundPrimary)
            
            NavigationLink {
                WebView(url: "https://github.com/Alamofire/Alamofire")
                    .toolbar(.hidden, for: .tabBar)
                
            } label: {
                cell("Alamofire", license: "MIT", url: "https://github.com/Alamofire/Alamofire")
            }
            .listRowBackground(Color.backgroundPrimary)
            
            NavigationLink {
                WebView(url: "https://github.com/airbnb/lottie-ios")
                    .toolbar(.hidden, for: .tabBar)
                
            } label: {
                cell("lottie-ios", license: "Apache 2.0", url: "https://github.com/airbnb/lottie-ios")
            }
            .listRowBackground(Color.backgroundPrimary)
            
            NavigationLink {
                WebView(url: "https://github.com/kakaobrain/karlo")
                    .toolbar(.hidden, for: .tabBar)
                
            } label: {
                cell("Karlo", license: "CreativeML Open RAIL-M license", url: "https://github.com/kakaobrain/karlo")
            }
            .listRowBackground(Color.backgroundPrimary)
        }
        .listStyle(.plain)
        .background(Color.backgroundPrimary.ignoresSafeArea())
        .navigationTitle("오픈소스 라이선스")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func cell(_ licenseName: String, license: String, url: String) -> some View {
        HStack {
            VStack {
                HStack {
                    Text(licenseName)
                        .font(.pretendard(.bold, size: 18))
                    Spacer()
                }
                HStack {
                    Text(url)
                        .font(.pretendard(size: 14))
                        .foregroundStyle(.textSecondary)
                    Spacer()
                }
            }
            Spacer()
            Text(license)
                .font(.pretendard(size: 16))
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical)
    }
}

#Preview {
    NavigationStack {
        PolicyView(store: Store(initialState: PolicyFeature.State(), reducer: {
            PolicyFeature()
        }))
    }
}
