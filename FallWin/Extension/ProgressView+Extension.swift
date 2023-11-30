//
//  ProgressView+Extension.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/30/23.
//

import Foundation
import SwiftUI

struct ColoredProgressBar: ProgressViewStyle {
    var backgroundColor: Color
    var fillColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 4)
                .foregroundColor(backgroundColor)
                .overlay(
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(fillColor)
                            .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0))
                    }
                )
        }
    }
}
