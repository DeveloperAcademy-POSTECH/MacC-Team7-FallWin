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
                        MessageView(titleText: "오늘 하루를\n어떻게 표현하고 싶나요?", subTitleText: "화풍을 선택하면 그림을 그려줘요")
                        generateDrawingStyleView()
                        Button {
                            viewStore.send(.showGeneratedDiaryView)
                            
                        } label: {
                            Text("다음")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: UIScreen.main.bounds.width-24, height: 45)
                                .background(viewStore.selectedDrawingStyle == nil ? Color.buttonDisabled : Color.button)
                                .cornerRadius(9)
                                .foregroundColor(Color.white)
                        }
                        .disabled(viewStore.selectedDrawingStyle == nil)
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
            ("minimalism", Color.emotionHappy, Image("IconHappy")),
            ("sketch", Color.emotionNervous, Image("IconNervous")),
            ("comics", Color.emotionGrateful, Image("IconGrateful")),
            ("digital art", Color.emotionSad, Image("IconSad"))
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
//                            .stroke(viewStore.selectedDrawingStyle == drawingStyle.0 ? drawingStyle.1 : Color.black, lineWidth: viewStore.selectedDrawingStyle == drawingStyle.0 ? 2 : 1)
//                            .background(
//                                Circle().fill(Color.backgroundPrimary)
//                            )
                            .fill(Color.backgroundPrimary)
                    )
                    .shadow(color: Color(hexCode: "#191919").opacity(0.14), radius: viewStore.selectedDrawingStyle == drawingStyle.0 ? 24 : 8)
                Text(drawingStyle.0)
                    .font(.system(size: 18, weight: .medium))
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
