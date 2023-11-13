//
//  DrawingStyleView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/22/23.
//

import SwiftUI
import ComposableArchitecture

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
//                        VStack {
//                            Text("prior_num_inference_steps: \(viewStore.priorSteps)")
//                                .font(.pretendard(.semiBold, size: 18))
//                            Slider(value: viewStore.binding(get: \.priorSteps, send: DrawingStyleFeature.Action.setPriorSteps), in: 10...100 ,step: 1)
//                            Spacer()
//                            Text("prior_guidance_scale: \(viewStore.priorScale)")
//                                .font(.pretendard(.semiBold, size: 18))
//                            Slider(value: viewStore.binding(get: \.priorScale, send: DrawingStyleFeature.Action.setPriorScale), in: 1...20, step: 0.1)
//                            Spacer()
//                            Text("num_inference_steps: \(viewStore.steps)")
//                                .font(.pretendard(.semiBold, size: 18))
//                            Slider(value: viewStore.binding(get: \.steps, send: DrawingStyleFeature.Action.setSteps), in: 10...100, step: 1)
//                            Spacer()
//                            Text("guidance_scale: \(viewStore.scale)")
//                                .font(.pretendard(.semiBold, size: 18))
//                            Slider(value: viewStore.binding(get: \.scale, send: DrawingStyleFeature.Action.setScale), in: 1...20, step: 0.1)
//                        }
                        generateDrawingStyleView()
                            .padding(.top, 16)
                            .padding(.horizontal)
                        Button {
                            if DrawingCountManager.shared.remainingCount <= 0 {
                                viewStore.send(.showCountAlert(true))
                            } else {
                                viewStore.send(.showGeneratedDiaryView)
                            }
                            
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
                        DateView(pickedDateTagValue: viewStore.binding(get: \.pickedDateTagValue, send: DrawingStyleFeature.Action.pickDate))
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewStore.send(.cancelWriting)
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
    }
    
    @ViewBuilder
    func generateDrawingStyleView() -> some View {
        
        let drawingStyles: [(String, Color, Image, String)] = [
            ("Childlike crayon", Color(hexCode: "#191919"), Image("WaterColor"), "크레용"),
            ("Oil Painting", Color(hexCode: "#191919"), Image("Sketch"), "유화"),
            ("Water Color", Color(hexCode: "#191919"), Image("ChildrenIllustration"), "수채화"),
            ("Sketch", Color(hexCode: "#191919"), Image("ChildlikeCrayon"), "스케치"),
            ("Anime", Color(hexCode: "#191919"), Image("Neon"), "애니메이션"),
            ("Pixel Art", Color(hexCode: "#191919"), Image("VanGogh"), "픽셀아트"),
            ("Vincent Van Gogh", Color(hexCode: "#191919"), Image("SalvadorDali"), "빈센트 반 고흐"),
            ("Monet", Color(hexCode: "#191919"), Image("SalvadorDali"), "클로드 모네"),
            ("Salvador Dali", Color(hexCode: "#191919"), Image("SalvadorDali"), "살바도르 달리")
        ]
        
        WithViewStore(store , observe: { $0 }) { viewStore in
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 16) {
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
    func generateDrawingStyleCardView(drawingStyle: (String, Color, Image, String)) -> some View {
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
                    .multilineTextAlignment(.center)
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
