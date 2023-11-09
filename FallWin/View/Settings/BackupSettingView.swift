//
//  BackupSettingView.swift
//  FallWin
//
//  Created by 최명근 on 11/8/23.
//

import SwiftUI
import ComposableArchitecture

struct BackupSettingView: View {
    let store: StoreOf<BackupSettingFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    BackupSettingView(store: Store(initialState: BackupSettingFeature.State(), reducer: {
        BackupSettingFeature()
    }))
}
