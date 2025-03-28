//
//  GoogleSheetConfig.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//

import Foundation

/// Configuration for Google Sheet API
struct GoogleSheetConfig {
    /// Keychain key for storing API key
    static let apiKeyKeychainKey = "googleSheetApiKey"
    
    /// Get API key from Keychain
    static func getApiKey() -> String? {
        do {
            return try KeychainService.shared.retrieve(key: apiKeyKeychainKey)
        } catch {
            print("❌ Erreur lors de la récupération de l'API key depuis le Keychain: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Set API key in Keychain
    static func setApiKey(_ key: String) {
        do {
            print("Tentative d'enregistrement de la clé API dans le Keychain")
            // Vérifier d'abord si une clé existe déjà
            if let _ = try KeychainService.shared.retrieve(key: apiKeyKeychainKey) {
                try KeychainService.shared.update(key: apiKeyKeychainKey, value: key)
                print("✅ Clé API mise à jour dans le Keychain")
            } else {
                try KeychainService.shared.save(key: apiKeyKeychainKey, value: key)
                print("✅ Clé API enregistrée dans le Keychain")
            }
        } catch {
            print("❌ Erreur lors de la sauvegarde de l'API key dans le Keychain: \(error.localizedDescription)")
        }
    }
    
    /// ID of the spreadsheet to access
    static let spreadsheetId = "1jeLNms9lfRM27GF_2hitAn4agOWaX8PVgBRk7qVsLkE"
    
    /// Name of the group tab
    static let groupTabName = "groupe"
    
    /// Names of individual tabs
    static let individualTabs = [
        "Alexandre", "Amar", "Assia", "Corine", "Fati", "Fethy",
        "Jean-Louis", "Jerome", "Johann", "Lynda", "Maude", "Renaud"
    ]
    
    /// Base URL for the NoCode API
    static let noCodeBaseURL = "https://v1.nocodeapi.com/angelstyle/google_sheets/tHewggNPxxAzjnGk"
    
    /// Interval for background updates in seconds
    static let backgroundUpdateInterval: TimeInterval = 300
}
