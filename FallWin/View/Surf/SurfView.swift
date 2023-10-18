//
//  SurfView.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//

import SwiftUI
import ComposableArchitecture

struct SurfView: View {
    let store: StoreOf<SurfFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text("Hello, world!")
        }
    }
}

#Preview {
    SurfView(store: Store(initialState: SurfFeature.State(), reducer: {
        SurfFeature()
    }))
}
