//
//  DebuggingView.swift
//  FallWin
//
//  Created by 최명근 on 11/23/23.
//

import SwiftUI

struct DebuggingView: View {
    @State private var filmCount: Int = FilmManager.shared.drawingCount?.count ?? 0
    
    let filmPublisher = NotificationCenter.default.publisher(for: .filmCountChanged)
    
    var body: some View {
        List {
            Text(String("필름 수: \(filmCount)"))
                .onReceive(filmPublisher) { _ in
                    filmCount = FilmManager.shared.drawingCount?.count ?? 0
                }
            Button(String("필름 초기화")) {
                FilmManager.shared.resetCount()
            }
            Button(String("필름 1 추가")) {
                FilmManager.shared.increaseCount()
            }
            Button(String("필름 1 감소")) {
                FilmManager.shared.reduceCount()
            }
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

#Preview {
    DebuggingView()
}
