//
//  CacheManager.swift
//  USApp
//
//  Created by Johann FOURNIER on 21/12/2024.
//

import Foundation

final class CacheManager {
    private let cacheDirectory: URL
    private let fileManager: FileManager

    init() {
        fileManager = FileManager.default
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

    func saveData(_ data: [[String]], forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        do {
            let dataToSave = try JSONEncoder().encode(data)
            try dataToSave.write(to: fileURL, options: .atomic)
            print("✅ Cache enregistré pour la clé \(key)")
        } catch {
            print("❌ Erreur lors de l'enregistrement dans le cache : \(error)")
        }
    }

    func loadData(forKey key: String) -> [[String]]? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        do {
            let cachedData = try Data(contentsOf: fileURL)
            let decodedData = try JSONDecoder().decode([[String]].self, from: cachedData)
            print("✅ Données chargées depuis le cache pour la clé \(key)")
            return decodedData
        } catch {
            print("❌ Erreur lors de la lecture du cache : \(error)")
            return nil
        }
    }

    func clearCache(forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        do {
            try fileManager.removeItem(at: fileURL)
            print("✅ Cache supprimé pour la clé \(key)")
        } catch {
            print("❌ Erreur lors de la suppression du cache : \(error)")
        }
    }
}
