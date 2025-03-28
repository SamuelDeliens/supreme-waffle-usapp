//
//  APIKeyInputView.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//

import SwiftUI

struct APIKeyInputView: View {
    @Binding var isPresented: Bool
    @State private var apiKey: String = ""
    @State private var isValidating: Bool = false
    @State private var errorMessage: String? = nil
    @Environment(\.dismiss) private var dismiss
    
    private let testTabName = "groupe"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Entrez la clé API")
                .font(.headline)
                .padding(.top)
            
            SecureField("Clé API Google Sheets", text: $apiKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
            
            HStack(spacing: 20) {
                // Bouton Quitter
                Button(action: {
                    exit(0)  // Quitte l'application
                }) {
                    Text("Quitter")
                        .frame(minWidth: 100)
                        .padding(.vertical, 10)
                        .foregroundColor(.red)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red, lineWidth: 1)
                        )
                }
                
                // Bouton Sauvegarder
                Button(action: validateAndSaveKey) {
                    if isValidating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Sauvegarder")
                            .frame(minWidth: 100)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .disabled(apiKey.isEmpty || isValidating)
            }
            .padding(.bottom)
        }
        .padding()
        .frame(width: 320)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 10)
    }
    
    private func validateAndSaveKey() {
        guard !apiKey.isEmpty else { return }
        
        isValidating = true
        errorMessage = nil
        
        print("Validation de la clé API: \(apiKey)")
        
        // Test de la clé API avec une requête simple
        Task {
            do {
                // Sauvegarde temporaire de la clé API
                GoogleSheetConfig.setApiKey(apiKey)
                print("Clé API enregistrée temporairement, test de connexion...")
                
                // Tente de récupérer les données avec la nouvelle clé
                let api = GoogleSheetAPI()
                let _ = try await api.fetchAllRows(tabName: testTabName, useCache: false)
                
                // Si on arrive ici, la clé est valide
                await MainActor.run {
                    print("Clé API validée avec succès")
                    isValidating = false
                    isPresented = false  // Ferme la vue
                }
            } catch {
                // En cas d'erreur, affiche un message et réinitialise la clé
                await MainActor.run {
                    print("Échec de validation de la clé API: \(error.localizedDescription)")
                    isValidating = false
                    errorMessage = "Clé invalide"
                    
                    // Supprime la clé API qui n'est pas valide
                    do {
                        try KeychainService.shared.delete(key: GoogleSheetConfig.apiKeyKeychainKey)
                    } catch {
                        print("❌ Erreur lors de la suppression de la clé API: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

#Preview {
    APIKeyInputView(isPresented: .constant(true))
        .preferredColorScheme(.light)
}
