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
    
    func returnAlert(isPresented:Binding<Bool>, dismiss: DismissAction) -> some View{
        return alert(isPresented: isPresented){
            OhwaAlertImpl{
                VStack(spacing:12){
                    Text("일기를 그만 쓸까요?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    Text("작성하던 내용은 저장됩니다.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }.foregroundColor(Color.black)
                    .padding(.top, 40)
                    .padding(.bottom, 30)
                    .padding(.horizontal,10)
            } primaryButton:{
                OhwaAlertButton(label:Text("계속 쓰기").foregroundColor(.textSecondary),color: Color(hexCode: "#FEFEFA")){
                    isPresented.wrappedValue = false
                }
            }secondaryButton: {
                OhwaAlertButton(label:Text("네, 그만 쓸래요").foregroundColor(.textOnButton), color: Color(hexCode: "#191919")){
                    isPresented.wrappedValue = false
                    dismiss()
                }
            }
        }
    }
    
    func bringDairyAlert(isPresented:Binding<Bool>, dismiss: DismissAction) -> some View{
        return alert(isPresented: isPresented){
            OhwaAlertImpl{
                VStack(spacing:12){
                    Text("임시 저장된 일기를 불러올까요?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    Text("이전에 작성 중인 내용을 불러옵니다. \n새 작성을 선택하실 경우 기존 내용은 삭제됩니다.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }.foregroundColor(Color.black)
                    .padding(.top, 40)
                    .padding(.bottom, 30)
                    .padding(.horizontal,10)
            } primaryButton:{
                OhwaAlertButton(label:Text("새 작성").foregroundColor(.textSecondary), color: Color(hexCode: "#FEFEFA")){
                    isPresented.wrappedValue = false
                }
            }secondaryButton: {
                OhwaAlertButton(label:Text("불러 오기").foregroundColor(.textOnButton), color: Color(hexCode: "#191919")){
                    isPresented.wrappedValue = false
                    dismiss()
                }
            }
        }
    }
}
