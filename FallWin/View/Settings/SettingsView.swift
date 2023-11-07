//
//  SettingsView.swift
//  FallWin
//
//  Created by 최명근 on 11/7/23.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    let store: StoreOf<SettingsFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
        }
    }
}

#Preview {
    SettingsView(store: Store(initialState: SettingsFeature.State(), reducer: {
        SettingsFeature()
    }))
}
