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
    
    private let cacheManager = CacheManager()
    private let apiService = APIServiceManager.shared
    
    let isShowingFutureSessions: Bool
    
    init(isShowingFutureSessions: Bool, searchQuery: String = "") {
        self.isShowingFutureSessions = isShowingFutureSessions
        self.searchQuery = searchQuery
    }
    
    func fetchGroupData() {
        isLoading = true
        errorMessage = nil
        isUpdating = true
        
        let cacheKey = "GoogleSheet_groupe"
        
        // Charger les données en cache avant la mise à jour
        if let cachedData = cacheManager.loadData(forKey: cacheKey) {
            self.sheetData = cachedData
            self.isLoading = false
        }
        
        Task {
            do {
                // Simuler un délai pour voir la barre de progression
                try await Task.sleep(nanoseconds: 1_500_000_000)
                
                let data = try await apiService.fetchSheetData(tabId: "groupe", useCache: false)
                await MainActor.run {
                    self.sheetData = data
                    self.isUpdating = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Erreur : \(error.localizedDescription)"
                    self.isUpdating = false
                }
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
    
    func refreshData() async {
        await fetchGroupData()
    }
}
