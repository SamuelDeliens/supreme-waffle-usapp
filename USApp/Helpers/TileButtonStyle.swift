//
//  TileButtonStyle.swift
//  USApp
//
//  Created by Johann FOURNIER on 15/12/2024.
//

import SwiftUI

struct TileButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
