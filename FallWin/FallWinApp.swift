//
//  FallWinApp.swift
//  FallWin
//
//  Created by 최명근 on 10/12/23.
//

import SwiftUI
import ComposableArchitecture

//@main
//struct FallWinApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView(store: Store(initialState: Feature.State(), reducer: {
//                Feature()
//            }))
//        }
//    }
//}

@main
struct FallWinApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: WritingFeature.State(), reducer: {
                WritingFeature()
            }))
        }
    }
}
