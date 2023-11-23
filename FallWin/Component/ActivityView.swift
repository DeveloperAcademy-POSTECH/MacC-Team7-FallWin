//
//  ActivityView.swift
//  FallWin
//
//  Created by 최명근 on 11/13/23.
//

import Foundation
import SwiftUI

struct ShareImageWrapper: Identifiable, Equatable {
    var id: UUID
    var image: UIImage
}

struct ActivityView: UIViewControllerRepresentable {
    let image: ShareImageWrapper
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [image.image], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
