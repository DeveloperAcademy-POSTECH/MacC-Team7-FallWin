//
//  MainTextView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/18/23.
//

import SwiftUI
import ComposableArchitecture

struct MainTextView: View {
    var store: StoreOf<MainTextFeature>
    @FocusState var isFocused: Bool
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    DateView()
                        .padding(.top, 30)
                    MessageMainTextView()
                        .padding(.top, 36)
                    TextEditor(text: viewStore.binding(get: \.mainText, send: { .inputMainText($0)}))
                        .font(.pretendard(.medium, size: 18))
                        .foregroundColor(.textPrimary)
                        .scrollContentBackground(.hidden)
                        .focused($isFocused)
                        .padding([.top, .bottom], 9)
                        .padding([.leading, .trailing], 12)
                        .background() {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.backgroundPrimary)
                                .shadow(color: Color(hexCode: "#191919").opacity(0.14), radius: 8, y: 2)
                                .overlay {
                                    VStack {
                                        Spacer()
                                        HStack{
                                            Spacer()
                                            HStack(spacing: 0) {
                                                Text("\(viewStore.mainText.count)")
                                                    .font(.system(size: 12))
                                                    .offset(y: -4)
                                                    .foregroundStyle(.gray)
                                                
                                                Text(" / 1000")
                                                    .font(.system(size: 12))
                                                    .offset(y: -4)
                                                    .padding(.trailing, 8)
                                            }
                                            
                                        }
                                        
                                    }
                                }
                        }
                        .padding(.top, 12)
                    Button {
//                        viewStore.send(.inputMainText(mainText))
                        viewStore.send(.showDrawingStyleView)
                    } label: {
                        Text("다음")
                            .font(.pretendard(.semiBold, size: 18))
                            .frame(width: UIScreen.main.bounds.width-40, height: 54)
                            .background(viewStore.mainText == "" ? Color.buttonDisabled : Color.button)
                            .cornerRadius(9)
                            .foregroundColor(Color.white)
                    }
                    .disabled(viewStore.mainText == "")
                    .padding([.top, .bottom], 15)
                }
                .padding([.leading, .trailing], 20)
                .padding(.bottom, 15)
            }
            .navigationTitle(Text("일기 쓰기"))
            .navigationDestination(store: store.scope(state: \.$drawingStyle, action: MainTextFeature.Action.drawingStyle), destination: { store in
                DrawingStyleView(store: store)
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

struct MessageMainTextView: View {
    var body: some View {
        Text("오늘 하루는 어땠나요?")
            .font(.pretendard(.bold, size: 24))
            .foregroundStyle(.textPrimary)
            .padding(.bottom, 15)
    }
}

#Preview {
    MainTextView(store: Store(initialState: MainTextFeature.State(selectedEmotion: "", mainText: "헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤헤", isKeyboardShown: true), reducer: {
        MainTextFeature()
    }))
}
