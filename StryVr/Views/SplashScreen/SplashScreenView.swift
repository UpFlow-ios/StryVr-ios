//
//  SplashScreenView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/16/25.
//  🌳 Animated Tree Logo Splash Screen – Branded App Entry
//

import SwiftUI

/// Displays the branded splash screen with StryVr tree logo and animated intro
struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    @State private var scale: CGFloat = 0.85

    private let splashDuration: TimeInterval = 2.0
    private let logoSize: CGFloat = 120

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            if isActive {
                HomeView() // ✅ Replace with OnboardingView() later if needed
                    .transition(.opacity)
            } else {
                VStack(spacing: Theme.Spacing.medium) {
                    Image("stryvr-logo-tree") // Add this to Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: logoSize, height: logoSize)
                        .opacity(opacity)
                        .scaleEffect(scale)
                        .accessibilityLabel("StryVr tree logo")
                        .onAppear {
                            withAnimation(.easeOut(duration: 1.0)) {
                                self.opacity = 1.0
                                self.scale = 1.0
                            }
                        }

                    Text("stryvr")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.Colors.textPrimary)
                        .opacity(opacity)
                        .accessibilityLabel("StryVr app name")
                        .accessibilityHint("Welcome to the StryVr app")
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
