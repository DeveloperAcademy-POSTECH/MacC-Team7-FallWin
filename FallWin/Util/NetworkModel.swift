//
//  NetworkModel.swift
//  FallWin
//
//  Created by 최명근 on 11/23/23.
//

import Foundation
import Network

class NetworkModel: ObservableObject {
    private let monitor: NWPathMonitor
    @Published var isConnected: Bool = false
    
    init(_ connectionObserver: ((Bool) -> Void)? = nil) {
        monitor = NWPathMonitor()
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.isConnected = isConnected
            if let connectionObserver = connectionObserver {
                connectionObserver(isConnected)
            }
        }
    }
}
