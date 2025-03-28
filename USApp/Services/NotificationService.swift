//
//  NotificationService.swift
//  USApp
//
//  Created by Samuel DELIENS on 27/03/2025.
//

import UserNotifications

protocol NotificationServiceProtocol {
    func requestAuthorization()

    func scheduleRaceNotifications(from data: [[String]])

    func scheduleNotification(title: String, body: String, at date: Date)
}

final class NotificationService: NotificationServiceProtocol {
    static let shared = NotificationService()
    
    private init() {}

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
    
    func scheduleRaceNotifications(from data: [[String]]) {
            let raceEntries = data.filter { row in
                row.count >= 6 && row[4].lowercased() == "course"
            }
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            for entry in raceEntries {
                guard entry.count >= 6 else { continue }
                
                let dateString = entry[0]
                let details = entry[5]
                
                guard let raceDate = dateFromString(dateString) else { continue }
                
                guard raceDate > Date() else { continue }
                
                let names = extractParticipants(from: details)
                guard !names.isEmpty else { continue }
                
                guard let notificationDate = calculateNotificationDate(for: raceDate) else { continue }
                
                let participantMessage = "\(names.joined(separator: ", ")) font une course demain, encouragez-les !!! 💪"
                
                scheduleNotification(
                    title: "Encouragez vos amis !",
                    body: participantMessage,
                    at: notificationDate
                )
            }
        }

        func scheduleNotification(title: String, body: String, at date: Date) {
            guard date > Date() else {
                print("⚠️ Date passée, notification non programmée")
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date),
                repeats: false
            )
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Erreur lors de la planification de la notification : \(error.localizedDescription)")
                } else {
                    print("✅ Notification planifiée pour \(date)")
                }
            }
        }

        private func calculateNotificationDate(for eventDate: Date) -> Date? {
            var notificationDate = Calendar.current.date(byAdding: .day, value: -1, to: eventDate)
            notificationDate = Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: notificationDate ?? eventDate)
            return notificationDate
        }

        private func dateFromString(_ dateString: String) -> Date? {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            return formatter.date(from: dateString)
        }

        private func extractParticipants(from details: String) -> [String] {
            do {
                let pattern = "\\(([^)]+)\\)"
                let regex = try NSRegularExpression(pattern: pattern)
                let matches = regex.matches(in: details, range: NSRange(details.startIndex..., in: details))
                
                return matches.compactMap { match in
                    if let range = Range(match.range(at: 1), in: details) {
                        return String(details[range])
                    }
                    return nil
                }
            } catch {
                print("❌ Erreur lors de l'extraction des participants : \(error.localizedDescription)")
                return []
            }
        }
}
