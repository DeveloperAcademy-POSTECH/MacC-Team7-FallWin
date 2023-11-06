//
//  OhwaAlert.swift
//  FallWin
//
//  Created by semini on 2023/11/06.
//

import Foundation
import SwiftUI
protocol OhwaAlert:View{
    associatedtype Content: View
    var content: Content {get}
    var primaryButton: OhwaAlertButton {get}
    var secondaryButton: OhwaAlertButton? {get}
    
    init(content: () -> Content, primaryButton: () ->  OhwaAlertButton, secondaryButton: (() -> OhwaAlertButton)?)
}
