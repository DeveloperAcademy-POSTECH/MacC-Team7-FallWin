//
//  NotificationInitView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/28/23.
//

import SwiftUI
import ComposableArchitecture

struct NotificationInitView: View {
    let store: StoreOf<NotificationInitFeature>
    @ObservedObject var viewStore: ViewStoreOf<NotificationInitFeature>
    
    init(store: StoreOf<NotificationInitFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            Image("Background")
                .resizable()
                .scaledToFit()
            VStack {
                Spacer()
                Image(systemName: "bell.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1)
                Spacer()
                Text("알림 설정을 허용해주세요")
                    .font(.pretendard(.bold, size: 24))
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                Text("하루를 잊지 않고 기억할 수 있게 도와드릴게요!")
                    .font(.pretendard(.medium, size: 18))
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                Spacer()
                Image("Alert")
                    .resizable()
                    .scaledToFit()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                HStack {
                    Spacer()
                    Button {
                    } label: {
                        ConfirmButtonLabelView(text: "skip".localized, backgroundColor: .backgroundPrimary, foregroundColor: .textSecondary, width: nil)
                    }
                    Spacer()
                    Button {
                    } label: {
                        ConfirmButtonLabelView(text: "setting_section_notification".localized, backgroundColor: .button, foregroundColor: .textOnButton, width: UIScreen.main.bounds.width * 0.6)
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        NotificationInitView(store: Store(initialState: NotificationInitFeature.State()) {
            NotificationInitFeature()
        })
    }
}
