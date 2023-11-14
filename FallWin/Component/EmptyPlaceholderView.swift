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
            Text("아직 작성된 일기가 없어요")
                .font(.pretendard(.semiBold, size: 20))
                .foregroundColor(.textSecondary)
                .padding(.top, 16)
            Text("플러스 버튼을 눌러\n일기 쓰기를 시작해보세요")
                .font(.pretendard(.medium, size: 16))
                .foregroundColor(.textTertiary)
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    EmptyPlaceholderView()
}
