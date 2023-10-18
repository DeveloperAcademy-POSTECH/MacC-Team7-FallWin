//
//  WritingView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/18/23.
//

import SwiftUI
import ComposableArchitecture

struct WritingView: View {
    var store: StoreOf<WritingFeature>
    var date = Date()
    var selectedEmotion: String? = "행복함"
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack {
                    Color.backgroundPrimary
                    VStack {
                        HStack {
                            Text("<")
                            Spacer()
                            Text("일기 쓰기")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.textPrimary)
                            Spacer()
                            Text("X")
                        }
                        Spacer()
                        HStack {
                            Text("<")
                            Text(String(format: "%d년 %d월 %d일", date.year, date.month, date.day))
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.textPrimary)
                            Text(">")
                        }
                        Spacer()
                        VStack {
                            Text("오늘은 어떤 감정을 느꼈나요?")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.textPrimary)
                            Text("오늘 느낀 감정을 선택해보세요")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.textSecondary)
                        }
                        ScrollView() {
                            EmotionView()
                        }
                        NavigationLink(value: selectedEmotion) {
                            Text("다음")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: UIScreen.main.bounds.width-30, height: 60)
                                .background(Color.button)
                                .cornerRadius(12)
                                .foregroundColor(Color.white)
                        }
                        .navigationDestination(for: String.self) { emotion in
                                TestView()
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct TestView: View {
    var selectedEmotion: String?
    
    var body: some View {
        Text(selectedEmotion ?? "")
    }
}

struct EmotionView: View {
    var images: [[Color]] = [
        [Color.emotionHappy, Color.emotionNervous],
        [Color.emotionGrateful, Color.emotionSad],
        [Color.emotionJoyful, Color.emotionLonley],
        [Color.emotionProud, Color.emotionSuffocated],
        [Color.emotionTouched, Color.emotionShy],
        [Color.emotionExciting, Color.emotionLazy],
        [Color.emotionAnnoyed, Color.emotionFrustrated]
    ]
    var names: [[String]] = [
        ["행복한", "불안한"],
        ["감사한", "슬픈"],
        ["신나는", "외로운"],
        ["뿌듯한", "답답한"],
        ["감동받은", "부끄러운"],
        ["기대되는", "귀찮은"],
        ["짜증나는", "당황한"]
    ]
    
    var body: some View {
        VStack {
            ForEach(0..<7) {row in
                HStack {
                    EmotionCardView(image: images[row][0], name: names[row][0])
                    EmotionCardView(image: images[row][1], name: names[row][1])
                }
            }
        }
    }
}
    
    
struct EmotionCardView: View {
    var image: Color
    var name: String
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(image)
                .frame(width: 100, height: 100)
            Text(name)
        }
        .padding()
        .background(
            Rectangle()
                .fill(Color.backgroundPrimary)
//                .frame(width: 150, height: 150)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        )
        .padding()
    }
}



#Preview {
    WritingView(store: Store(initialState: WritingFeature.State()) {
        WritingFeature()
    })
}
