//
//  FileManagerService.swift
//  USApp
//
//  Created by Samuel DELIENS on 27/03/2025.
//


import Foundation

class FileManagerService {
    private let fileName = "personalRecords.json"
    
    // Get Documents Directory
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    // Save PersonalRecord to file
    func save(record: PersonalRecord) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            let data = try JSONEncoder().encode(record)
            try data.write(to: fileURL, options: .atomic)
            print("✅ Données sauvegardées avec succès dans \(fileName).")
        } catch {
            print("❌ Erreur lors de la sauvegarde des données : \(error.localizedDescription)")
        }
    }

    // Load PersonalRecord from file
    func load() -> PersonalRecord? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("📂 Fichier \(fileName) inexistant. Aucune donnée à charger.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let record = try JSONDecoder().decode(PersonalRecord.self, from: data)
            print("✅ Données chargées depuis le fichier \(fileName).")
            return record
        } catch {
            print("❌ Erreur lors du chargement des données : \(error.localizedDescription)")
            return nil
        }
    }
}
