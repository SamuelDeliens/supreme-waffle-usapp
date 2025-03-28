//
//  CacheServiceProtocol.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//


//
//  CacheService.swift
//  USApp
//
//  Created by Johann FOURNIER on 21/12/2024.
//

import Foundation

protocol CacheServiceProtocol {
    func save<T: Encodable>(_ data: T, forKey key: String) throws
    func load<T: Decodable>(forKey key: String) -> T?
    func clearCache(forKey key: String) throws
    func isDataExpired(forKey key: String, expirationInterval: TimeInterval) -> Bool
}

final class CacheService: CacheServiceProtocol {
    // MARK: - Properties
    private let cacheDirectory: URL
    private let fileManager: FileManager
    
    // MARK: - Initializer
    init() {
        fileManager = FileManager.default
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    // MARK: - Public Methods
    func save<T: Encodable>(_ data: T, forKey key: String) throws {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        let dataToSave = try JSONEncoder().encode(data)
        try dataToSave.write(to: fileURL, options: .atomic)
        
        // Save last update timestamp
        let metadataURL = cacheDirectory.appendingPathComponent("\(key)_metadata")
        let timestamp = Date().timeIntervalSince1970
        try String(timestamp).write(to: metadataURL, atomically: true, encoding: .utf8)
        
        print("✅ Cache enregistré pour la clé \(key)")
    }
    
    func load<T: Decodable>(forKey key: String) -> T? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let cachedData = try Data(contentsOf: fileURL)
            let decodedData = try JSONDecoder().decode(T.self, from: cachedData)
            print("✅ Données chargées depuis le cache pour la clé \(key)")
            return decodedData
        } catch {
            print("❌ Erreur lors de la lecture du cache : \(error)")
            return nil
        }
    }
    
    func clearCache(forKey key: String) throws {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        let metadataURL = cacheDirectory.appendingPathComponent("\(key)_metadata")
        
        if fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.removeItem(at: fileURL)
        }
        
        if fileManager.fileExists(atPath: metadataURL.path) {
            try fileManager.removeItem(at: metadataURL)
        }
        
        print("✅ Cache supprimé pour la clé \(key)")
    }
    
    func isDataExpired(forKey key: String, expirationInterval: TimeInterval = 3600) -> Bool {
        let metadataURL = cacheDirectory.appendingPathComponent("\(key)_metadata")
        
        guard fileManager.fileExists(atPath: metadataURL.path) else {
            return true
        }
        
        do {
            let timestampString = try String(contentsOf: metadataURL, encoding: .utf8)
            guard let timestamp = Double(timestampString) else {
                return true
            }
            
            let lastUpdateDate = Date(timeIntervalSince1970: timestamp)
            let expirationDate = lastUpdateDate.addingTimeInterval(expirationInterval)
            
            return Date() > expirationDate
        } catch {
            return true
        }
    }
}

// MARK: - Extension pour la compatibilité avec le code existant
extension CacheService {
    func saveData(_ data: [[String]], forKey key: String) {
        do {
            try save(data, forKey: key)
        } catch {
            print("❌ Erreur lors de l'enregistrement dans le cache : \(error)")
        }
    }
    
    func loadData(forKey key: String) -> [[String]]? {
        return load(forKey: key)
    }
}
