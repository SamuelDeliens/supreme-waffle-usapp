//
//  InfiniteProgressBar.swift
//  USApp
//
//  Created by Johann FOURNIER on 13/01/2025.
//

import SwiftUI

struct InfiniteProgressBar: View {
    @State private var offset: CGFloat = -100
    private let animationDuration: Double = 1.0
    var color: Color

    init(color: Color = .blue) {
        self.color = color
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                Capsule()
                    .fill(color)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height)
                    .offset(x: offset)
                    .onAppear {
                        withAnimation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                            offset = geometry.size.width // Animation infinie
                        }
                    }
            }
        }
        .clipShape(Capsule())
    }
}
