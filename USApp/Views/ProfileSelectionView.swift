//
//  ProfileSelectionView.swift
//  USApp
//
//  Created by Johann FOURNIER on 12/12/2024.
//

import SwiftUI

// MARK: - ProfileSelectionView
struct ProfileSelectionView: View {
    
    // MARK: - State Variables
    @Binding var selectedProfile: String?
    @Binding var showProfileSelection: Bool

    // MARK: - Body
    var body: some View {
        NavigationView {
            
            // MARK: - List of Profiles
            List(GoogleSheetTabs.individualTabs, id: \.self) { profile in
                Button(action: {
                    handleProfileSelection(profile: profile)
                }) {
                    HStack {
                        Text(profile)
                            .foregroundColor(.primary)
                        if selectedProfile == profile {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Sélectionnez un profil")
            .toolbar {
                // MARK: - Cancel Button
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        showProfileSelection = false
                    }
                }
            }
        }
    }

    // MARK: - Methods
    private func handleProfileSelection(profile: String) {
        selectedProfile = profile
        showProfileSelection = false
    }
}

// MARK: - Preview
#Preview {
    ProfileSelectionView(
        selectedProfile: .constant("Johann"),
        showProfileSelection: .constant(true)
    )
}
