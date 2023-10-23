//
//  Font+Extension.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/23/23.
//

import Foundation
import SwiftUI

extension Font {
    static func pretendard(_ type: PretendardType = .regular, size: CGFloat) -> Font {
        return .custom(type.rawValue, size: size)
    }
}

enum PretendardType: String {
    case regular = "Pretendard-Regular"
    case thin = "Pretendard-Thin"
    case extraLight = "Pretendard-ExtraLight"
    case light = "Pretendard-Light"
    case medium = "Pretendard-Medium"
    case semiBold = "Pretendard-SemoBold"
    case bold = "Pretendard-Bold"
    case extraBold = "Pretendard-ExtraBold"
    case black = "Pretendard-Black"
}
