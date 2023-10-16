//
//  RoundedShape.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//

import Foundation
import SwiftUI

struct RoundedShape: Shape {
    var radius: CGFloat = 25.0
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
