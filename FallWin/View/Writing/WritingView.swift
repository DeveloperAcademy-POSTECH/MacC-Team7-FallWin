//
//  WritingView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/18/23.
//

import SwiftUI
import ComposableArchitecture

struct WritingView: View {
    var store: StoreOf<WritingFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text("Hello, world!")
        }
    }
}

#Preview {
    WritingView(store: Store(initialState: WritingFeature.State()) {
        WritingFeature()
    })
}
