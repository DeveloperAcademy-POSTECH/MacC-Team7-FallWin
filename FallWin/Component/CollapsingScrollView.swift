//
//  CollapsingScrollView.swift
//  FallWin
//
//  Created by 최명근 on 10/20/23.
//

import SwiftUI

struct CollapsingScrollViewKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct CollapsingScrollView<Header: View, Content: View>: View {
    @ViewBuilder var header: () -> Header
    @ViewBuilder var content: () -> Content
    var onPullAction: (() -> Void)? = nil
    
    @State private var headerHeight: CGFloat = 0
    @State private var scrollY: CGFloat = .zero
    @State private var originY: CGFloat = .zero
    @State private var scale: CGFloat = 1
    @State private var pullAction: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    header()
                        .overlay {
                            GeometryReader { proxy in
                                Color.clear
                                    .onAppear {
                                        headerHeight = proxy.size.height
                                    }
                            }
                        }
                        .scaleEffect(CGSize(width: scale < 1 ? 1 : scale, height: scale < 1 ? 1 : scale), anchor: .top)
                    Spacer()
                }
                
                ScrollView {
                    VStack(spacing: 0) {
                        header()
                            .opacity(0)
                            .drawingGroup()
                        
                        LazyVStack {
                            content()
                                .background(
                                    GeometryReader { proxy in
                                        Color.clear
                                            .preference(key: CollapsingScrollViewKey.self, value: proxy.frame(in: .global).origin.y)
                                    }
                                )
                            Colors.backgroundPrimary.color()
                                .frame(height: proxy.size.height / 2)
                        }
                        .background {
                            Colors.backgroundPrimary.color().ignoresSafeArea()
                        }
                    }
                }
            }
            .onPreferenceChange(CollapsingScrollViewKey.self) { value in
                if originY == .zero {
                    originY = value
                }
                scrollY = value
                scale = scrollY / originY
                
                if scale > 1.25 {
                    pullAction = true
                }
            }
            .onChange(of: pullAction) { value in
                if let onPullAction = onPullAction {
                    HapticManager.shared.impact()
                    onPullAction()
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(
            Colors.backgroundPrimary.color().ignoresSafeArea()
        )
    }
}
