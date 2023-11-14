//
//  ButtonView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/7/23.
//

import SwiftUI
import ComposableArchitecture

struct ConfirmButtonLabelView: View {
    let text: String
    let backgroundColor: Color
    let foregroundColor: Color
    let width: CGFloat?
    let isPrimary: Bool
    
    init(text: String, backgroundColor: Color, foregroundColor: Color, isPrimary: Bool = false) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.width = UIScreen.main.bounds.width - 40
        self.isPrimary = isPrimary
    }
    
    init(text: String, backgroundColor: Color, foregroundColor: Color, width: CGFloat?, isPrimary: Bool = false) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.width = width
        self.isPrimary = isPrimary
    }
    
    var body: some View {
        if let width = width {
            Text(text)
                .font(.pretendard(.semiBold, size: 18))
                .foregroundColor(foregroundColor)
                .frame(width: width, height: 54)
                .background(backgroundColor)
                .cornerRadius(8)
        } else {
            Text(text)
                .font(.pretendard(.semiBold, size: 18))
                .foregroundColor(foregroundColor)
                .frame(height: 54)
                .background(backgroundColor)
                .cornerRadius(8)
        }
    }
}

#Preview {
    ConfirmButtonLabelView(text: "다음", backgroundColor: .button, foregroundColor: .textOnButton)
}
