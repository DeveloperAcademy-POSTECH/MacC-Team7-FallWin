//
//  View+Render.swift
//  FallWin
//
//  Created by 최명근 on 11/13/23.
//

import Foundation
import SwiftUI

extension View {
    @MainActor func render(scale: CGFloat? = nil) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        if let scale = scale {
            renderer.scale = scale
        }
        
        return renderer.uiImage
    }
}
