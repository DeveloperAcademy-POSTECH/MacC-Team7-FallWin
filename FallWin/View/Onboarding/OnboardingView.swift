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
                
                Image("onboarding")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                VStack(spacing: 0) {
                    Image("onboarding_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 160)
                        .padding(.top, 40)
                    Spacer()
                    Text("onboarding_title")
                        .font(.pretendard(.semiBold, size: 18))
                        .foregroundStyle(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 60)
                    Button {
                        viewStore.send(.showNicknameInitView)
                    } label: {
                        ConfirmButtonLabelView(text: "onboarding_start".localized, backgroundColor: .button, foregroundColor: .textOnButton)
                    }
                    .padding(.bottom)
                }
            }
            .safeToolbar {
                ToolbarItem(placement: .principal) {
                    Text("setting_section_notification")
                        .font(.pretendard(.bold, size: 18))
                        .foregroundStyle(Color.textPrimary)
                }
            }
            .navigationDestination(store: store.scope(state: \.$nicknameInit, action: OnboardingFeature.Action.nicknameInit), destination: { store in
                NicknameInitView(store: store)
            })
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

//#Preview {
//    OnboardingView()
//}
