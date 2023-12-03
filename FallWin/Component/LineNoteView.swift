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
//            VStack(spacing: 0) {
//                ForEach(0..<Int(ceil((textViewSize.height + 0) / (fontSize + lineSpacing))), id: \.self) { i in
//                    Spacer()
//                    Divider()
//                        .background(.separator)
//                }
//            }
//            .frame(height: ceil(textViewSize.height + lineSpacing))
            
            HStack {
                Text(text)
                    .font(.sejong(size: fontSize))
                    .lineSpacing(lineSpacing)
                    .background(ViewGeometry())
                    .onPreferenceChange(ViewSizeKey.self) { value in
                        textViewSize = value
                    }
                    .padding(.bottom, 8)
                    .dynamicTypeSize(.medium)
                Spacer()
            }
            .padding(.horizontal, 4)
        }
    }
}

#Preview {
//        LineTextView(text: .constant("1\n2\n3\n4\n5kdlfjgklfdsjghjlkhkhkjhgikgiugikgikugiuguigiugiugiujhuuhiuhiugiufuyfuyfuykljdsflkgjdsflkgjlskdfjglksdfjglksdfjglksdfjlkgsfd\n6\n7\n8\n9\n10\n11\n12\ndsfg"))
//            .scrollDisabled(true)
//            .fixedSize(horizontal: true, vertical: true)
//            .frame(width: 100)
    
    ScrollView {
        LineNoteView(text: .constant("blah blah blah sdlkfjas fjklasd flkasjd flaksdjf laksdjflkasdj flkasjdf lkasjdflkawjfoiejalskdmf laskdjf lkawjfl kewj lidsjflkawjs deflkjaw dsoifjaweiopfj awoeifj osdaijf oawijf oiawej foiawejf iowajef oiawjef oisdjf oiasdj foiawje foiwaje foij\nasdf \nasdfasdf\nd\nd\nd\nd\nd\nd\nd\nasdfasdfasdfasdf\nd\nd\nd\nd\nd\ndasdfasdfasdfasdf\ndd\nd\nd\nd\nd\nd\nd\nasdfasdfasdfasdfasdfn\n\n\n\nsadf\nasf"), fontSize: 20, lineSpacing: 20)
//        LineNoteView(text: .constant("blah blah blah sdlkfjas fjklasd flkasjd flaksdjf laksdjflkasdj flkasjdf lkasjdflkawjfoiejalskdmf laskdjf lkawjfl kewj lidsjflkawjs deflkjaw dsoifjaweiopfj awoeifj osdaijf oawijf oiawej foiawejf iowajef oiawjef oisdjf oiasdj foiawje foiwaje foij\nasdf \nasdfasdf\nd\nd\nd"), fontSize: 20, lineSpacing: 20)
    }
}
