//
//  WebView.swift
//  FallWin
//
//  Created by 최명근 on 11/8/23.
//

import Foundation
import UIKit
import SwiftUI

struct WebView: UIViewControllerRepresentable {
    var url: String
    
    func makeUIViewController(context: Context) -> WebViewController {
        let vc = WebViewController()
        vc.url = url
        return vc
    }
    
    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
        
    }
}
