//
//  TextEditView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/21/23.
//

import SwiftUI
import ComposableArchitecture
import FirebaseAnalytics

struct TextEditView: View {
    let store: StoreOf<TextEditFeature>
    @ObservedObject var viewStore: ViewStoreOf<TextEditFeature>
    
    init(store: StoreOf<TextEditFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            VStack(spacing: 0) {
                MessageMainTextView()
                    .padding(.top, 24)
                TextEditor(text: viewStore.binding(get: \.tempText, send: { .updateTempText($0)}))
                    .font(.pretendard(.medium, size: 18))
                    .foregroundColor(.textPrimary)
                    .scrollContentBackground(.hidden)
                    .padding([.top, .bottom], 9)
                    .padding(.bottom, 15)
                    .padding([.leading, .trailing], 12)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.backgroundPrimary)
                            .shadow(color: Color(hexCode: "#191919").opacity(0.14), radius: 8, y: 2)
                            .overlay {
                                VStack {
                                    if viewStore.tempText.isEmpty {
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
                                            if viewStore.tempText.count > 1000 {
                                                Text("\(viewStore.tempText.count)")
                                                    .foregroundStyle(.red)
                                            }else {
                                                Text("\(viewStore.tempText.count)")
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
//                    Tracking.logEvent(Tracking.Event.A2_2_3__일기작성_글작성_다음버튼.rawValue)
//                    print("@Log : A2_2_3__일기작성_글작성_다음버튼")
                    viewStore.send(.saveText)
                } label: {
                    ConfirmButtonLabelView(
                        text: "수정 완료",
                        backgroundColor: ((viewStore.tempText == viewStore.journal.content) || (viewStore.tempText == "") || (viewStore.tempText.count > 1000)) ? Color.buttonDisabled : Color.button,
                        foregroundColor: .textOnButton
                    )
                }
                .disabled((viewStore.tempText == viewStore.journal.content) || (viewStore.tempText == "") || (viewStore.tempText.count > 1000))
                //                    .disabled(viewStore.mainText.count > 60)
                .padding(.top, 15)
                .padding(.bottom, 16)
            }
            .background(.white.opacity(0.001))
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 15)
        }
        .safeToolbar {
            ToolbarItem(placement: .principal) {
                Text("수정하기")
                    .font(.pretendard(.bold, size: 18))
                    .foregroundStyle(.textPrimary)
            }
//            ToolbarItem(placement: .topBarTrailing) {
//                Button {
//                    viewStore.send(.showCancelAlert(true))
//                } label: {
//                    Image(systemName: "xmark")
//                }
//                .alert(isPresented: viewStore.binding(get: \.showCancelAlert, send: TextEditFeature.Action.showCancelAlert), title: "수정을 그만둘까요?") {
//                    Text("수정 사항이 반영되지 않아요.")
//                } primaryButton: {
//                    OhwaAlertButton(label: Text("취소"), color: .clear) {
//                        viewStore.send(.showCancelAlert(false))
//                    }
//                } secondaryButton: {
//                    OhwaAlertButton(label: Text("그만두기").foregroundColor(.textOnButton), color: .button) {
////                        Tracking.logEvent(Tracking.Event.A3_3__상세페이지_일기삭제.rawValue)
////                        print("@Log : A3_3__상세페이지_일기삭제")
////                        viewStore.send(.hideCancelAlertAndCancelEditing)
//                        viewStore.send(.showCancelAlert(false))
//                        viewStore.send(.cancelEditing)
//                    }
//                }
//            }
//            ToolbarItem(placement: .cancellationAction) {
//                Button {
//                    viewStore.send(.showCancelAlert(true))
//                } label: {
//                    Image(systemName: "chevron.left")
//                }
//            }
        }
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(true)
        
        //
        .onAppear {
//            Tracking.logScreenView(screenName: Tracking.Screen.V2_2__일기작성_글작성뷰.rawValue)
//            print("@Log : V2_2__일기작성_글작성뷰")
        }
    }
    
    //    var toolbarText: some View {
    //        Text("수정하기")
    //            .font(.pretendard(.bold, size: 18))
    //            .multilineTextAlignment(.leading)
    //            .foregroundStyle(.textPrimary)
    //    }
}
//
//#Preview {
//    TextEditView()
//}
