//
//  MainTextView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/18/23.
//

import SwiftUI
import ComposableArchitecture

struct MainTextView: View {
    var store: StoreOf<WritingFeature>
    @State var mainText: String = ""
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.backgroundPrimary
                VStack {
                    DateView()
                    Spacer()
                    MessageMainTextView()
                    Spacer()
//                    TextField(text: $mainText) {
//                        Text("무슨 일이 있었는지 작성해보세요.")
//                            .font(.system(size: 18, weight: .regular))
//                            .foregroundStyle(.textTeritary)
//                    }
//                    .foregroundColor(.textSecondary)
//                    .background(
//                        Rectangle()
//                            .fill(Color.backgroundPrimary)
//                            .cornerRadius(8)
//                            .shadow(radius: 2)
//                    )
//                    .shadow(radius: 2)
//                    .frame(width: UIScreen.main.bounds.width-30)
                    TextEditor(text: $mainText)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .frame(width: UIScreen.main.bounds.width-30)
                        .background(
                            Rectangle()
                                .fill(Color.backgroundPrimary)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                            //                                .frame(width: UIScreen.main.bounds.width-30, height: .infinity)
                        )
                        .shadow(radius: 2)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width-30)
                        .overlay(
                            // Placeholder 설정
                            mainText.isEmpty ? Text("무슨 일이 있었는지 작성해보세요.").foregroundColor(.textTeritary) : nil
                        )
                    Spacer()
                }
//                NavigationLink(value: selectedEmotion) {
//                    Text("다음")
//                        .font(.system(size: 18, weight: .semibold))
//                        .frame(width: UIScreen.main.bounds.width-30, height: 60)
//                        .background(Color.button)
//                        .cornerRadius(12)
//                        .foregroundColor(Color.white)
//                }
//                .navigationTitle(Text("일기 쓰기"))
//                .navigationDestination(for: String.self) { emotion in
//                    MainTextView(store: store)
//                }
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
    MainTextView(store: Store(initialState: WritingFeature.State()) {
        WritingFeature()
    })
}
