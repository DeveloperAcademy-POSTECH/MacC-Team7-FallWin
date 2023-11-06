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
            Text("(추후 개발 예정...)")
                .font(.pretendard(.bold, size: 22))
        }
    }
}

#Preview {
    SurfView(store: Store(initialState: SurfFeature.State(), reducer: {
        SurfFeature()
    }))
}
