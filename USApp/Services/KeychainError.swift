//
//  KeychainError.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//

import Foundation
import Security

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
    case saveError(status: OSStatus)
    case readError(status: OSStatus)
    case deleteError(status: OSStatus)
}

class KeychainService {
    static let shared = KeychainService()
    
    private init() {}
    
    private let service = "com.usapp.keychain"
    
    func save(key: String, value: String) throws {
        // Convertit la valeur en data
        let valueData = value.data(using: .utf8)!
        
        // Vérifie d'abord si l'élément existe déjà
        if try retrieve(key: key) != nil {
            try update(key: key, value: value)
            return
        }
        
        // Crée un dictionnaire d'attributs pour l'élément Keychain
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: valueData
        ]
        
        // Ajoute l'élément au keychain
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveError(status: status)
        }
        
        print("✅ Valeur sauvegardée dans le Keychain pour la clé: \(key)")
    }
    
    func update(key: String, value: String) throws {
        // Convertit la valeur en data
        let valueData = value.data(using: .utf8)!
        
        // Dictionnaire de requête pour identifier l'élément à mettre à jour
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        // Dictionnaire des attributs à mettre à jour
        let attributes: [String: Any] = [
            kSecValueData as String: valueData
        ]
        
        // Met à jour l'élément dans le keychain
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainError.saveError(status: status)
        }
        
        print("✅ Valeur mise à jour dans le Keychain pour la clé: \(key)")
    }
    
    func retrieve(key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else {
            print("⚠️ Élément non trouvé dans le Keychain pour la clé: \(key)")
            return nil
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.readError(status: status)
        }
        
        guard let data = item as? Data else {
            throw KeychainError.unexpectedPasswordData
        }
        
        guard let value = String(data: data, encoding: .utf8) else {
            throw KeychainError.unexpectedPasswordData
        }
        
        print("✅ Valeur récupérée depuis le Keychain pour la clé: \(key)")
        return value
    }
    
    func delete(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteError(status: status)
        }
        
        print("✅ Élément supprimé du Keychain pour la clé: \(key)")
    }
}
