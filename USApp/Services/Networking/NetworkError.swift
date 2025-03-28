//
//  NetworkError.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    
    case invalidResponse
    
    case invalidData
    
    case clientError(Int)
    
    case serverError(Int)
    
    case noConnection
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL invalide"
        case .invalidResponse:
            return "Réponse invalide du serveur"
        case .invalidData:
            return "Données invalides reçues"
        case .clientError(let code):
            return "Erreur client (code \(code))"
        case .serverError(let code):
            return "Erreur serveur (code \(code))"
        case .noConnection:
            return "Pas de connexion internet"
        }
    }
}
