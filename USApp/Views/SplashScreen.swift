//
//  SplashScreen.swift
//  USApp
//
//  Created by Johann FOURNIER on 27/12/2024.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var logoOpacity: Double = 0.0
    @State private var logoScale: CGFloat = 0.8
    @State private var textOpacity: Double = 0.0

    private let welcomeColor = Color(red: 63 / 255, green: 63 / 255, blue: 153 / 255)
    private let welcomeFont = Font.custom("Georgia", size: 24)
    var body: some View {
        if isActive {
            MainView()
        } else {
            ZStack {
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Image("Logo_Club")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .offset(x: 15, y: 0)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 2.5)) {
                                logoOpacity = 1.0
                                logoScale = 1.0
                            }
                        }

                    Text("Bienvenue à\nUS ALFORTVILLE\nAthlétisme")
                        .font(welcomeFont)
                        .foregroundColor(welcomeColor)
                        .multilineTextAlignment(.center)
                        .opacity(textOpacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 2.0).delay(1.0)) {
                                textOpacity = 1.0
                            }
                        }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
