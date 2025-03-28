//
//  APIServiceManager.swift
//  USApp
//
//  Created by Johann FOURNIER on 21/12/2024.
//

import Foundation

final class APIServiceManager: NetworkServiceProtocol {
    static let shared = APIServiceManager()
    
    private let googleAPI: SheetAPIProtocol
        
    private let notificationService: NotificationServiceProtocol
    
    private let networkMonitor: NetworkMonitorProtocol
    
    private var timer: Timer?
    
    init(
        googleAPI: SheetAPIProtocol = GoogleSheetAPI(),
        notificationService: NotificationServiceProtocol = NotificationService.shared,
        networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared
    ) {
        self.googleAPI = googleAPI
        self.notificationService = notificationService
        self.networkMonitor = networkMonitor
    }

    func fetchSheetData(tabId: String, useCache: Bool = true) async throws -> [[String]] {
        if !useCache && !networkMonitor.isConnected {
            throw NetworkError.noConnection
        }
        
        let data = try await googleAPI.fetchAllRows(tabName: tabId, useCache: useCache)
        
        notificationService.scheduleRaceNotifications(from: data)
        
        return data
    }

    func startBackgroundUpdates(forTabId tabId: String) {
        stopBackgroundUpdates()
        
        timer = Timer.scheduledTimer(withTimeInterval: GoogleSheetConfig.backgroundUpdateInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            Task {
                do {
                    if self.networkMonitor.isConnected {
                        let _ = try await self.fetchSheetData(tabId: tabId, useCache: false)
                        print("🔄 Mise à jour en arrière-plan réussie pour l'onglet \(tabId)")
                    } else {
                        print("📶 Pas de connexion internet, mise à jour reportée")
                    }
                } catch {
                    print("❌ Erreur lors de la mise à jour en arrière-plan : \(error.localizedDescription)")
                }
            }
        }
        
        print("✅ Mises à jour en arrière-plan démarrées pour \(tabId)")
    }
    
    func stopBackgroundUpdates() {
        timer?.invalidate()
        timer = nil
        print("⏹️ Mises à jour en arrière-plan arrêtées")
    }
    
    func refreshNotifications() async {
        do {
            let data = try await fetchSheetData(tabId: GoogleSheetConfig.groupTabName, useCache: true)
            notificationService.scheduleRaceNotifications(from: data)
        } catch {
            print("❌ Erreur lors du rafraîchissement des notifications : \(error.localizedDescription)")
        }
    }
}
