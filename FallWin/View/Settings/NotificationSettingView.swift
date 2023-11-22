//
//  NotificationSettingView.swift
//  FallWin
//
//  Created by 최명근 on 11/22/23.
//

import SwiftUI
import ComposableArchitecture

struct NotificationSettingView: View {
    let store: StoreOf<NotificationSettingFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                Section {
                    Link(destination: URL(string: UIApplication.openNotificationSettingsURLString)!) {
                        VStack {
                            HStack {
                                Text("settings_notification_open_settings")
                                    .font(.pretendard(.medium, size: 18))
                                    .foregroundStyle(.textPrimary)
                                Spacer()
                            }
                            HStack {
                                Text("settings_notification_open_settings_sub")
                                    .font(.pretendard(.medium, size: 14))
                                    .foregroundStyle(.textTertiary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.backgroundPrimary)
                    
                    Toggle("settings_notification_enable", isOn: viewStore.binding(get: \.notification, send: NotificationSettingFeature.Action.setNotification))
                        .font(.pretendard(.medium, size: 18))
                        .foregroundStyle(.textPrimary)
                        .padding(.vertical, 8)
                        .listRowBackground(Color.backgroundPrimary)
                        
                    if viewStore.notification {
                        Button {
                            viewStore.send(.showTimePicker(true))
                        } label: {
                            HStack {
                                Text("settings_notification_time")
                                Spacer()
                                if let text = viewStore.timeString {
                                    Text(text)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .listRowBackground(Color.backgroundPrimary)
                        .sheet(isPresented: viewStore.binding(get: \.showTimePicker, send: NotificationSettingFeature.Action.showTimePicker)) {
                            if viewStore.notificationHour == nil || viewStore.notificationMinute == nil {
                                viewStore.send(.setNotificationTime(21, 0))
                            }
                        } content: {
                            TimePickerView(hour: 21, minute: 0) { hour, minute in
                                viewStore.send(.setNotificationTime(hour, minute))
                            }
                            .presentationDetents([.fraction(0.5)])
                        }
                    }
                }
            }
            .listStyle(.plain)
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("settings_notification")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        NotificationSettingView(store: Store(initialState: NotificationSettingFeature.State(), reducer: {
            NotificationSettingFeature()
        }))
    }
}
