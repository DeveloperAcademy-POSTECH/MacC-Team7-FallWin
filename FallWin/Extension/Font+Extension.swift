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
    
    static func sejong(size: CGFloat) -> Font {
        return .custom(SejongGeulggot.regular.rawValue, size: size)
    }
    
    static func uhbeeSehyun(_ type: UhBeeSehyun = .regular, size: CGFloat) -> Font {
        return .custom(type.rawValue, size: size)
    }
}

enum PretendardType: String {
    case regular = "Pretendard-Regular"
    case thin = "Pretendard-Thin"
    case extraLight = "Pretendard-ExtraLight"
    case light = "Pretendard-Light"
    case medium = "Pretendard-Medium"
    case semiBold = "Pretendard-SemiBold"
    case bold = "Pretendard-Bold"
    case extraBold = "Pretendard-ExtraBold"
    case black = "Pretendard-Black"
}

enum SejongGeulggot: String {
    case regular = "SejongGeulggot"
}

enum UhBeeSehyun: String {
    case regular = "UhBeeSe_hyun"
    case bold = "UhBeeSe_hyunBold"
}
