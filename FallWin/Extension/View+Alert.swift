//
//  View+Extension.swift
//  FallWin
//
//  Created by semini on 2023/11/05.
//

import Foundation
import SwiftUI

extension View{
    
    func alert<Alert>(isPresented:Binding<Bool>, alert: () -> Alert) -> some View where Alert: OhwaAlert {
        let keyWindow = UIApplication.shared.keyWindow!
        let vc = UIHostingController(rootView: alert())
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = .clear
        vc.definesPresentationContext = true
        
        return self.onChange(of: isPresented.wrappedValue, perform: {
            if $0{
                keyWindow.rootViewController?.topViewController().present(vc,animated: true)
            }
            else{
                keyWindow.rootViewController?.topViewController().dismiss(animated: true)
            }
        })
    }
    
    func alert<Content: View>(isPresented: Binding<Bool>, title: String? = nil, content: () -> Content, primaryButton: () -> OhwaAlertButton, secondaryButton: (() -> OhwaAlertButton)? = nil) -> some View {
        return alert(isPresented: isPresented) {
            OhwaAlertImpl(title: title, content: content, primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
    }
}
