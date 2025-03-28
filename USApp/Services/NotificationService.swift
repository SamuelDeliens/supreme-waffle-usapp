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
    
    /*
    func scheduleNotification(forCourse course: String, details: String, on date: Date) {
        
        let participants = extractParticipants(from: details)
        let participantMessage = participants.isEmpty
            ? "Encouragez vos coéquipiers !"
            : "\(participants.joined(separator: ", ")) font une course demain, encouragez-les !!! 💪"
        
        let content = UNMutableNotificationContent()
        content.title = "Préparez-vous pour votre course !"
        content.body = participantMessage
        content.sound = .default

        let notificationDate = calculateNotificationDate(for: date)

        guard let notificationDate = notificationDate else {
            print("❌ Impossible de calculer la date de notification.")
            return
        }

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Erreur lors de la programmation de la notification : \(error.localizedDescription)")
            } else {
                print("✅ Notification programmée pour \(course) à \(notificationDate)")
            }
        }
    }
    
    private func calculateNotificationDate(for eventDate: Date) -> Date? {
        
        var notificationDate = Calendar.current.date(byAdding: .day, value: -1, to: eventDate)
        notificationDate = Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: notificationDate ?? eventDate)
        return notificationDate
    }

    private func extractParticipants(from details: String) -> [String] {
        
        let pattern = "\\((.*?)\\)"
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: details, range: NSRange(details.startIndex..., in: details))
            return matches.compactMap {
                if let range = Range($0.range(at: 1), in: details) {
                    return String(details[range])
                }
                return nil
            }
        } catch {
            print("❌ Erreur lors de l'extraction des participants : \(error.localizedDescription)")
            return []
        }
    }*/
}
