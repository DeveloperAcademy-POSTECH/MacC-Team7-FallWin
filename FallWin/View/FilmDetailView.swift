//
//  AdView.swift
//  FallWin
//
//  Created by 최명근 on 11/25/23.
//

import SwiftUI
import AppTrackingTransparency

struct FilmDetailView: View {
    @State private var remainingCount: Int? = FilmManager.shared.drawingCount?.count
    @State private var showAdFailAlert: Bool = false
    
    private let adManager = RewardAdsManager()
    private let filmPublisher = NotificationCenter.default.publisher(for: .filmCountChanged)
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack {
                    VStack(spacing: 16) {
                        Image(systemName: "film.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(12)
                            .foregroundStyle(.symbol)
                            .background(
                                Circle()
                                    .fill(.symbolDisabled)
                            )
                            .frame(width: 56, height: 56)
                        Text("film_detail_title")
                            .font(.pretendard(.bold, size: 24))
                            .foregroundStyle(.textPrimary)
                        Text("film_detail_message".localized)
                            .font(.pretendard(.medium, size: 18))
                            .foregroundStyle(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxHeight: 360)
                
                Spacer()
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("film_detail_cancel")
                            .font(.pretendard(.medium, size: 18))
                            .foregroundStyle(.button)
                    }
                    .frame(minWidth: 100)
                    
                    Button {
                        ATTrackingManager.requestTrackingAuthorization { _ in
                            Task {
                                let reward = await adManager.displayReward()
                                if reward {
                                    FilmManager.shared.increaseCount()
                                    dismiss()
                                } else {
                                    showAdFailAlert = true
                                }
                            }
                        }
                        
                    } label: {
                        HStack(spacing: 16) {
                            Spacer()
                            Text(String("AD"))
                                .font(.pretendard(.medium, size: 12))
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.textOnButton, lineWidth: 2)
                                }
                            Text("film_detail_confirm")
                                .font(.pretendard(.medium, size: 16))
                                .foregroundStyle(.textOnButton)
                            Spacer()
                        }
                        .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 8))
                    .alert(isPresented: $showAdFailAlert, title: "ad_fail_alert_title".localized) {
                        Text("ad_fail_alert_message")
                    } primaryButton: {
                        OhwaAlertButton(label: Text("confirm").foregroundColor(.textOnButton), color: .button) {
                            showAdFailAlert = false
                        }
                    }
                }
            }
            .padding()
        }
        .onReceive(filmPublisher) { _ in
            remainingCount = FilmManager.shared.drawingCount?.count ?? 0
        }
    }
}

#Preview {
    FilmDetailView()
}
