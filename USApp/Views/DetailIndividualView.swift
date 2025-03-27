//
//  DetailIndividualView.swift
//  USApp
//
//  Created by Johann FOURNIER on 16/12/2024.
//

import SwiftUI

struct DetailIndividualView: View {
    // MARK: - Properties
    @StateObject private var viewModel: DetailIndividualViewModel
    
    // MARK: - Initialization
    init(rowData: [String], selectedProfile: Binding<String?>) {
        _viewModel = StateObject(
            wrappedValue: DetailIndividualViewModel(
                rowData: rowData,
                selectedProfile: selectedProfile.wrappedValue
            )
        )
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1, green: 0.7, blue: 0.7, opacity: 0.3),
                    Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text(viewModel.formattedDate)
                        .font(.title2)
                        .foregroundColor(DetailViewColors.titleColor)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 10)
                    
                    // Échauffement
                    DetailRow(
                        icon: DetailViewIcons.warmup,
                        title: "Échauffement",
                        content: viewModel.rowData[1],
                        color: DetailViewColors.warmupColor
                    )
                    
                    // Durée
                    DetailRow(
                        icon: DetailViewIcons.duration,
                        title: "Durée",
                        content: viewModel.rowData[2],
                        color: DetailViewColors.durationColor
                    )
                    
                    // Récupération
                    DetailRow(
                        icon: DetailViewIcons.recovery,
                        title: "Récupération",
                        content: viewModel.rowData[3],
                        color: DetailViewColors.recoveryColor
                    )
                    
                    // Détails
                    DetailRow(
                        icon: DetailViewIcons.details,
                        title: "Détails",
                        content: viewModel.rowData[5],
                        color: DetailViewColors.detailsColor
                    )
                    
                    // Allure
                    DetailRow(
                        icon: DetailViewIcons.pace,
                        title: "Allure",
                        content: viewModel.rowData[6],
                        color: DetailViewColors.paceColor
                    )
                    
                    // Lieu
                    DetailRow(
                        icon: DetailViewIcons.location,
                        title: "Lieu",
                        content: viewModel.rowData[7],
                        color: DetailViewColors.locationColor
                    )
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        DetailIndividualView(
            rowData: [
                "11-12-2024",
                "20min",
                "40min",
                "10min",
                "Fractionné",
                "2 x (8x30s/30s)",
                "Rapide",
                "Parc des sports Val-de-Seine"
            ],
            selectedProfile: .constant("Johann")
        )
    }
}
