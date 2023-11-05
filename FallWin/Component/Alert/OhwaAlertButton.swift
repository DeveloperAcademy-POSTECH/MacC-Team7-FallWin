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
    
    init(label:Text,color:Color? = nil,action: @escaping Action){
        self.label = label
        self.action = action
        self.color = color
    }
    
    var body: some View {
        Button{
            action()
        }label: {
            label.frame(maxWidth:.infinity, maxHeight: .infinity)
                .padding()
        }
        .background(color)
        .cornerRadius(4)
            
    }
}
