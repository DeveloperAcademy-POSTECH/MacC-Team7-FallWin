//
//  LineNoteView.swift
//  FallWin
//
//  Created by 최명근 on 11/7/23.
//

import Foundation
import SwiftUI
import UIKit

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
            }
            .frame(height: textViewSize.height + lineSpacing)
            
            HStack {
                Text(text)
                    .font(.sejong(size: fontSize))
                    .lineSpacing(lineSpacing)
                    .background(ViewGeometry())
                    .onPreferenceChange(ViewSizeKey.self) { value in
                        textViewSize = value
                    }
                    .padding(.bottom, 8)
                Spacer()
            }
            .padding(.horizontal, 4)
        }
    }
}

extension UITextView {
    var numberOfLine: Int {
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = sizeThatFits(size)
        
        return Int(estimatedSize.height / (self.font!.lineHeight))
    }
}

struct LineTextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    private func getLineView(textView: UITextView) -> UIView {
        let view = UIView()
        
        view.frame = textView.frame
        for i in 0..<textView.numberOfLine {
            let line = UIView()
            line.
            view.addSubview()
        }
        
        return view
    }
}

#Preview {
    LineTextView(text: .constant("1\n2\n3\n4\n5\n6\n7\n8\n9"))
//    LineNoteView(text: .constant("1\n2\n3\n4\n5\n6\n7\n8\n9"), fontSize: 20, lineSpacing: 20)
}
