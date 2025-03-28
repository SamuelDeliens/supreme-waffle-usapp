//
//  GroupViewModel.swift
//  USApp
//
//  Created by Samuel DELIENS on 27/03/2025.
//


import Foundation

class GroupViewModel: ObservableObject {
    @Published var sheetData: [[String]] = []
    @Published var isLoading: Bool = false
    @Published var isUpdating: Bool = false
    @Published var errorMessage: String?
    @Published var searchQuery: String = ""
    @Published var lastRefreshTime: Date? = nil
    
    private let cacheService: CacheService
    private let apiService: NetworkServiceProtocol
    
    var isShowingFutureSessions: Bool
    
    // Durée du cache en secondes (5 minutes)
    private let cacheDuration: TimeInterval = 300
    
    init(isShowingFutureSessions: Bool,
         searchQuery: String = "",
         apiService: NetworkServiceProtocol = APIServiceManager.shared,
         cacheService: CacheService = CacheService()) {
        self.isShowingFutureSessions = isShowingFutureSessions
        self.searchQuery = searchQuery
        self.apiService = apiService
        self.cacheService = cacheService
    }
    
    // Vérifie si les données du cache sont encore valides
    private var isCacheValid: Bool {
        guard let lastRefresh = lastRefreshTime else { return false }
        return Date().timeIntervalSince(lastRefresh) < cacheDuration
    }
    
    func fetchGroupData(forceRefresh: Bool = false) async {
        // Si un chargement est déjà en cours, on ne fait rien
        if isUpdating && !forceRefresh { return }
        
        await MainActor.run {
            if isLoading == false {
                isLoading = true
            }
            if forceRefresh {
                isUpdating = true
            }
            errorMessage = nil
        }

        let cacheKey = "GoogleSheet_\(GoogleSheetConfig.groupTabName)"
        
        // Cas 1: On force le rafraîchissement, on ignore le cache
        if forceRefresh {
            do {
                // Appel réseau avec cache désactivé
                let data = try await apiService.fetchSheetData(tabId: GoogleSheetConfig.groupTabName, useCache: false)
                
                await MainActor.run {
                    self.sheetData = data
                    self.isLoading = false
                    self.isUpdating = false
                    self.lastRefreshTime = Date()
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    self.isUpdating = false
                }
            }
            return
        }
        
        // Cas 2: On a déjà des données en mémoire et le cache est valide
        if !sheetData.isEmpty && isCacheValid {
            await MainActor.run {
                self.isLoading = false
                self.isUpdating = false
            }
            return
        }
        
        // Cas 3: On essaie de charger depuis le cache local
        if let cachedData = cacheService.loadData(forKey: cacheKey) {
            await MainActor.run {
                self.sheetData = cachedData
                self.isLoading = false
                
                // Si le cache est récent, on ne fait pas de requête réseau
                if self.isCacheValid {
                    self.isUpdating = false
                    return
                }
            }
        }
        
        // Cas 4: On a besoin de charger depuis le réseau (cache expiré ou absent)
        do {
            // Pas besoin de délai artificiel si on a déjà des données
            if sheetData.isEmpty {
                try await Task.sleep(nanoseconds: 1_000_000_000) // 1 sec au lieu de 1.5
            }
            
            let data = try await apiService.fetchSheetData(tabId: GoogleSheetConfig.groupTabName, useCache: false)
            
            await MainActor.run {
                self.sheetData = data
                self.isLoading = false
                self.isUpdating = false
                self.lastRefreshTime = Date()
            }
        } catch {
            await MainActor.run {
                // Si on a des données du cache, on les garde mais on affiche une erreur discrète
                if !self.sheetData.isEmpty {
                    self.errorMessage = "Impossible de mettre à jour les données : \(error.localizedDescription)"
                } else {
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
                self.isUpdating = false
            }
        }
    }
    
    func filteredData() -> [[String]] {
        let today = Calendar.current.startOfDay(for: Date())
        
        return sheetData.filter { row in
            guard row.count >= 8, let date = DateFormatterUtils.dateFromString(row[0]) else { return false }
            let matchesSearch = searchQuery.isEmpty || row.contains { $0.localizedCaseInsensitiveContains(searchQuery) }
            let matchesDate = isShowingFutureSessions ? date >= today : date < today
            return matchesSearch && matchesDate
        }
    }
    
    func refreshData(forceRefresh: Bool = true) async {
        await fetchGroupData(forceRefresh: forceRefresh)
    }
}
