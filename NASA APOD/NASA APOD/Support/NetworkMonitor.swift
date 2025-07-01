//
//  NetworkMonitor.swift
//  NASA APOD
//
//  Created by Adam Gerber on 01/07/2025.
//


import Network
import Combine

class NetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = true
    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue(label: "NetworkMonitor")

    init() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor?.start(queue: queue)
    }

    deinit {
        monitor?.cancel()
    }
}