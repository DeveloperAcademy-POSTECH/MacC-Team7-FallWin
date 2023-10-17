//
//  Carousel.swift
//  FallWin
//
//  Created by 최명근 on 10/14/23.
//

import SwiftUI

struct ViewContainer: Identifiable {
    var id: UUID
    var view: AnyView
}

struct Carousel: View {
    var onPageChanged: ((_ oldValue: Int, _ newValue: Int) -> Void)?
    
    private let visibleSpace: CGFloat
    private let spacing: CGFloat
    private var views: [ViewContainer]
    
    @State private var currentPage: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let pageWidth = proxy.size.width - (spacing + visibleSpace) * 2
            let offsetX = (spacing + visibleSpace) + CGFloat(currentPage) * -pageWidth + CGFloat(currentPage) * -spacing + dragOffset
            
            LazyHStack(spacing: spacing) {
                ForEach(views, id: \.id) { view in
                    view.view
                        .frame(width: pageWidth, height: proxy.size.height)
                }
                .contentShape(Rectangle())
            }
            .offset(x: offsetX)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / pageWidth
                        let increment = Int(progress.rounded())
                        
                        withAnimation {
                            currentPage = max(min(currentPage + increment, views.count - 1), 0)
                        }
                    }
            )
            .onChange(of: currentPage) { old, new in
                if let onPageChanged = self.onPageChanged {
                    onPageChanged(new, old)
                }
            }
        }
        
    }
}

extension Carousel {
    init<Data: RandomAccessCollection, Content: View>(_ data: Data, id: KeyPath<Data.Element, Data.Element> = \.self, spacing: CGFloat = 8, visibleSpacing: CGFloat = 8, initialPage: Int = 0, onPageChanged: ((_ oldValue: Int, _ newValue: Int) -> Void)? = nil, @ViewBuilder _ content: @escaping (Data.Element) -> Content) {
        self.spacing = spacing
        self.visibleSpace = visibleSpacing
        self.views = data.map { ViewContainer(id: UUID(), view: AnyView(content($0[keyPath: id]))) }
        self.currentPage = initialPage
        self.onPageChanged = onPageChanged
    }
}

#Preview {
    Carousel(0..<5, id: \.self) { i in
        VStack {
            Spacer()
            Text("\(i)")
            Spacer()
            HStack {
                Spacer()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.white)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 2)
        )
    }
}
