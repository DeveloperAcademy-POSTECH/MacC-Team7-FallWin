//
//  LicenseView.swift
//  FallWin
//
//  Created by 최명근 on 12/1/23.
//

import SwiftUI
import ComposableArchitecture

struct License: Identifiable, Equatable {
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
    
    enum LicenseType: Equatable {
        case MIT
        case Apache2
        case etc(String)
    }
}

struct LicenseView: View {
    let store: StoreOf<LicenseFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                ForEach(viewStore.licenses) { license in
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
    LicenseView(store: Store(initialState: LicenseFeature.State(), reducer: {
        LicenseFeature()
    }))
}
