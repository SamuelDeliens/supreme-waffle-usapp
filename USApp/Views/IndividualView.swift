//
//  IndividualView.swift
//  USApp
//
//  Created by Johann FOURNIER on 12/12/2024.
//

import SwiftUI

struct IndividualView: View {
    // MARK: - Properties
    @StateObject private var viewModel: IndividualViewModel
    @Binding var selectedProfile: String?
    @Binding var showProfileSelection: Bool
    @Binding var searchQuery: String
    
    // MARK: - Initializer
    init(
        selectedProfile: Binding<String?>,
        showProfileSelection: Binding<Bool>,
        isShowingFutureSessions: Bool,
        searchQuery: Binding<String>
    ) {
        self._selectedProfile = selectedProfile
        self._showProfileSelection = showProfileSelection
        self._searchQuery = searchQuery
        self._viewModel = StateObject(
            wrappedValue: IndividualViewModel(
                isShowingFutureSessions: isShowingFutureSessions
            )
        )
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            mainContent
                .navigationDestination(
                    isPresented: $viewModel.showDetailView
                ) {
                    if let selectedRow = viewModel.selectedRow {
                        DetailIndividualView(
                            rowData: selectedRow,
                            selectedProfile: $selectedProfile
                        )
                    }
                }
                .onChange(of: selectedProfile) { _, newValue in
                    viewModel.loadData(for: newValue)
                }
        }
    }
    
    // MARK: - Subviews
    @ViewBuilder
    private var mainContent: some View {
        if viewModel.isUpdating {
            loadingView
        } else if let errorMessage = viewModel.errorMessage {
            errorView(message: errorMessage)
        } else if viewModel.filteredData.isEmpty {
            emptyStateView
        } else {
            sessionsListView
        }
    }
    
    private var loadingView: some View {
        VStack {
            InfiniteProgressBar(color: Color(red: 0.7, green: 0.5, blue: 1.0))
                .frame(height: 4)
                .padding(.horizontal)
            Spacer()
        }
    }
    
    private func errorView(message: String) -> some View {
        Text("Erreur : \(message)")
            .foregroundColor(.red)
            .padding()
    }
    
    private var emptyStateView: some View {
        Text("Aucune séance trouvée pour \(selectedProfile ?? "le profil sélectionné").")
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private var sessionsListView: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.filteredData, id: \.self) { row in
                    SessionTile(
                        type: row[4],
                        details: row[5],
                        location: row[7],
                        date: row[0]
                    )
                    .onTapGesture {
                        viewModel.selectRow(row)
                    }
                    .buttonStyle(TileButtonStyle())
                }
            }
            .padding(.horizontal)
        }
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
