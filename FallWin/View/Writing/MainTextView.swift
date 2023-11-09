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
//                    DateView()
//                        .padding(.top, 30)
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
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.backgroundPrimary)
                                .shadow(color: Color(hexCode: "#191919").opacity(0.14), radius: 8, y: 2)
                        }
                        .onAppear() {
                            isFocused = true
                        }
                        .padding(.top, 12)
                    Button {
                        viewStore.send(.showDrawingStyleView)
                    } label: {
                        ConfirmButtonLabelView(text: "다음", backgroundColor: viewStore.mainText == "" ? Color.buttonDisabled : Color.button, foregroundColor: .textOnButton)
                    }
                    .disabled(viewStore.mainText == "")
                    .padding([.top, .bottom], 15)
                }
                .padding([.leading, .trailing], 20)
                .padding(.bottom, 15)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    DateView()
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
            .navigationDestination(store: store.scope(state: \.$drawingStyle, action: MainTextFeature.Action.drawingStyle), destination: { store in
                DrawingStyleView(store: store)
            })
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
