//
//  ViewModel.swift
//  NASA APOD
//
//  Created by Adam Gerber on 01/07/2025.
//

import Foundation
import Network

@MainActor
class ViewModel: ObservableObject {
    enum FetchStatus {
        case notStarted
        case fetching
        case successAPOD
        case failed(error: Error)
    }
    
    @Published private(set) var status: FetchStatus = .notStarted
    
    private let fetcher = FetchService()
    
    @Published var apod: APOD
    
    private let monitor = NWPathMonitor()
    private var isConnected: Bool = true
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Always initialize apod first
        let apodData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleapod", withExtension: "json")!)
        apod = try! decoder.decode(APOD.self, from: apodData)
        
        // Monitor network status
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: DispatchQueue(label: "ViewModelNetworkMonitor"))
        
        // Try to load from cache if no network
        if !isConnected, let cached = APODCacheManager.loadAPOD() {
            apod = cached
        }
    }
    
    func getApodDateData(for date: String) async {
        status = .fetching
        
        do {
            apod = try await fetcher.fetchAPOD(date)
            await APODCacheManager.save(apod: apod)
            status = .successAPOD
        } catch {
            // On error, try to load from cache
            if let cached = APODCacheManager.loadAPOD() {
                apod = cached
                status = .successAPOD
            } else {
                status = .failed(error: error)
            }
        }
    }
}
