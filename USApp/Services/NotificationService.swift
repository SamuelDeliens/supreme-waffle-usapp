//
//  NotificationService.swift
//  USApp
//
//  Created by Samuel DELIENS on 27/03/2025.
//

import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    
    private init() {}

    // Demander la permission de notification
    func requestAuthorization() {
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
}
