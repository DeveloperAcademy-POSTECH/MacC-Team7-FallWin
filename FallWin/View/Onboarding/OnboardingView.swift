//
//  OnboardingView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/22/23.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
    let store: StoreOf<OnboardingFeature>
    @ObservedObject var viewStore: ViewStoreOf<OnboardingFeature>
    
    init(store: StoreOf<OnboardingFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    HStack {
                        Image("shareSheetBottomIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                        Text(String("PICDA"))
                            .font(.pretendard(.bold, size: 40))
                            .foregroundStyle(.textPrimary)
                    }
                    Spacer()
                    Image(systemName: "questionmark")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                    Spacer()
                    Text("onboarding_title")
                        .font(.pretendard(.semiBold, size: 18))
                        .foregroundStyle(.textSecondary)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button {
                        viewStore.send(.showNicknameInitView(true))
                    } label: {
                        ConfirmButtonLabelView(text: "onboarding_start".localized, backgroundColor: .button, foregroundColor: .textOnButton)
                    }
                }
                .padding()
            }
            .navigationDestination(store: store.scope(state: \.$nicknameInit, action: OnboardingFeature.Action.nicknameInit), destination: { store in
                NicknameInitView(store: store)
            })
        }
    }
}

//#Preview {
//    OnboardingView()
//}
