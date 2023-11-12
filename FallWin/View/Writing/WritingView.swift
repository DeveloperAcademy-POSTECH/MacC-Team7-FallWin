//
//  WritingView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/18/23.
//

import SwiftUI
import ComposableArchitecture
import FirebaseAnalytics

struct WritingView: View {
    var store: StoreOf<WritingFeature>
    //    @State var navPath: NavigationPath = .init()
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                VStack(spacing: 0) {
//                    DateView()
//                        .padding(.top, -30)
                    MessageView(titleText: "오늘은 어떤 감정을 느꼈나요?", subTitleText: "그림으로 담고 싶은 감정을 선택해보세요")
                        .padding(.top, 36)
                    generateEmotionView()
                        .padding(.top, 16)
                    HStack {
                        Spacer()
                        Button {
                            //TODO: 이부분 소통해서 다시 진행할 것
                            //다음버튼을 눌렀을때, 해당하는 감정 요소의 트랙킹이 되도록 
                            viewStore.send(.showMainTextView(nil))
                            Tracking.logEvent(Tracking.Event.A2_1_3__일기작성_감정선택_건너뛰기.rawValue)
                            print("@Log : A2_1_3__일기작성_감정선택_건너뛰기")
                            
                        } label: {
                            ConfirmButtonLabelView(text: "건너뛰기", backgroundColor: .backgroundPrimary, foregroundColor: .textSecondary, width: nil)
                        }
                        Spacer()
                        Button {
                            viewStore.send(.showMainTextView(viewStore.selectedEmotion))
                            Tracking.logEvent(Tracking.Event.A2_1_4__일기작성_감정선택_다음.rawValue)
                            print("@Log : A2_1_4__일기작성_감정선택_다음")
                            
                        } label: {
                            ConfirmButtonLabelView(text: "다음", backgroundColor: viewStore.selectedEmotion == nil ? Color.buttonDisabled : Color.button, foregroundColor: .textOnButton, width: UIScreen.main.bounds.width * 0.6)
                        }
                        .disabled(viewStore.selectedEmotion == nil)
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 15)
                    .padding(.bottom, 16)
//                    .padding([.leading, .trailing], 20)
                    .background{
                        Color.backgroundPrimary
                            .ignoresSafeArea()
                            .shadow(color: Color(hexCode: "#191919").opacity(0.05), radius: 4, y: -2)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    DateView()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewStore.send(.cancelWriting)
                        Tracking.logEvent(Tracking.Event.A2_1_2__일기작성_감정선택_닫기.rawValue)
                        print("@Log : A2_1_2__일기작성_감정선택_닫기")
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(store: store.scope(state: \.$mainText, action: WritingFeature.Action.mainText), destination: { store in
                MainTextView(store: store)
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
            .onAppear {
                Tracking.logScreenView(screenName: Tracking.Screen.V2_1__일기작성_감정선택뷰.rawValue)
                print("@Log : V2_1__일기작성_감정선택뷰")
               }
        }
    }
    
    @ViewBuilder
    func generateEmotionView() -> some View {
        //TODO: 이부분 소통해서 다시 진행할 것
        let emotions: [(String, Color, Image, String, String)] = [
            ("happy", Color.emotionHappy, Image("IconHappy"), "행복한", "A2_1_5_1__일기작성_감정선택_행복한"),
            ("proud", Color.emotionProud, Image("IconProud"), "뿌듯한", "A2_1_5_2__일기작성_감정선택_뿌듯한"),
            ("touched", Color.emotionTouched, Image("IconTouched"), "감동받은", "A2_1_5_3__일기작성_감정선택_감동받은"),
            ("annoyed", Color.emotionAnnoyed, Image("IconAnnoyed"), "짜증나는", "A2_1_5_4__일기작성_감정선택_짜증나는"),
            ("sad", Color.emotionSad, Image("IconSad"), "슬픈", "A2_1_5_5__일기작성_감정선택_슬픈"),
            ("suffocated", Color.emotionSuffocated, Image("IconSuffocated"), "답답한", "A2_1_5_6__일기작성_감정선택_답답한"),
            ("lazy", Color.emotionLazy, Image("IconLazy"), "귀찮은", "A2_1_5_7__일기작성_감정선택_귀찮은"),
            ("grateful", Color.emotionGrateful, Image("IconGrateful"), "감사한", "A2_1_5_8__일기작성_감정선택_감사한"),
            ("joyful", Color.emotionJoyful, Image("IconJoyful"), "신나는", "A2_1_5_9__일기작성_감정선택_신나는"),
            ("exciting", Color.emotionExciting, Image("IconExciting"), "기대되는", "A2_1_5_10__일기작성_감정선택_기대되는"),
            ("nervous", Color.emotionNervous, Image("IconNervous"), "불안한","A2_1_5_11__일기작성_감정선택_불안한"),
            ("lonely", Color.emotionLonely, Image("IconLonely"), "외로운", "A2_1_5_12__일기작성_감정선택_외로운"),
            ("shy", Color.emotionShy, Image("IconShy"), "부끄러운", "A2_1_5_13__일기작성_감정선택_부끄러운"),
            ("frustrated", Color.emotionFrustrated, Image("IconFrustrated"), "당황한", "A2_1_5_14__일기작성_감정선택_당황한"),
            ("tough", Color.emotionTough, Image("IconTough"), "힘든", "A2_1_5_15__일기작성_감정선택_힘든"),
            ("peaceful", Color.emotionPeaceful, Image("IconPeaceful"), "평온한", "A2_1_5_16__일기작성_감정선택_평온한"),
            ("surprised", Color.emotionSurprised, Image("IconSurprised"), "놀란", "A2_1_5_17__일기작성_감정선택_놀란"),
            ("reassuring", Color.emotionReassuring, Image("IconReassuring"), "안심되는", "A2_1_5_18__일기작성_감정선택_안심되는")
        ]
        
        WithViewStore(store , observe: { $0 }) { viewStore in
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 32) {
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
                .padding(.bottom, 32)
            }
        }
    }
    
    @ViewBuilder
    //TODO: 이부분 소통해서 다시 진행할 것
    func generateEmotionCardView(emotion: (String, Color, Image, String, String)) -> some View {
        
        WithViewStore(store, observe: {$0}) { viewStore in
            HStack {
                Spacer()
                VStack(spacing: 24) {
                    emotion.2
                        .resizable()
                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 40)
                    Text(emotion.3)
                        .font(viewStore.selectedEmotion == emotion.0 ? .pretendard(.bold, size: 16) : .pretendard(.medium, size: 16))
                        .foregroundColor(viewStore.selectedEmotion == emotion.0 ? emotion.1 : Color.textPrimary)
                        .frame(width: 60)
                }
                Spacer()
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(viewStore.selectedEmotion == emotion.0 ? emotion.1 : Color.clear, lineWidth: viewStore.selectedEmotion == emotion.0 ? 2 : 0) // line width 조금 더 늘려보기
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewStore.selectedEmotion == emotion.0 ? Color.backgroundPrimary : Color.clear)
                    }
                    .aspectRatio(1, contentMode: .fill)
                    .shadow(color: viewStore.selectedEmotion == emotion.0 ? emotion.1.opacity(0.3) : Color(hexCode: "#191919").opacity(0), radius: 6) // 더 퍼지게

            }
            .opacity(((viewStore.selectedEmotion == nil || viewStore.selectedEmotion == emotion.0) ? 1 : 0.5))
            .padding(8)
        }
    }
}

struct DateView: View {
    var date = Date()
    @State var isPickerShown: Bool = false
    
    var body: some View {
        HStack {
            Text("\(date.month)월 \(date.day)일 (\(date.dayOfWeek))")
                .font(.pretendard(.semiBold, size: 18))
                .foregroundStyle(.textPrimary)
            Image(systemName: "chevron.down")
        }
        .onTapGesture {
            isPickerShown.toggle()
        }
        .sheet(isPresented: $isPickerShown, onDismiss: { print("picker dismissed") }) {
            MonthDayYearPickerView(yearRange: 1900...2023)
                .presentationDetents([.fraction(0.5)])
        }
    }
}

struct DismissButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
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
