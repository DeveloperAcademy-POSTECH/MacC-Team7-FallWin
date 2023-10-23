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
                VStack(spacing: 0) {
                    DateView()
                        .padding(.top, 30)
                    MessageView(titleText: "오늘은 어떤 감정을 느꼈나요?", subTitleText: "오늘 느낀 감정을 선택해보세요")
                        .padding(.top, 36)
                    generateEmotionView()
                        .padding(.top, 15)
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
                    .padding()
                    .background{
                        Color.backgroundPrimary
                            .ignoresSafeArea()
                            .shadow(color: Color(hexCode: "#191919").opacity(0.05), radius: 4, y: -2)
                    }
                }
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
        
        WithViewStore(store , observe: { $0 }) { viewStore in
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 32) {
                    ForEach(emotions, id: \.0) { emotion in
                        generateEmotionCardView(emotion: emotion)
                            .onTapGesture {
                                if viewStore.selectedEmotion == emotion.0 {
                                    viewStore.send(.emotionSelection(nil))
                                } else {
                                    viewStore.send(.emotionSelection(emotion.0))
                                }
                            }
                    }
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    func generateEmotionCardView(emotion: (String, Color, Image)) -> some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            HStack {
                Spacer()
                VStack(spacing: 24) {
                    emotion.2
                    Text(emotion.0)
                }
                Spacer()
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(viewStore.selectedEmotion == emotion.0 ? emotion.1 : Color.clear, lineWidth: viewStore.selectedEmotion == emotion.0 ? 2 : 0)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.backgroundPrimary)
                    }
                    .aspectRatio(1, contentMode: .fill)
                    .shadow(color: viewStore.selectedEmotion == emotion.0 ? emotion.1.opacity(0.3) : Color(hexCode: "#191919").opacity(0.1), radius: 6)

            }
            .opacity(((viewStore.selectedEmotion == nil || viewStore.selectedEmotion == emotion.0) ? 1 : 0.5))
            .padding(8)
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
        VStack(spacing: 12) {
            Text(titleText)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.textPrimary)
                .multilineTextAlignment(.center)
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
