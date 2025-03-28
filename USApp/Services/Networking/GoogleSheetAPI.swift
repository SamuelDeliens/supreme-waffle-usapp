//
//  GoogleSheetAPI.swift
//  USApp
//
//  Created by Johann FOURNIER on 17/12/2024.
//  Updated on 28/03/2025.
//

import Foundation

final class GoogleSheetAPI: SheetAPIProtocol {
    private let cacheService: CacheService
    
    private let urlSession: URLSession
    
    init(cacheService: CacheService = CacheService(), urlSession: URLSession = .shared) {
        self.cacheService = cacheService
        self.urlSession = urlSession
    }

    func fetchAllRows(tabName: String, useCache: Bool = true) async throws -> [[String]] {
        let cacheKey = "GoogleSheet_\(tabName)"
        
        if useCache, let cachedData = cacheService.loadData(forKey: cacheKey) {
            print("✅ Données chargées depuis le cache pour \(tabName)")
            return dropFirstRow(from: cachedData)
        }
        
        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(GoogleSheetConfig.spreadsheetId)/values/\(tabName)?key=\(GoogleSheetConfig.apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        print("🌐 Requête URL : \(urlString)")
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            break
        case 400..<500:
            throw NetworkError.clientError(httpResponse.statusCode)
        case 500..<600:
            throw NetworkError.serverError(httpResponse.statusCode)
        default:
            throw NetworkError.invalidResponse
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let values = json["values"] as? [[String]] else {
            throw NetworkError.invalidData
        }
        
        print("✅ Données récupérées depuis l'API : \(values.count) lignes")
        
        let filteredValues = dropFirstRow(from: values)
        cacheService.saveData(filteredValues, forKey: cacheKey)
        
        return filteredValues
    }

    func clearCache(forTabName tabName: String) throws {
        let cacheKey = "GoogleSheet_\(tabName)"
        try cacheService.clearCache(forKey: cacheKey)
    }

    private func dropFirstRow(from data: [[String]]) -> [[String]] {
        guard data.count > 1 else { return [] }
        return Array(data.dropFirst())
    }
}
