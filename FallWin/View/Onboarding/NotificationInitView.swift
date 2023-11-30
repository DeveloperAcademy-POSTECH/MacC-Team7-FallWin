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
                Image(systemName: "bell.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1)
                    .padding(.top, 38)
                Text("onboarding_notifiacation_title")
                    .font(.pretendard(.bold, size: 24))
                    .foregroundStyle(Color.textPrimary)
                    .padding(.top, 28)
                Text("onboarding_notification_subtitle")
                    .font(.pretendard(.medium, size: 18))
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
                Image("Alert")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 47)
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        viewStore.send(.doneInitSetting(true))
                    } label: {
                        ConfirmButtonLabelView(text: "skip".localized, backgroundColor: .backgroundPrimary, foregroundColor: .textSecondary, width: nil)
                    }
                    Spacer()
                    Button {
                        Task {
                            do {
                                let notificationCenter = UNUserNotificationCenter.current()
                                let granted = try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
                                if granted {
                                    viewStore.send(.showPicker(true))
                                } else {
                                    viewStore.send(.showAlert(true))
                                }
                            } catch {
                                print("<notification permission>: \(error)")
                            }
                        }
                    } label: {
                        ConfirmButtonLabelView(text: "setting_section_notification".localized, backgroundColor: .button, foregroundColor: .textOnButton, width: UIScreen.main.bounds.width * 0.6)
                    }
                    .sheet(isPresented: viewStore.binding(get: \.isPickerShown, send: NotificationInitFeature.Action.showPicker), onDismiss: {
                        viewStore.send(.addNotificationRequest(viewStore.hour, viewStore.minute))
                    }, content: {
                        TimePickerView(hour: 21, minute: 0) { hour, minute in
                            viewStore.send(.setHour(hour))
                            viewStore.send(.setMinute(minute))
                        }
                        .presentationDetents([.fraction(0.5)])
                    })
                    .alert(isPresented: viewStore.binding(get: \.isAlertShown, send: NotificationInitFeature.Action.showAlert), title: "알림 설정") {
                        Text("onboarding_notification_permission_alert")
                            .font(.pretendard(.regular, size: 18))
                            .foregroundStyle(Color.textSecondary)
                    } primaryButton: {
                        OhwaAlertButton(label: Text("확인").foregroundColor(.textOnButton), color: .button) {
                            viewStore.send(.showAlert(false))
                        }
                    }
                    Spacer()
                }
                .padding(.bottom)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NotificationInitView(store: Store(initialState: NotificationInitFeature.State()) {
            NotificationInitFeature()
        })
    }
}
