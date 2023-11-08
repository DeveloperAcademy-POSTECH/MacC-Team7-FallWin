//
//  OhwaAlertImpl.swift
//  FallWin
//
//  Created by semini on 2023/11/06.
//

import SwiftUI

struct OhwaAlertImpl<Content>:OhwaAlert where Content:View{
    let content: Content
    let primaryButton: OhwaAlertButton
    let secondaryButton: OhwaAlertButton?
    
    init(content: () -> Content, primaryButton: () ->  OhwaAlertButton, secondaryButton: (() -> OhwaAlertButton)? = nil){
        self.content = content()
        self.primaryButton = primaryButton()
        self.secondaryButton = secondaryButton?()
    }

    var body: some View {
        ZStack{
            Color.black.opacity(0.3).ignoresSafeArea()
            
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
                
        }
    }
}
