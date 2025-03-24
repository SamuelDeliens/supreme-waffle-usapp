//
//  ProfileSelector.swift
//  USApp
//
//  Created by Johann FOURNIER on 14/12/2024.
//

import SwiftUI

struct ProfileSelector: View {
    @Binding var selectedProfile: String?
    @Binding var showProfileSelection: Bool

    var body: some View {
        HStack {
            Button(action: {
                showProfileSelection = true
            }) {
                HStack {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .foregroundColor(.blue)
                    Text(selectedProfile ?? "Sélectionnez un profil")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.blue)
                }
            }
            .accessibilityLabel("Changer de profil")
        }
    }
}

#Preview {
    @Previewable @State var selectedProfile: String? = "Johann"
    @Previewable @State var showProfileSelection = false
    return ProfileSelector(
        selectedProfile: $selectedProfile,
        showProfileSelection: $showProfileSelection
    )
}
