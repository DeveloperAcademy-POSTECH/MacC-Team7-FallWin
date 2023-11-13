//
//  MainTextView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/18/23.
//

import SwiftUI
import ComposableArchitecture
import FirebaseAnalytics

struct MainTextView: View {
    var store: StoreOf<MainTextFeature>
    @FocusState var isFocused: Bool
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    MessageMainTextView()
                        .padding(.top, 24)
                    TextEditor(text: viewStore.binding(get: \.mainText, send: { .inputMainText($0)}))
                        .font(.pretendard(.medium, size: 18))
                        .foregroundColor(.textPrimary)
                        .scrollContentBackground(.hidden)
                        .focused($isFocused)
                        .padding([.top, .bottom], 9)
                        .padding(.bottom, 15)
                        .padding([.leading, .trailing], 12)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.backgroundPrimary)
                                .shadow(color: Color(hexCode: "#191919").opacity(0.14), radius: 8, y: 2)
                                .overlay {
                                    VStack {
                                        if viewStore.mainText.isEmpty {
                                            HStack {
                                                Text("그림으로 담고 싶은 이야기를 작성해보세요.")
                                                    .font(.pretendard(.regular, size: 18))
                                                    .multilineTextAlignment(.leading)
                                                    .foregroundStyle(.textTertiary)
                                                Spacer()
                                            }
                                            .padding(.top, 17)
                                            .padding(.horizontal, 16)
                                        }
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Spacer()
                                            Group {
                                                if viewStore.mainText.count > 1000 {
                                                    Text("\(viewStore.mainText.count)")
                                                        .foregroundStyle(.red)
                                                }else {
                                                    Text("\(viewStore.mainText.count)")
                                                        .foregroundStyle(.textSecondary)
                                                }
                                            }
                                            .font(.pretendard(.medium, size: 14))
                                            
                                            Text(" / \(1000)")
                                                .font(.pretendard(.regular, size: 14))
                                                .foregroundStyle(.textTertiary)
                                                .padding(.trailing, 8)
                                        }
                                        .padding(.bottom, 12)
                                        .padding(.trailing, 8)
                                    }
                                }
                        }
                        .padding(.top, 12)
                    Button {
                        Tracking.logEvent(Tracking.Event.A2_2_3__일기작성_글작성_다음버튼.rawValue)
                        print("@Log : A2_2_3__일기작성_글작성_다음버튼")
                        viewStore.send(.showDrawingStyleView)
                    } label: {
                        ConfirmButtonLabelView(
                            text: "다음",
                            backgroundColor: (viewStore.mainText == "" || viewStore.mainText.count > 1000) ? Color.buttonDisabled : Color.button,
                            foregroundColor: .textOnButton
                        )
                    }
                    .disabled(viewStore.mainText == "" || viewStore.mainText.count > 1000)
                    //                    .disabled(viewStore.mainText.count > 60)
                    .padding(.top, 15)
                    .padding(.bottom, 16)
                }
                .padding([.leading, .trailing], 20)
                .padding(.bottom, 15)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    DateView(pickedDateTagValue: viewStore.binding(get: \.pickedDateTagValue, send: MainTextFeature.Action.pickDate))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Tracking.logEvent(Tracking.Event.A2_2_2__일기작성_글작성_닫기.rawValue)
                        print("A2_2_2__일기작성_글작성_닫기")
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
        }
        .onAppear {
            Tracking.logScreenView(screenName: Tracking.Screen.V2_2__일기작성_글작성뷰.rawValue)
            print("@Log : V2_2__일기작성_글작성뷰")
        }
        
    }
}

struct MessageMainTextView: View {
    var body: some View {
        Text("어떤 하루였나요?")
            .font(.pretendard(.bold, size: 24))
            .foregroundStyle(.textPrimary)
            .padding(.bottom, 24)
    }
}

#Preview {
    NavigationStack {
        MainTextView(store: Store(initialState: MainTextFeature.State(selectedEmotion: "", mainText: "", isKeyboardShown: true), reducer: {
            MainTextFeature()
        }))
    }
}
