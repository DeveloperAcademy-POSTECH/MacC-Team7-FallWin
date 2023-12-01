//
//  DebuggingView.swift
//  FallWin
//
//  Created by 최명근 on 11/23/23.
//

import SwiftUI
import AdSupport
import AppTrackingTransparency

struct DebuggingView: View {
    @State private var filmCount: Int = FilmManager.shared.drawingCount?.count ?? 0
    @State private var adId: String = ""
    @State private var unlimitedFilm: Bool = FilmManager.unlimited
    
    let filmPublisher = NotificationCenter.default.publisher(for: .filmCountChanged)
    
    var body: some View {
        List {
            Section(String("광고")) {
                Text(adId)
                    .textSelection(.enabled)
            }
            .onAppear {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .notDetermined:
                        print("not determined")
                    case .restricted:
                        print("restricted")
                    case .denied:
                        print("denied")
                    case .authorized:
                        print("authorized")
                        adId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    @unknown default:
                        print("none")
                    }
                }
                adId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
            
            Section(String("필름")) {
                Text(String("필름 수: \(filmCount)"))
                    .onReceive(filmPublisher) { _ in
                        filmCount = FilmManager.shared.drawingCount?.count ?? 0
                    }
                Toggle(String("필름 무제한"), isOn: $unlimitedFilm)
                    .onChange(of: unlimitedFilm, perform: { value in
                        FilmManager.unlimited = value
                    })
                Button(String("필름 초기화")) {
                    FilmManager.shared.resetCount()
                }
                Button(String("필름 1 추가")) {
                    FilmManager.shared.increaseCount()
                }
                Button(String("필름 1 감소")) {
                    FilmManager.shared.reduceCount()
                }
            }
            
            Section(String("알림")) {
                Button(String("알림 테스트")) {
                    NotificationManager().registerTestNotification { registered in
                        print("Alert \(registered)")
                    }
                }
                Button(String("대기 알림 삭제")) {
                    NotificationManager().removeAllPendingNotifications()
                }
            }
        }
    }
}

#Preview {
    DebuggingView()
}
