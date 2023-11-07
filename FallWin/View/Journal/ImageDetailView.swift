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
            GeometryReader { proxy in
                Image("IconFrustrated")
                    .resizable()
    //                .frame(width: proxy.size.width, height: proxy.size.height)
                    .scaledToFit()
                    .clipShape(Rectangle())
                    .modifier(ImageModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
            }
        }
    }
}

#Preview {
    ImageDetailView(store: Store(initialState: ImageDetailFeature.State(), reducer: {
        ImageDetailFeature()
    }))
}
