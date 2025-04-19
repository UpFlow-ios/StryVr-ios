//
//  SplashScreenView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/16/25.
//  🌳 Animated Tree Logo Splash Screen – Branded App Entry
//

//
//  SplashScreenView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/17/25.
//

import SwiftUI
import os.log

/// Animated splash screen that adapts to Light & Dark Mode with StryVr branding
struct SplashScreenView: View {
    @State private var isActive = false
    @Environment(\.colorScheme) var colorScheme

    private let splashDuration: TimeInterval = 2.0
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "StryVr", category: "SplashScreenView")

    var body: some View {
        ZStack {
            // Background adapts to light or dark mode
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // MARK: - Logo
                Image(logoName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .transition(.opacity)
                    .accessibilityLabel("StryVr App Logo")
                    .accessibilityHint("Animated Splash Logo")

                // MARK: - Loader
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: loaderColor))
                    .scaleEffect(1.2)
                    .accessibilityLabel("Loading")
            }
            .opacity(isActive ? 0 : 1)
        }
        .onAppear {
            logger.info("⏳ Splash screen started")
            DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) {
                withAnimation(.easeInOut) {
                    isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            StryVrAppEntryPoint()
        }
    }

    // MARK: - Dynamic Logo
    private var logoName: String {
        colorScheme == .dark ? "LogoDark" : "LogoLight"
    }

    // MARK: - Dynamic Background Color
    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }

    // MARK: - Dynamic Loader Tint
    private var loaderColor: Color {
        colorScheme == .dark ? .white : .black
    }
}

/// Entry point that determines whether to show Home or Login
struct StryVrAppEntryPoint: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                HomeView()
            } else {
                LoginView()
            }
        }
    }
}

