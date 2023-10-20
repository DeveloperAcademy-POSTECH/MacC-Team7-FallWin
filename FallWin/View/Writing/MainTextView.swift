//
//  MainTextView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/18/23.
//

import SwiftUI
import ComposableArchitecture

struct MainTextView: View {
    var store: StoreOf<MainTextFeature>
    @State var mainText: String = ""
    @FocusState var focused
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.backgroundPrimary
                VStack {
                    Spacer()
                        .frame(height: 30)
                    DateView()
                    Spacer()
                        .frame(height: 36)
                    MessageView(titleText: "오늘 하루는 어땠나요?")
                    Spacer()
                        .frame(height: 15)
                    TextEditor(text: $mainText)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.textPrimary)
                        .focused($focused)
                        .padding(9)
                        .background() {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.backgroundPrimary)
                                .shadow(radius: 12)
                        }
                        
                }
                .padding()
            }
        }
    }
}

struct MessageMainTextView: View {
    var body: some View {
        Text("오늘 하루는 어땠나요?")
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(.textPrimary)
    }
}

#Preview {
    MainTextView(store: Store(initialState: MainTextFeature.State(selectedEmotion: "행복한")) {
        MainTextFeature()
    })
}
