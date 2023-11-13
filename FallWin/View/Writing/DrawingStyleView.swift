//
//  DrawingStyleView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/22/23.
//

import SwiftUI
import ComposableArchitecture
import FirebaseAnalytics

struct DrawingStyleView: View {
    var store: StoreOf<DrawingStyleFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
                ZStack {
                    Color.backgroundPrimary
                        .ignoresSafeArea()
                    VStack(spacing: 0) {
                        MessageView(titleText: "오늘 하루를\n어떻게 표현하고 싶나요?", subTitleText: "화풍을 선택하면 그림을 그려줘요")
                            .padding(.top, 24)
                        VStack {
                            Text("prior_num_inference_steps: \(viewStore.priorSteps)")
                                .font(.pretendard(.semiBold, size: 18))
                            Slider(value: viewStore.binding(get: \.priorSteps, send: DrawingStyleFeature.Action.setPriorSteps), in: 10...100 ,step: 1)
                            Spacer()
                            Text("prior_guidance_scale: \(viewStore.priorScale)")
                                .font(.pretendard(.semiBold, size: 18))
                            Slider(value: viewStore.binding(get: \.priorScale, send: DrawingStyleFeature.Action.setPriorScale), in: 1...20, step: 0.1)
                            Spacer()
                            Text("num_inference_steps: \(viewStore.steps)")
                                .font(.pretendard(.semiBold, size: 18))
                            Slider(value: viewStore.binding(get: \.steps, send: DrawingStyleFeature.Action.setSteps), in: 10...100, step: 1)
                            Spacer()
                            Text("guidance_scale: \(viewStore.scale)")
                                .font(.pretendard(.semiBold, size: 18))
                            Slider(value: viewStore.binding(get: \.scale, send: DrawingStyleFeature.Action.setScale), in: 1...20, step: 0.1)
                        }
                        generateDrawingStyleView()
                            .padding(.top, 16)
                            .padding(.horizontal)
                        //TODO: 함께 해결해야 할 부분
                        Button {
                            if DrawingCountManager.shared.remainingCount <= 0 {
                                viewStore.send(.showCountAlert(true))
                            } else {
                                viewStore.send(.showGeneratedDiaryView)
                            }
                            Tracking.logEvent(Tracking.Event.A2_3_3__일기작성_화풍선택_다음버튼.rawValue)
                            print("@Log : A2_3_3__일기작성_화풍선택_다음버튼")
                            
                        } label: {
                            ConfirmButtonLabelView(text: "다음", backgroundColor: viewStore.selectedDrawingStyle == nil ? Color.buttonDisabled : Color.button, foregroundColor: .textOnButton)
                        }
                        .disabled(viewStore.selectedDrawingStyle == nil)
                        .padding(.top, 15)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)
                        .background{
                            Color.backgroundPrimary
                                .ignoresSafeArea()
                                .shadow(color: Color(hexCode: "#191919").opacity(0.05), radius: 4, y: -2)
                        }
                        .alert(isPresented: viewStore.binding(get: \.showCountAlert, send: DrawingStyleFeature.Action.showCountAlert), title: "오늘의 제한 도달") {
                            Text("오늘 쓸 수 있는 필름을 다 썼어요. 내일 더 그릴 수 있도록 필름을 더 드릴게요!")
                        } primaryButton: {
                            OhwaAlertButton(label: Text("확인").foregroundColor(.textOnButton), color: .button) {
                                viewStore.send(.showCountAlert(false))
                            }
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
                            Tracking.logEvent(Tracking.Event.A2_3_2__일기작성_화풍선택_닫기.rawValue)
                            print("@Log : A2_3_2__일기작성_화풍선택_닫기")
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(store: store.scope(state: \.$generatedDiary, action: DrawingStyleFeature.Action.generatedDiary), destination: { store in
                    GeneratedDiaryView(store: store)
                })
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.visible, for: .navigationBar)
                .toolbar(.hidden, for: .tabBar)
        }
        .onAppear {
            Tracking.logScreenView(screenName: Tracking.Screen.V2_3__일기작성_화풍선택뷰.rawValue)
            print("@Log : V2_3__일기작성_화풍선택뷰")
               }
        
    }
    
    @ViewBuilder
    func generateDrawingStyleView() -> some View {
        //TODO: 함께 해결해야 할 부분
        let drawingStyles: [(String, Color, Image, String,String)] = [
            ("oilPainting", Color(hexCode: "#191919"), Image("ChildlikeCrayon"), "유화","A2_3_4_1__일기작성_화풍선택_유화"),
            ("sketch", Color(hexCode: "#191919"), Image("Sketch"), "스케치", "A2_3_4_2__일기작성_화풍선택_스케치"),
            ("renoir", Color(hexCode: "#191919"), Image("ChildrenIllustration"), "르누아르", "A2_3_4_3__일기작성_화풍선택_르누아르"),
            ("noDrawingStyle", Color(hexCode: "#191919"), Image("WaterColor"), "화풍 선택 안함", "A2_3_4_4__일기작성_화풍선택_화풍선택안함 "),
            ("chagall", Color(hexCode: "#191919"), Image("DigitalArt"), "샤갈", "A2_3_4_5__일기작성_화풍선택_샤갈"),
            ("anime", Color(hexCode: "#191919"), Image("Neon"), "애니메이션", "A2_3_4_6__일기작성_화풍선택_애니메이션"),
            ("vanGogh", Color(hexCode: "#191919"), Image("VanGogh"), "반 고흐", "A2_3_4_7__일기작성_화풍선택_반고흐"),
            ("kandinsky", Color(hexCode: "#191919"), Image("SalvadorDali"), "칸딘스키", "A2_3_4_8__일기작성_화풍선택_칸딘스키"),
            ("gauguin", Color(hexCode: "#191919"), Image("SalvadorDali"), "고갱", "A2_3_4_9__일기작성_화풍선택_고갱"),
            ("picasso", Color(hexCode: "#191919"), Image("SalvadorDali"), "피카소", "A2_3_4_10__일기작성_화풍선택_피카소"),
            ("rembrandt", Color(hexCode: "#191919"), Image("SalvadorDali"), "렘브란트", "A2_3_4_11__일기작성_화풍선택_렘브란트"),
            ("henriRousseau", Color(hexCode: "#191919"), Image("SalvadorDali"), "앙리 루소", "A2_3_4_12__일기작성_화풍선택_앙리루소"),
            ("henriMatisse", Color(hexCode: "#191919"), Image("SalvadorDali"), "앙리 마티스", "A2_3_4_13__일기작성_화풍선택_앙리마티스"),
            ("egonSchiele", Color(hexCode: "#191919"), Image("SalvadorDali"), "에곤 쉴레", "A2_3_4_14__일기작성_화풍선택_에곤쉴레"),
            ("webtoon", Color(hexCode: "#191919"), Image("SalvadorDali"), "웹툰", "A2_3_4_15__일기작성_화풍선택_웹툰"),
            ("dcComics", Color(hexCode: "#191919"), Image("SalvadorDali"), "DC 코믹스", "A2_3_4_16__일기작성_화풍선택_DC코믹스"),
            ("ghibli", Color(hexCode: "#191919"), Image("SalvadorDali"), "지브리", "A2_3_4_17__일기작성_화풍선택_지브리"),
            ("film", Color(hexCode: "#191919"), Image("SalvadorDali"), "필름", "A2_3_4_18__일기작성_화풍선택_필름"),
            ("illustration", Color(hexCode: "#191919"), Image("SalvadorDali"), "일러스트", "A2_3_4_19__일기작성_화풍선택_일러스트"),
            ("cg", Color(hexCode: "#191919"), Image("SalvadorDali"), "CG", "A2_3_4_20__일기작성_화풍선택_CG")
        ]
        
        WithViewStore(store , observe: { $0 }) { viewStore in
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 16) {
                    ForEach(drawingStyles, id: \.0) { style in
                        generateDrawingStyleCardView(drawingStyle: style)
                            .onTapGesture(perform: {
                                if viewStore.selectedDrawingStyle == style.0 {
                                    viewStore.send(.selectDrawingStyle(nil))
                                } else {
                                    viewStore.send(.selectDrawingStyle(style.0))
                                }
                            })
                            .padding(12)
                    }
                    .aspectRatio(1.0, contentMode: .fit)
                }
                .padding(4)
                .padding(.bottom, 32)
            }
        }
    }
    
    @ViewBuilder
    //TODO: 함께 해결해야 할 부분
    func generateDrawingStyleCardView(drawingStyle: (String, Color, Image, String, String)) -> some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            VStack(spacing: 16) {
                drawingStyle.2
                    .resizable()
                    .scaledToFit()
                    .clipShape(
                        Circle()
                    )
                    .background (
                        Circle()
                            .fill(Color.backgroundPrimary)
                            .shadow(color: viewStore.selectedDrawingStyle == drawingStyle.0 ? Color(hexCode: "#191919").opacity(0.2) : Color(hexCode: "#191919").opacity(0.1), radius: viewStore.selectedDrawingStyle == drawingStyle.0 ?  8 : 4)
                    )
                Text(drawingStyle.3)
                    .font(.pretendard(.medium, size: 18))
                    .foregroundStyle(.textPrimary)
            }
            .opacity(((viewStore.selectedDrawingStyle == nil || viewStore.selectedDrawingStyle == drawingStyle.0) ? 1 : 0.5))
        }
    }
}

#Preview {
    DrawingStyleView(store: Store(initialState: DrawingStyleFeature.State(selectedEmotion: "행복한", mainText: "행복한 하루였다")) {
        DrawingStyleFeature()
    })
}
