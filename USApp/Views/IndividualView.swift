//
//  IndividualView.swift
//  USApp
//
//  Created by Johann FOURNIER on 12/12/2024.
//

import SwiftUI

struct IndividualView: View {
    @Binding var selectedProfile: String?
    @Binding var showProfileSelection: Bool
    @State private var sheetData: [[String]] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var selectedRow: [String]?
    @State private var showDetailView: Bool = false
    @State private var isUpdating: Bool = false
    var isShowingFutureSessions: Bool
    @Binding var searchQuery: String

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
                    Text("Aucune séance trouvée pour \(selectedProfile ?? "le profil sélectionné").")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
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
                DetailIndividualView(
                    rowData: selectedRow,
                    selectedProfile: $selectedProfile
                )
            }
        }
        .onAppear {
            if let profile = selectedProfile {
                fetchIndividualData(tabName: profile)
            }
        }
        .onChange(of: selectedProfile) { _, newValue in
            if let profile = newValue {
                fetchIndividualData(tabName: profile)
            }
        }
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

    private func fetchIndividualData(tabName: String) {
        isLoading = true
        errorMessage = nil
        isUpdating = true

        let cacheKey = "GoogleSheet_\(tabName)"

        // Charger les données en cache si disponibles
        if let cachedData = cacheManager.loadData(forKey: cacheKey) {
            self.sheetData = cachedData
            self.isLoading = false
        }

        // Simuler un délai pour garantir l'affichage de la barre
        Task {
            do {
                
                // Simuler un délai pour voir la barre de progression
                try await Task.sleep(nanoseconds: 1_500_000_000)

                let data = try await GoogleAPISheet().fetchAllRows(tabName: tabName, useCache: false)
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

// MARK: - Preview
#Preview {
    IndividualView(
        selectedProfile: .constant("Johann"),
        showProfileSelection: .constant(false),
        isShowingFutureSessions: true,
        searchQuery: .constant("")
    )
}
