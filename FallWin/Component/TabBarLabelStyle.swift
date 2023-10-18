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
        VStack(spacing: 8) {
            configuration.icon
            configuration.title
                .font(.caption)
        }
    }
    
}

#Preview {
    CvasTabView(selection: .constant(.gallery)) {
        Rectangle()
            .fill(.gray)
            .tabItem(.init(title: "갤러리", image: "", tabItem: .gallery), selection: .constant(.gallery))
        
        Rectangle()
            .fill(.black)
            .tabItem(.init(title: "프로필", image: "", tabItem: .profile), selection: .constant(.gallery))
    }
}
