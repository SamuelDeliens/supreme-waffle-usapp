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
    private let notificationService = NotificationService.shared
    private let backgroundUpdateService = BackgroundUpdateService()

    // MARK: - Initializer
    init() {
        notificationService.requestAuthorization()
        backgroundUpdateService.startBackgroundUpdates()
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
