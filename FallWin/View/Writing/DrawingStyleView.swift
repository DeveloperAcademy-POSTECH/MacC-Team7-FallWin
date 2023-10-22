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
                        MessageView(titleText: "오늘은 어떤 감정을 느꼈나요?", subTitleText: "오늘 느낀 감정을 선택해보세요")
                        ScrollView() {
                            generateDrawingStyleView()
                                .padding()
                        }
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
        
        let cardWidth: CGFloat = UIScreen.main.bounds.width * 0.4
        
        WithViewStore(store , observe: { $0 }) { viewStore in
            VStack {
                ForEach(0..<4) { idx in
                    if idx % 2 == 0 {
                        HStack {
                            Spacer()
                            generateDrawingStyleCardView(drawingStyle: drawingStyles[idx])
                                .frame(width: cardWidth, height: cardWidth)
                                .onTapGesture(perform: {
                                    if viewStore.selectedDrawingStyle == drawingStyles[idx].0 {
                                        viewStore.send(.selectDrawingStyle(nil))
                                    } else {
                                        viewStore.send(.selectDrawingStyle(drawingStyles[idx].0))
                                    }
                                })
                            Spacer()
                            generateDrawingStyleCardView(drawingStyle: drawingStyles[idx+1])
                                .frame(width: cardWidth, height: cardWidth)
                                .onTapGesture(perform: {
                                    if viewStore.selectedDrawingStyle == drawingStyles[idx+1].0 {
                                        viewStore.send(.selectDrawingStyle(nil))
                                    } else {
                                        viewStore.send(.selectDrawingStyle(drawingStyles[idx+1].0))
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
    func generateDrawingStyleCardView(drawingStyle: (String, Color, Image)) -> some View {
        
        WithViewStore(store, observe: {$0}) { viewStore in
            GeometryReader { geo in
                VStack {
                    drawingStyle.2
                        .resizable()
                        .scaledToFit()
                        .clipShape(
                            Circle()
                        )
                        .background (
                            Circle()
                                .stroke(viewStore.selectedDrawingStyle == drawingStyle.0 ? drawingStyle.1 : Color.black, lineWidth: viewStore.selectedDrawingStyle == drawingStyle.0 ? 2 : 1)
                                .fill(Color.backgroundPrimary)
                        )
//                        .frame(width: geo.size.width, height: geo.size.height)
                        .shadow(radius: viewStore.selectedDrawingStyle == drawingStyle.0 ? 24 : 12)
                    Text(drawingStyle.0)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.textPrimary)
                }
                .opacity(((viewStore.selectedDrawingStyle == nil || viewStore.selectedDrawingStyle == drawingStyle.0) ? 1 : 0.5))
            }
        }
    }
}

#Preview {
    DrawingStyleView(store: Store(initialState: DrawingStyleFeature.State(selectedEmotion: "행복한", mainText: "행복한 하루였다")) {
        DrawingStyleFeature()
    })
}
