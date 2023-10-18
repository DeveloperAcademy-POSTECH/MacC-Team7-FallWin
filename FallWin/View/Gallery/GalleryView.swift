//
//  GalleryView.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//

import SwiftUI
import ComposableArchitecture

struct GalleryView: View {
    let store: StoreOf<GalleryFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text("Hello, world!")
        }
    }
}

#Preview {
    GalleryView(store: Store(initialState: GalleryFeature.State(), reducer: {
        GalleryFeature()
    }))
}
