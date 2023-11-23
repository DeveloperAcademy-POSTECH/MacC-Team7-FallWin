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
    @State var styleLabeling: Tracking.Event.RawValue = "nil"
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    MessageView(titleText: "drawing_style_title".localized, subTitleText: "drawing_style_subtitle".localized)
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
                    VStack(spacing: 12) {
                        Text("drawing_style_warning".localized)
                            .font(.pretendard(.regular, size: 14))
                            .foregroundColor(.textTertiary)
                        Button {
                            Tracking.logEvent(Tracking.Event.A2_3_3__일기작성_화풍선택_다음버튼.rawValue)
                            print("@Log : A2_3_3__일기작성_화풍선택_다음버튼")
                            Tracking.logEvent(styleLabeling)
                            if FilmManager.shared.drawingCount?.count ?? 0 <= 0 {
                                viewStore.send(.showCountAlert(true))
                            } else {
                                viewStore.send(.showGeneratedDiaryView)
                            }
                            
                        } label: {
                            //                            ConfirmButtonLabelView(text: "다음", backgroundColor: viewStore.selectedDrawingStyle == nil ? Color.buttonDisabled : Color.button, foregroundColor: .textOnButton)
                            HStack(spacing: 8) {
                                Spacer()
                                Image(systemName: "film")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 16)
                                Text("drawing_style_draw_button")
                                    .font(.pretendard(.semiBold, size: 18))
                                Spacer()
                            }
                            .foregroundColor(.textOnButton)
                            .frame(height: 54)
                            .background(viewStore.selectedDrawingStyle == nil ? Color.buttonDisabled : Color.button)
                            .cornerRadius(8)
                        }
                        .disabled(viewStore.selectedDrawingStyle == nil)
                    }
                    .padding(.top, 15)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    .background{
                        Color.backgroundPrimary
                            .ignoresSafeArea()
                            .shadow(color: Color(hexCode: "#191919").opacity(0.05), radius: 4, y: -2)
                    }
                    .alert(isPresented: viewStore.binding(get: \.showCountAlert, send: DrawingStyleFeature.Action.showCountAlert), title: "limit_alert_title".localized) {
                        Text("limit_alert_message".localized)
                    } primaryButton: {
                        OhwaAlertButton(label: Text("confirm").foregroundColor(.textOnButton), color: .button) {
                            viewStore.send(.showCountAlert(false))
                        }
                    }
                }
            }
            .safeToolbar {
                ToolbarItem(placement: .principal) {
                    DateView(pickedDateTagValue: viewStore.binding(get: \.pickedDateTagValue, send: DrawingStyleFeature.Action.pickDate))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Tracking.logEvent(Tracking.Event.A2_3_2__일기작성_화풍선택_닫기.rawValue)
                        print("@Log : A2_3_2__일기작성_화풍선택_닫기")
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
        .onAppear {
            Tracking.logScreenView(screenName: Tracking.Screen.V2_3__일기작성_화풍선택뷰.rawValue)
            print("@Log : V2_3__일기작성_화풍선택뷰")
        }
        
    }
    
    @ViewBuilder
    func generateDrawingStyleView() -> some View {
        
        let drawingStyles: [(String, Color, Image, String, Tracking.Event.RawValue)] = [
            ("Childlike crayon", Color(hexCode: "#191919"), Image("dsCrayon"), DrawingStyle.crayon.name() ?? "", Tracking.Event.A2_3_4_1__일기작성_화풍선택_크레용.rawValue),
            ("Oil Painting", Color(hexCode: "#191919"), Image("dsOilPainting"), DrawingStyle.oilPainting.name() ?? "", Tracking.Event.A2_3_4_2__일기작성_화풍선택_유화.rawValue),
            ("Water Color", Color(hexCode: "#191919"), Image("dsWaterColor"), DrawingStyle.waterColor.name() ?? "", Tracking.Event.A2_3_4_3__일기작성_화풍선택_수채화.rawValue),
            ("Sketch", Color(hexCode: "#191919"), Image("dsSketch"), DrawingStyle.sketch.name() ?? "", Tracking.Event.A2_3_4_4__일기작성_화풍선택_스케치.rawValue),
            ("Anime", Color(hexCode: "#191919"), Image("dsAnimation"), DrawingStyle.anime.name() ?? "",Tracking.Event.A2_3_4_5__일기작성_화풍선택_애니메이션.rawValue),
            ("Pixel Art", Color(hexCode: "#191919"), Image("dsPixelArt"), DrawingStyle.pixelArt.name() ?? "",Tracking.Event.A2_3_4_6__일기작성_화풍선택_픽셀아트.rawValue),
            ("Vincent Van Gogh", Color(hexCode: "#191919"), Image("dsVanGogh"), DrawingStyle.vanGogh.name() ?? "", Tracking.Event.A2_3_4_7__일기작성_화풍선택_반고흐.rawValue),
            ("Monet", Color(hexCode: "#191919"), Image("dsMonet"), DrawingStyle.monet.name() ?? "",Tracking.Event.A2_3_4_8__일기작성_화풍선택_모네.rawValue),
            ("Salvador Dali", Color(hexCode: "#191919"), Image("dsDali"), DrawingStyle.dali.name() ?? "",Tracking.Event.A2_3_4_9__일기작성_화풍선택_달리.rawValue)
        ]
        
        WithViewStore(store , observe: { $0 }) { viewStore in
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 12) {
                    ForEach(drawingStyles, id: \.0) { style in
                        generateDrawingStyleCardView(drawingStyle: style)
                            .onTapGesture(perform: {
                                if viewStore.selectedDrawingStyle == style.0 {
                                    viewStore.send(.selectDrawingStyle(nil))
                                } else {
                                    viewStore.send(.selectDrawingStyle(style.0))
                                    styleLabeling = style.4
                                    print("@Log_styleLabeling : \(styleLabeling)")
                                    
                                }
                            })
                            .padding(8)
                    }
                }
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    @ViewBuilder
    //TODO: 함께 해결해야 할 부분
    func generateDrawingStyleCardView(drawingStyle: (String, Color, Image, String, Tracking.Event.RawValue)) -> some View {
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
                    .font(viewStore.selectedDrawingStyle == drawingStyle.0 ? .pretendard(.bold, size: 16) : .pretendard(.medium, size: 16))
                    .foregroundStyle(.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .opacity(((viewStore.selectedDrawingStyle == nil || viewStore.selectedDrawingStyle == drawingStyle.0) ? 1 : 0.5))
        }
    }
}

#Preview {
    NavigationStack {
        DrawingStyleView(store: Store(initialState: DrawingStyleFeature.State(selectedEmotion: "행복한", mainText: "행복한 하루였다")) {
            DrawingStyleFeature()
        })
    }
}
