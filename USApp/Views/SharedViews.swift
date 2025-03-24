//
//  SharedViews.swift
//  USApp
//
//  Created by Johann FOURNIER on 16/12/2024.
//

import SwiftUI

// MARK: - BackButton
struct BackButton: View {
   
    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                Text("Retour")
            }
            .foregroundColor(.blue)
        }
    }
}

// MARK: - DetailRow
struct DetailRow: View {
    // MARK: - Properties
    let icon: String
    let title: String
    let content: String
    let color: Color

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.body)
                Text(title)
                    .font(.body)
            }
            .foregroundColor(color)
            
            Text(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "N/A" : content)
                .font(.body)
                .foregroundColor(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .primary)
                .padding(.leading, 24)
        }
    }
}

// MARK: - Color Extension
extension Color {
    
    // MARK: - Initializer with Hex
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - DetailViewColors
struct DetailViewColors {
    static let titleColor = Color.primary
    static let warmupColor = Color.orange
    static let detailsColor = Color.purple
    static let durationColor = Color.pink
    static let recoveryColor = Color.green
    static let paceColor = Color.purple.opacity(0.8)
    static let locationColor = Color.blue
}

// MARK: - DetailViewIcons
struct DetailViewIcons {
    static let warmup = "flame.fill"
    static let details = "info.circle.fill"
    static let duration = "clock.fill"
    static let recovery = "heart.circle.fill"
    static let pace = "speedometer"
    static let location = "location.fill"
}
