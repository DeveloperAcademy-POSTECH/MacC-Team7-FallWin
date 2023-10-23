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
//    @State var navPath: NavigationPath = .init()
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
                ZStack {
                    Color.backgroundPrimary
                    VStack {
                        DateView()
                        MessageView(titleText: "오늘은 어떤 감정을 느꼈나요?", subTitleText: "오늘 느낀 감정을 선택해보세요")
                        ScrollView() {
                            generateEmotionView()
                                .padding()
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Spacer()
                            Button {
                                viewStore.send(.showMainTextView(nil))
                            } label: {
                                Text("건너뛰기")
                                    .font(.system(size: 18, weight: .semibold))
                                    .frame(width: UIScreen.main.bounds.width * 0.16, height: 45)
                                    .background(Color.backgroundPrimary)
                                    .foregroundColor(Color.textSecondary)
                            }
                            Spacer()
                            Spacer()
                            Button {
                                viewStore.send(.showMainTextView(viewStore.selectedEmotion))
                                
                            } label: {
                                Text("다음")
                                    .font(.system(size: 18, weight: .semibold))
                                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 45)
                                    .background(viewStore.selectedEmotion == nil ? Color.buttonDisabled : Color.button)
                                    .cornerRadius(9)
                                    .foregroundColor(Color.white)
                            }
                            .disabled(viewStore.selectedEmotion == nil)
                            Spacer()
                        }
                    }
                    .padding()
                }
                .navigationTitle(Text("일기 쓰기"))
                .navigationDestination(store: store.scope(state: \.$mainText, action: WritingFeature.Action.mainText), destination: { store in
                    MainTextView(store: store)
                })
        }
    }
    
    @ViewBuilder
    func generateEmotionView() -> some View {
        
        let emotions: [(String, Color, Image)] = [
            ("행복한", Color.emotionHappy, Image("IconHappy")),
            ("불안한", Color.emotionNervous, Image("IconNervous")),
            ("감사한", Color.emotionGrateful, Image("IconGrateful")),
            ("슬픈", Color.emotionSad, Image("IconSad")),
            ("신나는", Color.emotionJoyful, Image("IconJoyful")),
            ("외로운", Color.emotionLonely, Image("IconLonely")),
            ("뿌듯한", Color.emotionProud, Image("IconProud")),
            ("답답한", Color.emotionSuffocated, Image("IconSuffocated")),
            ("감동받은", Color.emotionTouched, Image("IconTouched")),
            ("부끄러운", Color.emotionShy, Image("IconShy")),
            ("기대되는", Color.emotionExciting, Image("IconExciting")),
            ("귀찮은", Color.emotionLazy, Image("IconLazy")),
            ("짜증나는", Color.emotionAnnoyed, Image("IconAnnoyed")),
            ("당황한", Color.emotionFrustrated, Image("IconFrustrated"))
        ]
        
        let cardWidth: CGFloat = UIScreen.main.bounds.width * 0.4
        
        WithViewStore(store , observe: { $0 }) { viewStore in
            VStack {
                ForEach(0..<14) { idx in
                    if idx % 2 == 0 {
                        HStack {
                            Spacer()
                            generateEmotionCardView(emotion: emotions[idx])
                                .frame(width: cardWidth, height: cardWidth)
                                .onTapGesture(perform: {
                                    if viewStore.selectedEmotion == emotions[idx].0 {
                                        viewStore.send(.emotionSelection(nil))
                                    } else {
                                        viewStore.send(.emotionSelection(emotions[idx].0))
                                    }
                                })
                            Spacer()
                            generateEmotionCardView(emotion: emotions[idx+1])
                                .frame(width: cardWidth, height: cardWidth)
                                .onTapGesture(perform: {
                                    if viewStore.selectedEmotion == emotions[idx+1].0 {
                                        viewStore.send(.emotionSelection(nil))
                                    } else {
                                        viewStore.send(.emotionSelection(emotions[idx+1].0))
                                    }
                                })
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func generateEmotionCardView(emotion: (String, Color, Image)) -> some View {
        
        WithViewStore(store, observe: {$0}) { viewStore in
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 12)
                    .stroke(viewStore.selectedEmotion == emotion.0 ? emotion.1 : Color.black, lineWidth: viewStore.selectedEmotion == emotion.0 ? 2 : 0)
                    .fill(Color.backgroundPrimary)
                    .shadow(radius: 2)
                    .frame(width: geo.size.width, height: geo.size.width)
                    .overlay(
                        VStack {
                            emotion.2
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width/2, height: geo.size.width/2)
                            Text(emotion.0)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.textPrimary)
                        }
                    )
                    .opacity(((viewStore.selectedEmotion == nil || viewStore.selectedEmotion == emotion.0) ? 1 : 0.5))
            }
        }
    }
}

struct DateView: View {
    var date = Date()
    
    var body: some View {
        HStack {
            Text("<")
            Text(String(format: "%d년 %d월 %d일", date.year, date.month, date.day))
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.textPrimary)
            Text(">")
        }
    }
}

struct MessageView: View {
    var titleText: String
    var subTitleText: String?
    
    var body: some View {
        VStack {
            Text(titleText)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.textPrimary)
            if let subTitleText = subTitleText {
                Text(subTitleText)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.textSecondary)
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


#Preview {
    WritingView(store: Store(initialState: WritingFeature.State()) {
        WritingFeature()
    })
}
