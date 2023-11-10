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
                if let title = title {
                    Text(title)
                        .font(.pretendard(.bold, size: 20))
                        .foregroundStyle(Color.textPrimary)
                        .padding(.bottom, 12)
                }
                
                content
                    .foregroundStyle(Color.textPrimary)
                    .padding()
                    .padding(.bottom, 12)
                
                HStack {
                    primaryButton
                    if secondaryButton != nil{
                        secondaryButton
                    }
                }
                .frame(maxHeight: 45)
                .padding([.leading, .trailing, .bottom])
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
