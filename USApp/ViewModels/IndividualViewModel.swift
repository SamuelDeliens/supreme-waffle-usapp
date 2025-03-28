//
//  IndividualViewModel.swift
//  USApp
//
//  Created by Samuel DELIENS on 27/03/2025.
//

import Foundation

final class IndividualViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var sheetData: [[String]] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedRow: [String]?
    @Published var showDetailView: Bool = false
    @Published var isUpdating: Bool = false
    
    // MARK: - Private Properties
    private let isShowingFutureSessions: Bool
    
    private let cacheService: CacheService
    private let apiService: SheetAPIProtocol
    
    // MARK: - Computed Properties
    var filteredData: [[String]] {
        let today = Calendar.current.startOfDay(for: Date())
        
        return sheetData.filter { row in
            guard row.count >= 8, let date = DateFormatterUtils.dateFromString(row[0]) else { return false }
            let matchesDate = isShowingFutureSessions ? date >= today : date < today
            return matchesDate
        }
    }
    
    // MARK: - Initializer
    init(
        isShowingFutureSessions: Bool,
        apiService: SheetAPIProtocol = GoogleSheetAPI(),
        cacheService: CacheService = CacheService()
    ) {
        self.isShowingFutureSessions = isShowingFutureSessions
        self.apiService = apiService
        self.cacheService = cacheService
    }
    
    // MARK: - Public Methods
    func loadData(for profile: String?) {
        guard let profile = profile else { return }
        
        Task {
            await MainActor.run {
                isUpdating = true
                errorMessage = nil
            }
            
            await fetchData(for: profile)
        }
    }
    
    func selectRow(_ row: [String]) {
        selectedRow = row
        showDetailView = true
    }
    
    // MARK: - Private Methods
    private func fetchData(for tabName: String) async {
        let cacheKey = "GoogleSheet_\(tabName)"
        
        // Load cached data if available
        if let cachedData = cacheService.loadData(forKey: cacheKey) {
            await MainActor.run {
                sheetData = cachedData
                isUpdating = false
            }
        }
        
        // Fetch fresh data
        do {
            try await Task.sleep(nanoseconds: 1_500_000_000) // Simulate delay
            let data = try await apiService.fetchAllRows(tabName: tabName, useCache: false)
            
            await MainActor.run {
                sheetData = data
                isUpdating = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isUpdating = false
            }
        }
    }
}
