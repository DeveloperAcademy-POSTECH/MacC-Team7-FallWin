//
//  EmptyPlaceholderView.swift
//  FallWin
//
//  Created by 최명근 on 11/13/23.
//

import SwiftUI

struct EmptyPlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image("empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120)
            Text("empty_title")
                .font(.pretendard(.semiBold, size: 20))
                .foregroundColor(.textSecondary)
                .padding(.top, 16)
            Text("empty_message")
                .font(.pretendard(.medium, size: 16))
                .foregroundColor(.textTertiary)
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    EmptyPlaceholderView()
}
