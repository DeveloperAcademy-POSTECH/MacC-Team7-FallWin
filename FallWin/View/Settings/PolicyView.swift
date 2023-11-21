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
                    WebView(url: "https://el-capitan.notion.site/4fdc74d2d58b441199e945b100befe10?pvs=4")
                        .toolbar(.hidden, for: .tabBar)
                    
                } label: {
                    Text("settings_policy_service")
                        .font(.pretendard(size: 18))
                        .padding(.vertical, 8)
                }
                .listRowBackground(Color.backgroundPrimary)
                
                NavigationLink {
                    WebView(url: "https://el-capitan.notion.site/de1c30b56c874f01b97e8e1c23aaa33b?pvs=4")
                        .toolbar(.hidden, for: .tabBar)
                    
                } label: {
                    Text("settings_policy_privacy")
                        .font(.pretendard(size: 18))
                        .padding(.vertical, 8)
                }
                .listRowBackground(Color.backgroundPrimary)
                
                NavigationLink {
                    LicenseView()
                    
                } label: {
                    Text("settings_policy_license")
                        .font(.pretendard(size: 18))
                        .padding(.vertical, 8)
                }
                .listRowBackground(Color.backgroundPrimary)
            }
            .listStyle(.plain)
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("settings_policy")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct License: Identifiable {
    var name: String
    var license: LicenseType
    var url: String
    
    var id: String {
        name
    }
    
    func getLicenseTypeString() -> String {
        switch self.license {
        case .MIT: return "MIT"
        case .Apache2: return "Apache 2.0"
        case .etc(let string): return string
        }
    }
    
    enum LicenseType {
        case MIT
        case Apache2
        case etc(String)
    }
}

struct LicenseView: View {
    private let licenses: [License] = [
        License(name: "Swift Composable Architecture", license: .MIT, url: "https://github.com/pointfreeco/swift-composable-architecture"),
        License(name: "SwiftKeychainWrapper", license: .MIT, url: "https://github.com/jrendel/SwiftKeychainWrapper"),
        License(name: "Alamofire", license: .MIT, url: "https://github.com/Alamofire/Alamofire"),
        License(name: "lottie-ios", license: .Apache2, url: "https://github.com/airbnb/lottie-ios"),
        License(name: "ZIPFoundation", license: .MIT, url: "https://github.com/weichsel/ZIPFoundation"),
        License(name: "Karlo", license: .etc("CreativeML Open RAIL-M license"), url: "https://github.com/kakaobrain/karlo"),
        License(name: "Pretendard", license: .etc("OFL"), url: "https://cactus.tistory.com/306")
    ]
    
    var body: some View {
        List {
            ForEach(licenses) { license in
                NavigationLink {
                    WebView(url: license.url)
                        .toolbar(.hidden, for: .tabBar)
                    
                } label: {
                    cell(license.name, license: license.getLicenseTypeString(), url: license.url)
                }
                .listRowBackground(Color.backgroundPrimary)
            }
        }
        .listStyle(.plain)
        .background(Color.backgroundPrimary.ignoresSafeArea())
        .navigationTitle("settings_policy_license")
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
