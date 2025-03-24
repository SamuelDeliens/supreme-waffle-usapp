//
//  USApp.swift
//  USApp
//
//  Created by Johann FOURNIER on 12/12/2024.
//

import SwiftUI
import UserNotifications

@main
struct USApp: App {
    
    // MARK: - Properties
    @StateObject private var viewModel = AppViewModel()

    // MARK: - Initializer
    init() {
        requestNotificationPermissions()
        startBackgroundUpdates()
    }

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(viewModel)
                .onAppear {
                    refreshNotifications()
                }
        }
    }

    // MARK: - Notifications Permissions
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Erreur lors de la demande d'autorisation pour les notifications : \(error.localizedDescription)")
            } else if granted {
                print("✅ Autorisation pour les notifications accordée")
            } else {
                print("⚠️ Autorisation pour les notifications refusée")
            }
        }
    }

    // MARK: - Background Updates
    private func startBackgroundUpdates() {
        Task {
            APIServiceManager.shared.startBackgroundUpdates(forTabId: "groupe")
        }
    }

    // MARK: - Refresh Notifications
    private func refreshNotifications() {
        Task {
            do {
                let data = try await APIServiceManager.shared.fetchSheetData(tabId: "groupe", useCache: true)
                print("✅ Notifications mises à jour pour les données récupérées : \(data)")
            } catch {
                print("❌ Erreur lors du rafraîchissement des notifications : \(error.localizedDescription)")
            }
        }
    }
}
