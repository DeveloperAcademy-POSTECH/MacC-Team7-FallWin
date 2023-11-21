//
//  DrawStyleView.swift
//  FallWin
//
//  Created by 최명근 on 11/14/23.
//

import SwiftUI

struct DrawStyleItem: Identifiable {
    var drawingStyle: DrawingStyle
    var image: String
    
    var id: DrawingStyle {
        self.drawingStyle
    }
}

struct DrawStyleView: View {
    @Binding var tab: JournalWritingTab
    @Binding var selected: DrawingStyle?
    
    private let drawStyles: [DrawStyleItem] = [
        DrawStyleItem(drawingStyle: .crayon, image: "dsCrayon"),
        DrawStyleItem(drawingStyle: .oilPainting, image: "dsOilPainting"),
        DrawStyleItem(drawingStyle: .waterColor, image: "dsWaterColor"),
        DrawStyleItem(drawingStyle: .sketch, image: "dsSketch"),
        DrawStyleItem(drawingStyle: .anime, image: "dsAnimation"),
        DrawStyleItem(drawingStyle: .pixelArt, image: "dsPixelArt"),
        DrawStyleItem(drawingStyle: .vanGogh, image: "dsVanGogh"),
        DrawStyleItem(drawingStyle: .monet, image: "dsMonet"),
        DrawStyleItem(drawingStyle: .dali, image: "dsDali"),
    ]
    
    var body: some View {
        VStack {
            WritingHeaderView(title: "drawing_style_title".localized, message: "drawing_style_subtitle".localized) {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), alignment: .center, spacing: 0) {
                        ForEach(drawStyles) { style in
                            drawStyleCell(drawingStyle: style)
                                .padding()
                                .onTapGesture {
                                    selected = style.drawingStyle
                                }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func drawStyleCell(drawingStyle style: DrawStyleItem) -> some View {
        VStack(spacing: 16) {
            Image(style.image)
                .resizable()
                .scaledToFit()
                .clipShape(
                    Circle()
                )
                .background (
                    Circle()
                        .fill(Color.backgroundPrimary)
                        .shadow(color: selected == style.drawingStyle ? .shadow.opacity(0.2) : .shadow.opacity(0.1), radius: selected == style.drawingStyle ?  8 : 4)
                )
            Text(String(style.drawingStyle.name() ?? ""))
                .font(selected == style.drawingStyle ? .pretendard(.bold, size: 16) : .pretendard(.medium, size: 16))
                .foregroundStyle(.textPrimary)
                .multilineTextAlignment(.center)
        }
        .opacity((selected == nil || selected == style.drawingStyle) ? 1 : 0.5)
    }
}

#Preview {
    DrawStyleView(tab: .constant(.style), selected: .constant(.dali))
}
