//
//  GroupView.swift
//  USApp
//
//  Created by Johann FOURNIER on 16/12/2024.
//

import SwiftUI

struct GroupView: View {
    @StateObject private var viewModel: GroupViewModel
    @State private var selectedRow: [String]?
    @State private var showDetailView: Bool = false
    @Binding var externalSearchQuery: String
    
    init(isShowingFutureSessions: Bool, searchQuery: Binding<String>) {
        _viewModel = StateObject(wrappedValue: GroupViewModel(
            isShowingFutureSessions: isShowingFutureSessions,
            searchQuery: searchQuery.wrappedValue
        ))
        self._externalSearchQuery = searchQuery
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                if viewModel.isUpdating {
                    InfiniteProgressBar(color: Color(red: 0.7, green: 0.5, blue: 1.0))
                        .frame(height: 4)
                        .padding(.horizontal)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text("Erreur : \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.filteredData().isEmpty {
                    Text("Aucune séance trouvée")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(viewModel.filteredData(), id: \.self) { row in
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
        .onAppear {
            Task {
                await viewModel.refreshData()
            }
            // Synchronise la recherche externe avec le ViewModel
            viewModel.searchQuery = externalSearchQuery
        }
        .onChange(of: externalSearchQuery) { oldValue, newValue in
            viewModel.searchQuery = newValue
        }
        .onDisappear {
            // Sauvegarde l'état de recherche quand on quitte la vue
            externalSearchQuery = viewModel.searchQuery
        }
    }
}
