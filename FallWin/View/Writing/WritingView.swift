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
    @State var selectedEmotion: String?
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack {
                    Color.backgroundPrimary
                    VStack {
//                        HStack {
//                            Text("<")
//                            Spacer()
//                            Text("일기 쓰기")
//                                .font(.system(size: 18, weight: .bold))
//                                .foregroundStyle(.textPrimary)
//                            Spacer()
//                            Text("X")
//                        }
//                        Spacer()
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
                            EmotionView(selectedEmotion: $selectedEmotion)
                                .padding()
                        }
                        NavigationLink(value: selectedEmotion) {
                            Text("다음")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: UIScreen.main.bounds.width-30, height: 60)
                                .background(Color.button)
                                .cornerRadius(12)
                                .foregroundColor(Color.white)
                        }
                        .navigationTitle(Text("일기 쓰기"))
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
    @Binding var selectedEmotion: String?
    
    var colors: [[Color]] = [
        [Color.emotionHappy, Color.emotionNervous],
        [Color.emotionGrateful, Color.emotionSad],
        [Color.emotionJoyful, Color.emotionLonely],
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
    var images: [[Image]] = [
        [Image("IconHappy"), Image("IconNervous")],
        [Image("IconGrateful"), Image("IconSad")],
        [Image("IconJoyful"), Image("IconLonely")],
        [Image("IconProud"), Image("IconSuffocated")],
        [Image("IconTouched"), Image("IconShy")],
        [Image("IconExciting"), Image("IconLazy")],
        [Image("IconAnnoyed"), Image("IconFrustrated")]
    ]
    var cardWidth: CGFloat = (UIScreen.main.bounds.width-60)/2
    
    var body: some View {
        VStack {
            ForEach(0..<7) {row in
                HStack {
                    EmotionCardView(image: images[row][0], name: names[row][0], cardWidth: cardWidth)
                        .frame(width: cardWidth, height: cardWidth)
                        .border(selectedEmotion==names[row][0] ? colors[row][0] : Color.black, width: selectedEmotion==names[row][0] ? 2 : 0)
                        .opacity((selectedEmotion==nil || selectedEmotion == names[row][0]) ? 1 : 0.5 )
                        .onTapGesture(perform: {
                            selectedEmotion = names[row][0]
                        })
                    Spacer()
                    EmotionCardView(image: images[row][1], name: names[row][1], cardWidth: cardWidth)
                        .frame(width: cardWidth, height: cardWidth)
                        .border(selectedEmotion==names[row][1] ? colors[row][1] : Color.black, width: selectedEmotion==names[row][1] ? 2 : 0)
                        .opacity((selectedEmotion==nil || selectedEmotion == names[row][1]) ? 1 : 0.5 )
                        .onTapGesture(perform: {
                            selectedEmotion = names[row][1]
                        })
                }
            }
        }
    }
}
    
    
struct EmotionCardView: View {
    var image: Image
    var name: String
    var cardWidth: CGFloat
    
    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .frame(width: cardWidth/2, height: cardWidth/2)
            Text(name)
        }
        .background(
            Rectangle()
                .fill(Color.backgroundPrimary)
                .cornerRadius(8)
                .shadow(radius: 2)
                .frame(width: cardWidth, height: cardWidth)
        )
    }
}



#Preview {
    WritingView(store: Store(initialState: WritingFeature.State()) {
        WritingFeature()
    })
}
