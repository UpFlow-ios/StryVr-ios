//
//  SplashScreenView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/16/25.
//  🌳 Animated Tree Logo Splash Screen – Branded App Entry
//

import SwiftUI

/// Displays the app's animated splash screen using LogoDark
struct SplashScreenView: View {
    @State private var isActive = false
    private let splashDuration: TimeInterval = 2.0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                // Logo with fallback
                Image("LogoDark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .transition(.opacity)
                    .accessibilityLabel("StryVr Logo")
                    .accessibilityHint("Displays the app logo on launch")

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                    .accessibilityLabel("Loading")
                    .accessibilityHint("Indicates the app is launching")
            }
            .opacity(isActive ? 0 : 1)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) {
                    isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            StryVrAppEntryPoint()
        }
    }
}

/// Placeholder view to control app entry state
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
