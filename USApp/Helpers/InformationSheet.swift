//
//  Information.swift
//  USApp
//
//  Created by Johann FOURNIER on 12/12/2024.
//

import SwiftUI

struct InformationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    // Lien du Google Sheet
    private let googleSheetURL = URL(string: "https://docs.google.com/spreadsheets/d/1jeLNms9lfRM27GF_2hitAn4agOWaX8PVgBRk7qVsLkE/edit?gid=0#gid=0")!
    
    // Récupération de la version
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    featuresSection
                    googleSheetSection
                    creditsSection
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Label("Retour", systemImage: "chevron.left")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .center, spacing: 12) {
            if let iconImage = UIImage(named: "InfoIcon") {
                Image(uiImage: iconImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .cornerRadius(16)
                    .padding(.bottom, 8)
            }
            
            Text("USApp")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Version \(appVersion)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 2)
        )
    }
    
    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(spacing: 16) {
            featureCard(
                title: "Vue Groupe",
                icon: "person.3.fill",
                description: "Consultez les séances planifiées pour l'ensemble du groupe. Utilisez la barre de recherche pour trouver rapidement une séance spécifique."
            )
            
            featureCard(
                title: "Vue Individuelle",
                icon: "person.fill",
                description: "Accédez à vos séances personnelles. Sélectionnez votre profil une seule fois, et vos données seront automatiquement chargées à chaque utilisation."
            )
            
            featureCard(
                title: "Navigation Intuitive",
                icon: "rectangle.3.group.fill",
                description: "Basculez facilement entre les différentes vues grâce à la barre de navigation située en bas de l'écran."
            )
        }
    }
    
    // MARK: - Google Sheet Section
    private var googleSheetSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Link(destination: googleSheetURL) {
                HStack {
                    Image(systemName: "link.circle.fill")
                        .font(.title2)
                    Text("Accéder au Google Sheet")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "arrow.up.forward.app.fill")
                        .foregroundColor(.blue)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.1))
                )
            }
        }
        .foregroundColor(.blue)
    }
    
    // MARK: - Credits Section
    private var creditsSection: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Développé pour USA d'Alfortville")
                .font(.footnote)
                .foregroundColor(.secondary)
            Text("© 2024 TOTO")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top)
    }
    
    // MARK: - Feature Card
    private func featureCard(title: String, icon: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 2)
        )
    }
}

#Preview {
    InformationSheet()
}
