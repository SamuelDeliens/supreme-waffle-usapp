//
//  APIKeyUpdateView.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//

import SwiftUI

struct APIKeyUpdateView: View {
    @Binding var isPresented: Bool
    var onSuccessfulUpdate: (() -> Void)?
    
    @State private var apiKey: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    private let testTabName = "groupe"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Modifier la clé API")
                .font(.headline)
                .padding(.top)
            
            SecureField("Nouvelle clé API", text: $apiKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .disabled(isLoading)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
            
            HStack(spacing: 20) {
                // Bouton Annuler
                Button(action: {
                    isPresented = false
                }) {
                    Text("Annuler")
                        .frame(minWidth: 100)
                        .padding(.vertical, 10)
                        .foregroundColor(.blue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
                
                // Bouton Sauvegarder
                Button(action: validateAndSaveKey) {
                    if isLoading {
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
                .disabled(apiKey.isEmpty || isLoading)
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
        
        isLoading = true
        errorMessage = nil
        
        // Test de la clé API avec une requête simple
        Task {
            do {
                // Sauvegarde temporaire de la clé API
                GoogleSheetConfig.setApiKey(apiKey)
                
                // Tente de récupérer les données avec la nouvelle clé
                let api = GoogleSheetAPI()
                let _ = try await api.fetchAllRows(tabName: testTabName, useCache: false)
                
                // Si on arrive ici, la clé est valide
                await MainActor.run {
                    isLoading = false
                    onSuccessfulUpdate?()
                    isPresented = false  // Ferme la vue
                }
            } catch {
                // En cas d'erreur, affiche un message
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Clé invalide"
                }
            }
        }
    }
}

#Preview {
    APIKeyUpdateView(isPresented: .constant(true))
        .preferredColorScheme(.light)
}
