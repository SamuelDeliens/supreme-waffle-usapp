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
    @Binding var isShowingFutureSessions: Bool
    @State private var isPullingToRefresh: Bool = false
    
    var onRefreshCallback: ((@escaping @Sendable () async -> Void) -> Void)?
    
    init(
        isShowingFutureSessions: Binding<Bool>,
        searchQuery: Binding<String>,
        onRefreshCallback: ((@escaping @Sendable () async -> Void) -> Void)? = nil
    ) {
        _viewModel = StateObject(wrappedValue: GroupViewModel(
            isShowingFutureSessions: isShowingFutureSessions.wrappedValue,
            searchQuery: searchQuery.wrappedValue
        ))
        self._externalSearchQuery = searchQuery
        self._isShowingFutureSessions = isShowingFutureSessions
        self.onRefreshCallback = onRefreshCallback
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                if viewModel.isUpdating {
                    InfiniteProgressBar(color: Color(red: 0.7, green: 0.5, blue: 1.0))
                        .frame(height: 4)
                        .padding(.horizontal)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }
                
                if viewModel.isLoading && viewModel.sheetData.isEmpty {
                    loadingView
                } else if viewModel.filteredData().isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        ZStack(alignment: .top) {
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
        }
        .navigationDestination(isPresented: $showDetailView) {
            if let selectedRow = selectedRow {
                DetailGroupView(rowData: selectedRow)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchGroupData(forceRefresh: false)
            }
            viewModel.searchQuery = externalSearchQuery
            
            onRefreshCallback?({ [weak viewModel] in
                Task {
                    await viewModel?.refreshData(forceRefresh: true)
                }
            })
        }
        .onChange(of: externalSearchQuery) { oldValue, newValue in
            viewModel.searchQuery = newValue
        }
        .onChange(of: isShowingFutureSessions) { oldValue, newValue in
            viewModel.isShowingFutureSessions = newValue
            viewModel.objectWillChange.send()
        }
        .onDisappear {
            // Sauvegarde l'état de recherche quand on quitte la vue
            externalSearchQuery = viewModel.searchQuery
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Text("Chargement des données...")
                .padding(.top, 8)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
                .padding()
            
            Text("Aucune séance trouvée")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Button(action: {
                Task {
                    await viewModel.refreshData(forceRefresh: true)
                }
            }) {
                Text("Actualiser")
                    .foregroundColor(.blue)
                    .padding(.vertical, 8)
            }
            .padding(.top, 10)
            
            Spacer()
        }
    }
}
