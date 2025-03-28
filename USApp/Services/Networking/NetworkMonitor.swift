//
//  NetworkMonitor.swift
//  USApp
//
//  Created by Johann FOURNIER on 13/01/2025.
//

import Network
import Combine

protocol NetworkMonitorProtocol {
    var isConnected: Bool { get }
    
    var connectionStatusPublisher: AnyPublisher<Bool, Never> { get }
}

final class NetworkMonitor: NetworkMonitorProtocol {
    static let shared = NetworkMonitor()
    
    private(set) var isConnected: Bool = false
    
    private let connectionStatusSubject = CurrentValueSubject<Bool, Never>(false)
    
    var connectionStatusPublisher: AnyPublisher<Bool, Never> {
        connectionStatusSubject.eraseToAnyPublisher()
    }
    
    private let monitor = NWPathMonitor()
    
    private let queue = DispatchQueue.global(qos: .background)
    
    private init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let newStatus = path.status == .satisfied
            
            if self.isConnected != newStatus {
                self.isConnected = newStatus
                
                DispatchQueue.main.async {
                    self.connectionStatusSubject.send(newStatus)
                }
                
                print("📶 Statut de connexion: \(newStatus ? "Connecté" : "Déconnecté")")
            }
        }
        
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
