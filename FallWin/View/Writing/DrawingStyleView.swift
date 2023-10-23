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
                    VStack {
                        DateView()
                            .padding(.top, 30)
                        MessageView(titleText: "오늘 하루를\n어떻게 표현하고 싶나요?", subTitleText: "화풍을 선택하면 그림을 그려줘요")
                            .padding(.top, 24)
                        generateDrawingStyleView()
                            .padding(.top, 21)
                        Button {
                            viewStore.send(.showGeneratedDiaryView)
                        } label: {
                            Text("다음")
                                .font(.pretendard(.semiBold, size: 18))
                                .frame(width: UIScreen.main.bounds.width-40, height: 54)
                                .background(viewStore.selectedDrawingStyle == nil ? Color.buttonDisabled : Color.button)
                                .cornerRadius(9)
                                .foregroundColor(Color.white)
                        }
                        .disabled(viewStore.selectedDrawingStyle == nil)
                        .padding(.top, 15)
                    }
                    .padding()
                }
                .navigationTitle(Text("일기 쓰기"))
                .navigationDestination(store: store.scope(state: \.$generatedDiary, action: DrawingStyleFeature.Action.generatedDiary), destination: { store in
                    GeneratedDiaryView(store: store)
                })
        }
    }
    
    @ViewBuilder
    func generateDrawingStyleView() -> some View {
        
        let drawingStyles: [(String, Color, Image)] = [
            ("미니멀리즘", Color.emotionHappy, Image("IconHappy")),
            ("스케치", Color.emotionNervous, Image("IconNervous")),
            ("코믹스", Color.emotionGrateful, Image("IconGrateful")),
            ("디지털 아트", Color.emotionSad, Image("IconSad"))
        ]
        
        WithViewStore(store , observe: { $0 }) { viewStore in
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 36) {
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
                }
                .padding(4)
            }
//            VStack {
//                ForEach(0..<4) { idx in
//                    if idx % 2 == 0 {
//                        HStack {
//                            Spacer()
//                            generateDrawingStyleCardView(drawingStyle: drawingStyles[idx])
//                                .onTapGesture(perform: {
//                                    if viewStore.selectedDrawingStyle == drawingStyles[idx].0 {
//                                        viewStore.send(.selectDrawingStyle(nil))
//                                    } else {
//                                        viewStore.send(.selectDrawingStyle(drawingStyles[idx].0))
//                                    }
//                                })
//                                .border(.red)
//                            Spacer()
//                            generateDrawingStyleCardView(drawingStyle: drawingStyles[idx+1])
//                                .onTapGesture(perform: {
//                                    if viewStore.selectedDrawingStyle == drawingStyles[idx+1].0 {
//                                        viewStore.send(.selectDrawingStyle(nil))
//                                    } else {
//                                        viewStore.send(.selectDrawingStyle(drawingStyles[idx+1].0))
//                                    }
//                                })
//                                .border(.red)
//                            Spacer()
//                        }
//                    }
//                }
//            }
        }
    }
    
    @ViewBuilder
    func generateDrawingStyleCardView(drawingStyle: (String, Color, Image)) -> some View {
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
//                            .stroke(Color(hexCode: "#191919"), lineWidth: viewStore.selectedDrawingStyle == drawingStyle.0 ? 2 : 0)
//                            .background(
//                                Circle().fill(Color.backgroundPrimary)
//                            )
                            .fill(Color.backgroundPrimary)
                    )
                    .shadow(radius: viewStore.selectedDrawingStyle == drawingStyle.0 ?  6 : 4)
                Text(drawingStyle.0)
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
