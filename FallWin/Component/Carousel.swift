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
    var onPageChanged: ((_ newValue: Int) -> Void)?
    
    private let visibleSpace: CGFloat
    private let spacing: CGFloat
    private var views: [ViewContainer]
    
    @Binding private var currentPage: Int
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let pageWidth = proxy.size.width - (spacing + visibleSpace) * 2
            let offsetX = (spacing + visibleSpace) + CGFloat(currentPage) * (-pageWidth * 0.9) + CGFloat(currentPage) * -spacing + dragOffset
            
            LazyHStack(spacing: spacing) {
                ForEach(views.indices, id: \.self) { i in
                    let width = currentPage == i ? pageWidth : pageWidth * 0.9
                    let height = currentPage == i ? proxy.size.height : proxy.size.height * 0.9
                    views[i].view
                        .frame(width: width, height: height)
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
                        
                        withAnimation(.linear(duration: 0.2)) {
                            currentPage = max(min(currentPage + increment, views.count - 1), 0)
                        }
                    }
            )
            .onChange(of: currentPage) { new in
                if let onPageChanged = self.onPageChanged {
                    onPageChanged(new)
                }
            }
        }
    }
}

extension Carousel {
    init<Data: RandomAccessCollection, Content: View>(_ data: Data, id: KeyPath<Data.Element, Data.Element> = \.self, index: Binding<Int> = .constant(0), spacing: CGFloat = 8, visibleSpacing: CGFloat = 8, initialPage: Int = 0, onPageChanged: ((_ newValue: Int) -> Void)? = nil, @ViewBuilder _ content: @escaping (Data.Element) -> Content) {
        self.spacing = spacing
        self.visibleSpace = visibleSpacing
        self.views = data.map { ViewContainer(id: UUID(), view: AnyView(content($0[keyPath: id]))) }
        self._currentPage = index
        self.onPageChanged = onPageChanged
    }
}

#Preview {
    Carousel(0..<5, id: \.self, initialPage: 3) { i in
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
