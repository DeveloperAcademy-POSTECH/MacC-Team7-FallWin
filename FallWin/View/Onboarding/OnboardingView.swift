//
//  OnboardingView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/22/23.
//

import SwiftUI
import ComposableArchitecture
import AppTrackingTransparency

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
                    .offset(y: -45)
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
                        .padding(.bottom, 40)
                    
                    VStack(spacing: 4) {
                        HStack {
                            NavigationLink {
                                WebView(url: "policy_service_url".localized)
                            } label: {
                                Text("policy_service")
                                    .font(.pretendard(.medium, size: 12))
                                    .foregroundStyle(.textTertiary)
                                    .underline()
                            }
                            NavigationLink {
                                WebView(url: "policy_privacy_url".localized)
                            } label: {
                                Text("policy_privacy")
                                    .font(.pretendard(.medium, size: 12))
                                    .foregroundStyle(.textTertiary)
                                    .underline()
                            }
                        }
                        Text("onboarding_policy")
                            .font(.pretendard(.medium, size: 12))
                            .foregroundStyle(.textTertiary)
                            .padding(.bottom, 12)
                        Button {
                            viewStore.send(.showPolicyAlert(true))
                        } label: {
                            ConfirmButtonLabelView(text: "onboarding_start".localized, backgroundColor: .button, foregroundColor: .textOnButton)
                        }
                    }
                    .padding(.bottom)
                    .alert(isPresented: viewStore.binding(get: \.showPolicyAlert, send: OnboardingFeature.Action.showPolicyAlert), title: "onboarding_marketing_alert_title".localized) {
                        Text("onboarding_marketing_alert_message")
                    } primaryButton: {
                        OhwaAlertButton(label: Text("onboarding_marketing_alert_policy").foregroundColor(.textPrimary), color: .backgroundPrimary) {
                            viewStore.send(.showPolicyAlert(false))
                            viewStore.send(.showMarketingPolicyView(true))
                        }
                    } secondaryButton: {
                        OhwaAlertButton(label: Text("confirm").foregroundColor(.textOnButton), color: .button) {
                            viewStore.send(.showPolicyAlert(false))
                            ATTrackingManager.requestTrackingAuthorization { _ in
                            }
                            viewStore.send(.showNicknameInitView)
                        }
                    }
                    .navigationDestination(isPresented: viewStore.binding(get: \.showMarketingPolicyView, send: OnboardingFeature.Action.showMarketingPolicyView)) {
                        WebView(url: "policy_privacy_optional_url".localized)
                    }
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

#Preview {
    OnboardingView(store: Store(initialState: OnboardingFeature.State(), reducer: {
        OnboardingFeature()
    }))
}
