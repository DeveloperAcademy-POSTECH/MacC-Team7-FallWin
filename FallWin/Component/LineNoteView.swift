//
//  LineNoteView.swift
//  FallWin
//
//  Created by 최명근 on 11/7/23.
//

import Foundation
import SwiftUI

struct LineNoteView: View {
    @Binding var text: String
    var fontSize: CGFloat = 20
    var lineSpacing: CGFloat = 0
    
    @State private var textViewSize: CGSize = .zero
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                ForEach(0..<Int((textViewSize.height + lineSpacing) / (fontSize + lineSpacing)), id: \.self) { i in
                    Spacer()
                    Divider()
                        .background(.separator)
                }
                .onChange(of: textViewSize, perform: { value in
                    print("text lines: \(textViewSize.height / (fontSize + lineSpacing))")
                    print("div lines: \((0...Int(textViewSize.height / (fontSize + lineSpacing))).count)")
                })
            }
            .frame(height: textViewSize.height + lineSpacing)
            
            Text(text)
                .font(.sejong(size: fontSize))
                .lineSpacing(lineSpacing)
                .background(ViewGeometry())
                .onPreferenceChange(ViewSizeKey.self) { value in
                    textViewSize = value
                }
                .padding(.bottom, 8)
        }
    }
}

#Preview {
    LineNoteView(text: .constant("1\n2\n3\n4\n5\n6\n7\n8\n9"), fontSize: 20, lineSpacing: 20)
}
