//
//  ProfileView.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//

import SwiftUI
import ComposableArchitecture

struct ProfileView: View {
    let store: StoreOf<ProfileFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text("Hello, World!")
        }
    }
}

#Preview {
    ProfileView(store: Store(initialState: ProfileFeature.State(), reducer: {
        ProfileFeature()
    }))
}
