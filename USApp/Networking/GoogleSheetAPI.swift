//
//  GoogleSheetAPI.swift
//  USApp
//
//  Created by Johann FOURNIER on 17/12/2024.
//

import Foundation

final class GoogleAPISheet {
    private let apiKey = "AIzaSyCFB_HnIZQKpqrP5JxtwO8HpYkktdc6sKk"
    private let spreadsheetId = "1jeLNms9lfRM27GF_2hitAn4agOWaX8PVgBRk7qVsLkE"
    private let cacheManager = CacheManager()

    func fetchAllRows(tabName: String, useCache: Bool = true) async throws -> [[String]] {
        let cacheKey = "GoogleSheet_\(tabName)"
        
        if useCache, let cachedData = cacheManager.loadData(forKey: cacheKey) {
            print("✅ Données chargées depuis le cache pour \(tabName)")
            return dropFirstRow(from: cachedData)
        }

        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)/values/\(tabName)?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        print("🌐 Requête URL : \(urlString)")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("❌ Réponse HTTP invalide")
            throw URLError(.badServerResponse)
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let values = json["values"] as? [[String]] else {
            print("❌ Format de données invalide")
            throw URLError(.cannotParseResponse)
        }

        print("✅ Données récupérées depuis l'API : \(values.count) lignes")

        let filteredValues = dropFirstRow(from: values)

        cacheManager.saveData(filteredValues, forKey: cacheKey)

        return filteredValues
    }

    func clearCache(forTabName tabName: String) {
        let cacheKey = "GoogleSheet_\(tabName)"
        cacheManager.clearCache(forKey: cacheKey)
    }

    private func dropFirstRow(from data: [[String]]) -> [[String]] {
        guard data.count > 1 else { return [] }
        return Array(data.dropFirst())
    }
}
