//
//  ImageZoomView.swift
//  FallWin
//
//  Created by 최명근 on 11/7/23.
//

import Foundation
import SwiftUI

struct ImageZoomView: UIViewControllerRepresentable {
    var image: UIImage?
    
    func makeUIViewController(context: Context) -> ImageZoomViewController {
        let vc = ImageZoomViewController()
        vc.image = image
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ImageZoomViewController, context: Context) {
        
    }
}
