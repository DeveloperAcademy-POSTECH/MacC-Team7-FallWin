//
//  OhwaAlertImpl.swift
//  FallWin
//
//  Created by semini on 2023/11/06.
//

import SwiftUI

struct OhwaAlertImpl<Content>:OhwaAlert where Content:View {
    let title: String?
    let content: Content
    let primaryButton: OhwaAlertButton
    let secondaryButton: OhwaAlertButton?
    
    init(title: String? = nil, content: () -> Content, primaryButton: () ->  OhwaAlertButton, secondaryButton: (() -> OhwaAlertButton)? = nil) {
        self.title = title
        self.content = content()
        self.primaryButton = primaryButton()
        self.secondaryButton = secondaryButton?()
    }

    var body: some View {
        ZStack{
            Color.black.opacity(0.3).ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    if let title = title {
                        Text(title)
                            .font(.pretendard(.bold, size: 20))
                            .foregroundStyle(Color.textPrimary)
                            .padding(.bottom, 12)
                    }
                    
                    content
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(Color.textPrimary)
                        .padding(.bottom, 32)
                }
                .padding(.top, 8)
                
                HStack {
                    primaryButton
                        .font(.pretendard(.semiBold, size: 14))
                    if secondaryButton != nil{
                        secondaryButton
                            .font(.pretendard(.semiBold, size: 14))
                    }
                }
                .frame(maxHeight: 45)
                .padding(.bottom, 4)
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.backgroundPrimary)
            }
            .padding(32)
        }
    }
}
