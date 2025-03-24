//
//  NoCodeAPIService.swift
//  USApp
//
//  Created by Johann FOURNIER on 17/12/2024.
//

import Foundation

final class NoCodeAPIService {
    private let baseURL = "https://v1.nocodeapi.com/angelstyle/google_sheets/tHewggNPxxAzjnGk"
    private let cacheManager = CacheManager()

    func fetchAllRows(tabId: String, useCache: Bool = true) async throws -> [[String]] {
        let cacheKey = "NoCodeAPI_\(tabId)"
        
        if useCache, let cachedData = cacheManager.loadData(forKey: cacheKey) {
            print("✅ Données chargées depuis le cache pour l'onglet \(tabId)")
            return cachedData
        }

        let urlString = "\(baseURL)?tabId=\(tabId)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        print("🌐 Requête URL : \(urlString)")
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("❌ Réponse HTTP invalide pour l'onglet \(tabId)")
            throw URLError(.badServerResponse)
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let rows = json["data"] as? [[String]] else {
            print("❌ Format de données invalide pour l'onglet \(tabId)")
            throw URLError(.cannotParseResponse)
        }

        print("✅ Données récupérées depuis l'API NoCode : \(rows.count) lignes")

        cacheManager.saveData(rows, forKey: cacheKey)

        return rows
    }

    func clearCache(forTabId tabId: String) {
        let cacheKey = "NoCodeAPI_\(tabId)"
        cacheManager.clearCache(forKey: cacheKey)
    }
}
