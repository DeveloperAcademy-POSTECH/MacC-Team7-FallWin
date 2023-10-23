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
                        .padding(.top, 21)
                    HStack {
                        Spacer()
                        Button {
                            viewStore.send(.showMainTextView(nil))
                        } label: {
                            Text("건너뛰기")
                                .font(.pretendard(.medium, size: 18))
                                .frame(height: 54)
                                .background(Color.backgroundPrimary)
                                .foregroundColor(Color.textSecondary)
                        }
                        Spacer()
                        Button {
                            viewStore.send(.showMainTextView(viewStore.selectedEmotion))
                            
                        } label: {
                            Text("다음")
                                .font(.pretendard(.semiBold, size: 18))
                                .frame(width: UIScreen.main.bounds.width * 0.6, height: 54)
                                .background(viewStore.selectedEmotion == nil ? Color.buttonDisabled : Color.button)
                                .cornerRadius(9)
                                .foregroundColor(Color.white)
                        }
                        .disabled(viewStore.selectedEmotion == nil)
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 15)
                    .padding(.bottom, 30)
//                    .padding([.leading, .trailing], 20)
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
                        .font(.pretendard(.medium, size: 18))
                        .foregroundColor(Color.textPrimary)
                }
                Spacer()
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(viewStore.selectedEmotion == emotion.0 ? emotion.1 : Color.clear, lineWidth: viewStore.selectedEmotion == emotion.0 ? 2 : 0) // line width 조금 더 늘려보기
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.backgroundPrimary)
                    }
                    .aspectRatio(1, contentMode: .fill)
                    .shadow(color: viewStore.selectedEmotion == emotion.0 ? emotion.1.opacity(0.3) : Color(hexCode: "#191919").opacity(0.1), radius: 6) // 더 퍼지게

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
//            Text("<")
            Text(String(format: "%d년 %d월 %d일", date.year, date.month, date.day))
                .font(.pretendard(.semiBold, size: 20))
                .foregroundStyle(.textPrimary)
//            Text(">")
        }
    }
}

struct MessageView: View {
    var titleText: String
    var subTitleText: String?
    
    var body: some View {
        VStack(spacing: 12) {
            Text(titleText)
                .font(.pretendard(.bold, size: 24))
                .foregroundStyle(.textPrimary)
                .multilineTextAlignment(.center)
            if let subTitleText = subTitleText {
                Text(subTitleText)
                    .font(.pretendard(.medium, size: 18))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.textSecondary)
                    .padding(.bottom, 15)
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
