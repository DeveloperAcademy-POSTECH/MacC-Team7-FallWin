//
//  TabBarLabelStyle.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//

import Foundation
import SwiftUI

struct TabBarLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 4) {
            configuration.icon
            configuration.title
                .font(.caption)
        }
    }
    
}
