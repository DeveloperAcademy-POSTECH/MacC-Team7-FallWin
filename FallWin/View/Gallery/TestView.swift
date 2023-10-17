//
//  TestView.swift
//  FallWin
//
//  Created by 최명근 on 10/18/23.
//

import SwiftUI

struct TestView: View {
    @State private var count: Int = 0
    
    var body: some View {
        VStack {
            Carousel(0..<count, id: \.self, spacing: 24, visibleSpacing: 24, initialPage: count - 1) { oldValue, newValue in
                
            } _: { i in
                Text("\(i)")
            }
            Button("+") {
                count += 1
            }
        }
    }
}

#Preview {
    TestView()
}
