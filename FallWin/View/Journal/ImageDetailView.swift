//
//  ImageDetailView.swift
//  FallWin
//
//  Created by 최명근 on 11/2/23.
//

import SwiftUI
import ComposableArchitecture

struct ImageDetailView: View {
    let store: StoreOf<ImageDetailFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    ImageDetailView(store: Store(initialState: ImageDetailFeature.State(), reducer: {
        ImageDetailFeature()
    }))
}
