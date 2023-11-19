//
//  OhwaAlertButton.swift
//  FallWin
//
//  Created by semini on 2023/11/06.
//

import SwiftUI

struct OhwaAlertButton: View {
    typealias Action = () -> ()
    
    private let action: Action
    private let label: Text
    let color: Color?
    
    let tempNickname: String?
    
    init(label: Text, color: Color? = nil, tempNickname: String? = nil, action: @escaping Action){
        self.label = label
        self.action = action
        self.color = color
        self.tempNickname = tempNickname
    }
    
    var body: some View {
        if let tempNickname = self.tempNickname {
            Button {
                action()
            } label: {
                label
                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                    .padding()
                    .background(tempNickname.isEmpty ? Color.buttonDisabled : .button)
            }
            .onAppear {
                print("tempNickname !=  nil : tempNickname: \(tempNickname)")
                print("tempNickname != nil : color:  \(String(describing: self.color))")
                print("in background: \(String(describing: tempNickname.isEmpty ? Color.buttonDisabled : .button))")
            }
        } else {
            Button{
                action()
            } label: {
                label
                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                    .padding()
            }
            .background(color)
            .cornerRadius(4)
            .onAppear {
                print("tempNickname ==  nil : tempNickname: \(String(describing: tempNickname))")
                print("tempNickname == nil : color:  \(String(describing: self.color))")
            }
        }
            
    }
}

struct NicknameSettingButton: View {

    let buttonType: NicknameButtonType
    @Binding var nickname: String
    @Binding var tempNickname: String
    @Binding var isAlertShown: Bool
    
    var body: some View {
        if buttonType == .update {
            Button {
                if !tempNickname.isEmpty {
                    nickname = tempNickname
                    tempNickname = ""
                    isAlertShown = false
                }
            } label: {
                Text("변경")
                    .foregroundStyle(tempNickname.isEmpty ? .textTertiary : .textOnButton)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            }
            .background(tempNickname.isEmpty ? .buttonDisabled : .button)
            .cornerRadius(4)
        } else {
            Button {
                tempNickname = ""
                isAlertShown = false
            } label: {
                Text("취소")
            }
            .background(Color.clear)
            .cornerRadius(4)
        }
    }
}

enum NicknameButtonType {
    case cancel
    case update
}
