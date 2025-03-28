//
//  USApp.swift
//  USApp
//
//  Created by Johann FOURNIER on 12/12/2024.
//

import SwiftUI
import UserNotifications

@main
struct USApp: App {
    
    // MARK: - Properties
    @StateObject private var viewModel = AppViewModel()
    private let notificationService = NotificationService.shared
    private let backgroundUpdateService = BackgroundUpdateService()
    private let apiService = APIServiceManager.shared
    
    @State private var needsAPIKey: Bool = true
    @State private var isAppReady: Bool = false

    // MARK: - Initializer
    init() {
        notificationService.requestAuthorization()
        // Les services ne sont démarrés qu'après la vérification de l'API key
    }

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Loading / Splash screen
                if !isAppReady {
                    // Splash screen seul
                    ZStack {
                        Color(UIColor.systemBackground)
                            .ignoresSafeArea()
                            
                        VStack(spacing: 20) {
                            Image("Logo_Club")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                            
                            Text("Bienvenue à\nUS ALFORTVILLE\nAthlétisme")
                                .font(.custom("Georgia", size: 24))
                                .foregroundColor(Color(red: 63/255, green: 63/255, blue: 153/255))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .onAppear {
                        // Vérifier si une API key existe
                        checkAPIKey()
                    }
                } else {
                    // L'application principale est prête
                    MainView()
                        .environmentObject(viewModel)
                }
                
                // Overlay pour la saisie de l'API key
                if needsAPIKey {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .overlay(
                            APIKeyInputView(isPresented: $needsAPIKey)
                        )
                        .zIndex(10) // S'assurer que l'overlay est au-dessus de tout
                }
            }
            .onChange(of: needsAPIKey) { oldValue, newValue in
                if oldValue && !newValue {
                    // L'API key a été configurée, démarrons les services
                    print("✅ API key configurée, démarrage des services")
                    backgroundUpdateService.startBackgroundUpdates()
                    
                    Task {
                        await refreshNotifications()
                        
                        // Attendre un court instant puis afficher l'application principale
                        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 seconde
                        
                        await MainActor.run {
                            withAnimation {
                                isAppReady = true
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Check API Key
    private func checkAPIKey() {
        let apiKey = GoogleSheetConfig.getApiKey()
        let keyExists = apiKey != nil && !apiKey!.isEmpty
        
        print("Vérification de l'API key: \(keyExists ? "trouvée" : "manquante")")
        
        DispatchQueue.main.async {
            if keyExists {
                // Une clé API valide existe, l'app peut continuer normalement
                self.needsAPIKey = false
                
                // Démarrer les services immédiatement
                self.backgroundUpdateService.startBackgroundUpdates()
                
                // Attendre un court instant pour le splash screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isAppReady = true
                    }
                }
                
                Task {
                    await self.refreshNotifications()
                }
            } else {
                // Pas de clé API, l'utilisateur doit en saisir une
                self.needsAPIKey = true
            }
        }
    }
    
    // MARK: - Refresh Notifications
    private func refreshNotifications() async {
        do {
            let data = try await APIServiceManager.shared.fetchSheetData(tabId: "groupe", useCache: true)
            print("✅ Notifications mises à jour pour les données récupérées : \(data.count) lignes")
        } catch {
            print("❌ Erreur lors du rafraîchissement des notifications : \(error.localizedDescription)")
        }
    }
}
