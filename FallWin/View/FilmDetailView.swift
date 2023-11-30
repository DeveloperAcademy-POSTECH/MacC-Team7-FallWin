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
    private let networkModel = NetworkModel()
    private let filmPublisher = NotificationCenter.default.publisher(for: .filmCountChanged)
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack {
                    VStack(spacing: 16) {
                        Text("film_detail_title")
                            .font(.pretendard(.bold, size: 36))
                            .foregroundStyle(.textPrimary)
                        Text("film_detail_message".localized.replacingOccurrences(of: "{initial_count}", with: "\(FilmManager.INITIAL_COUNT)"))
                            .font(.pretendard(.medium, size: 22))
                            .foregroundStyle(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Image(systemName: "film")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                        if networkModel.isConnected {
                            if let remainingCount = remainingCount {
                                Text("\(remainingCount)")
                                    .font(.pretendard(size: 36))
                            } else {
                                ProgressView()
                            }
                        } else {
                            Image(systemName: "network.slash")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .opacity(0.6)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background {
                        Capsule()
                            .fill(Color.backgroundCard)
                            .shadow(color: .shadow.opacity(0.14), radius: 8, y: 4)
                    }
                    
                    Spacer()
                }
                .frame(maxHeight: 360)
                
                Spacer()
                
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
                        Text("film_detail_ad")
                            .font(.pretendard(.medium, size: 16))
                            .foregroundStyle(.textOnButton)
                        Spacer()
                    }
                    .padding()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .alert(isPresented: $showAdFailAlert, title: "ad_fail_alert_title".localized) {
                    Text("ad_fail_alert_message")
                } primaryButton: {
                    OhwaAlertButton(label: Text("confirm").foregroundColor(.textOnButton), color: .button) {
                        showAdFailAlert = false
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
