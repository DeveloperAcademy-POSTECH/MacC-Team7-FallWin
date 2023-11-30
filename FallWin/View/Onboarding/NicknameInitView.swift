//
//  OnboadingNicknameView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/22/23.
//

import SwiftUI
import ComposableArchitecture

struct NicknameInitView: View {
    let store: StoreOf<NicknameInitFeature>
    @ObservedObject var viewStore: ViewStoreOf<NicknameInitFeature>
    @FocusState var isFocused: Bool
    
    init(store: StoreOf<NicknameInitFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            VStack {
                ProgressView(value: 1, total: 3)
                    .progressViewStyle(ColoredProgressBar(backgroundColor: .buttonDisabled, fillColor: .tabbarEnabled))
                Text("onboarding_nickname_title")
                    .font(.pretendard(.bold, size: 24))
                    .foregroundStyle(Color.textPrimary)
                    .padding(.top, 56)
                ZStack {
                    TextField(text: viewStore.binding(get: \.nickname, send: NicknameInitFeature.Action.setNickname)) {
                        Text("nickname")
                            .font(.pretendard(.regular, size: 18))
                            .foregroundStyle(Color.textTertiary)
                    }
                    .focused($isFocused)
                    HStack {
                        Spacer()
                        Button {
                            viewStore.send(.clearNickname)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.textTertiary)
                                .frame(height: 18)
                        }
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.backgroundPrimary)
                        .shadow(color: Color.shadow.opacity(0.14), radius: 4, y: 2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 32)
                HStack {
                    Spacer()
                    Text(String("\(viewStore.nickname.count) / 10"))
                        .font(.pretendard(.regular, size: 14))
                        .foregroundStyle(viewStore.nickname.count > 10 ? Color.red : Color.textTertiary)
                }
                .padding(.horizontal, 20)
                Spacer()
                Button {
                    print(viewStore.nickname)
                    viewStore.send(.showNotificationInitView)
                } label: {
                    ConfirmButtonLabelView(text: "next".localized, backgroundColor: (viewStore.nickname == "") || (viewStore.nickname.count > 10) ? .buttonDisabled : .button, foregroundColor: .textOnButton)
                }
                .disabled((viewStore.nickname == "") || (viewStore.nickname.count > 10))
                .padding(.bottom)
                .padding(.horizontal, 20)
            }
            .onTapGesture {
                if isFocused {
                    isFocused.toggle()
                }
            }
        }
        .onAppear {
            isFocused = true
        }
        .safeToolbar {
            ToolbarItem(placement: .principal) {
                Text("onboarding_nickname_set")
                    .font(.pretendard(.bold, size: 18))
                    .foregroundStyle(Color.textPrimary)
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(store: store.scope(state: \.$notificationInit, action: NicknameInitFeature.Action.notificationInit), destination: { store in
            NotificationInitView(store: store)
        })
    }
}
//
//#Preview {
//    NicknameInitView(store: Store(initialState: , reducer: <#T##() -> Reducer#>))
//}
