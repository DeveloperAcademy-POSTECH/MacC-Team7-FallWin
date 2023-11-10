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
            
<<<<<<< HEAD
            content
                .padding(.bottom, 60)
                .frame(maxWidth:UIScreen.main.bounds.width - 90 ,minHeight: 169)
                .overlay(
                    VStack(spacing:0){
                        if secondaryButton == nil {
                            Divider()
                        }
                        
                        HStack(){
                            if secondaryButton == nil {
                                primaryButton
                            } else {
                                primaryButton
                                    .padding([.leading,.bottom,.trailing])
                                if secondaryButton != nil{
                                    secondaryButton
                                        .padding([.trailing,.bottom])
                                }
                            }

                        }
                        .frame(height:60)
                        .font(.system(size: 16,weight: .bold))
                    }
                    , alignment: .bottom)
                .background(
                    Color(hexCode: "#FEFEFA")
                ).cornerRadius(10)
=======
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
>>>>>>> 60d4e8f882e53b7af6269642732b5d84261d8c3f
                
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
