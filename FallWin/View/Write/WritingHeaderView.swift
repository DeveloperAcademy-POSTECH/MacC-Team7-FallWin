//
//  WritingHeaderView\.swift
//  FallWin
//
//  Created by 최명근 on 11/14/23.
//

import SwiftUI

struct WritingHeaderView<Content: View>: View {
    var title: String
    var message: String? = nil
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                Text(title)
                    .font(.pretendard(.bold, size: 24))
                    .foregroundStyle(.textPrimary)
                if let message = message {
                    Text(message)
                        .font(.pretendard(.medium, size: 18))
                        .foregroundStyle(.textSecondary)
                }
            }
            .padding(.top, 40)
            .padding(.bottom, 36)
            
            content()
                .padding(.horizontal, 20)
        }
    }
}
