//
//  SessionTile.swift
//  USApp
//
//  Created by Johann FOURNIER on 13/12/2024.
//

import SwiftUI

struct SessionTile: View {
    let type: String
    let details: String
    let location: String
    let date: String

    private var icon: (name: String, color: Color) {
        let normalizedType = type.trimmingCharacters(in: .whitespacesAndNewlines)
                                .folding(options: .diacriticInsensitive, locale: .current)
                                .lowercased()

        switch normalizedType {
        case "course", "courses":
            return ("flame.fill", .red)
        case "fractionné", "fractionne":
            return ("stopwatch.fill", .orange)
        case "évènement", "evenement", "événement":
            return ("calendar", .purple)
        case "ppg":
            return ("dumbbell.fill", .green)
        case "endurance", "endurances":
            return ("figure.walk", .blue)
        default:
            return ("questionmark.circle", .gray)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: icon.name)
                    .foregroundColor(icon.color)
                    .font(.title3)
                Text(type.isEmpty ? "Type inconnu" : type)
                    .font(.headline)
                    .foregroundColor(icon.color)
            }

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                Text(details)
                    .font(.body)
                    .foregroundColor(Color("TextTuileView"))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }

            HStack(spacing: 8) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.green)
                Text(location)
                    .font(.subheadline)
                    .foregroundColor(Color("TextTuileView"))
            }

            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundColor(.red)
                Text(date)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextTuileView"))
                    .italic()
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("TuileView"))
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    SessionTile(
        type: "PPG",
        details: "50 min EF (Endurance Fondamentale)",
        location: "Parc des sports Val-de-Seine",
        date: "2024-12-09"
    )
}
