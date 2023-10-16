//
//  Carousel.swift
//  FallWin
//
//  Created by 최명근 on 10/14/23.
//

import SwiftUI

struct Carousel: View {
    
    private let spacing: CGFloat
    private var views: [AnyView]
    
    @State private var currentPage: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let pageWidth = proxy.size.width - spacing * 4
            let offsetX = spacing * 2 + CGFloat(currentPage) * -pageWidth + CGFloat(currentPage) * -spacing + dragOffset
            
            LazyHStack(spacing: spacing) {
                ForEach(0..<views.count) { i in
                    views[i]
                        .frame(width: pageWidth, height: proxy.size.height)
                        .border(.red)
                }
                .contentShape(Rectangle())
            }
            .offset(x: offsetX)
            .gesture(
                DragGesture()
//                    .updating($dragOffset) { value, state, transaction in
//                        state = value.translation.width
//                    }
                    .onEnded { value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / pageWidth
                        let increment = Int(progress.rounded())
                        
                        withAnimation {
                            currentPage = max(min(currentPage + increment, views.count - 1), 0)
                        }
                    }
            )
        }
        
    }
}

extension Carousel {
    init<Data: RandomAccessCollection, Content: View>(_ data: Data, id: KeyPath<Data.Element, Data.Element> = \.self, spacing: CGFloat = 8, initialPage: Int = 0, @ViewBuilder _ content: @escaping (Data.Element) -> Content) {
        self.spacing = spacing
        self.views = data.map { AnyView(content($0[keyPath: id])) }
        self.currentPage = initialPage
    }
}

#Preview {
    Carousel(0..<5, id: \.self) { i in
        Text("\(i)")
    }
}
