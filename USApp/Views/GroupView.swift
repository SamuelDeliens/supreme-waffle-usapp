//
//  GroupView.swift
//  USApp
//
//  Created by Johann FOURNIER on 16/12/2024.
//

import SwiftUI

struct GroupView: View {
    @State private var sheetData: [[String]] = []
    @State private var isLoading: Bool = false
    @State private var isUpdating: Bool = false
    @State private var errorMessage: String?
    @Binding var searchQuery: String
    @State private var selectedRow: [String]?
    @State private var showDetailView: Bool = false
    var isShowingFutureSessions: Bool

    private let cacheManager = CacheManager()

    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                if isUpdating {
                    InfiniteProgressBar(color: Color(red: 0.7, green: 0.5, blue: 1.0))
                        .frame(height: 4)
                        .padding(.horizontal)
                }

                if let errorMessage = errorMessage {
                    Text("Erreur : \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if filteredData().isEmpty {
                    Text("Aucune séance trouvée")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(filteredData(), id: \.self) { row in
                                Button(action: {
                                    selectedRow = row
                                    showDetailView = true
                                }) {
                                    SessionTile(
                                        type: row[4],
                                        details: row[5],
                                        location: row[7],
                                        date: row[0]
                                    )
                                }
                                .buttonStyle(TileButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationDestination(isPresented: $showDetailView) {
            if let selectedRow = selectedRow {
                DetailGroupView(rowData: selectedRow)
            }
        }
        .onAppear(perform: fetchGroupData)
    }

    private func filteredData() -> [[String]] {
        let today = Calendar.current.startOfDay(for: Date())

        return sheetData.filter { row in
            guard row.count >= 8, let date = dateFromString(row[0]) else { return false }
            let matchesSearch = searchQuery.isEmpty || row.contains { $0.localizedCaseInsensitiveContains(searchQuery) }
            let matchesDate = isShowingFutureSessions ? date >= today : date < today
            return matchesSearch && matchesDate
        }
    }

    private func fetchGroupData() {
        isLoading = true
        errorMessage = nil
        isUpdating = true

        let cacheKey = "GoogleSheet_groupe"

        // Charger les données en cache avant la mise à jour
        if let cachedData = cacheManager.loadData(forKey: cacheKey) {
            self.sheetData = cachedData
            self.isLoading = false
        }

        // Simuler un délai pour garantir l'affichage de la barre
        Task {
            do {
                
                // Simuler un délai pour voir la barre de progression
                try await Task.sleep(nanoseconds: 1_500_000_000)

                let data = try await APIServiceManager.shared.fetchSheetData(tabId: "groupe", useCache: false)
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

    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.date(from: dateString)
    }
}
