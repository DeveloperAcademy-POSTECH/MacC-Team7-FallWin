//
//  ImageDetailView.swift
//  FallWin
//
//  Created by 최명근 on 11/2/23.
//

import SwiftUI
import ComposableArchitecture

struct ImageDetailView: View {
    var image: UIImage?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { proxy in
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Rectangle())
                    .modifier(ImageModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Label("dismiss", systemImage: "xmark")
                }
                .labelStyle(.iconOnly)
            }
        }
    }
}

#Preview {
    ImageDetailView()
}
