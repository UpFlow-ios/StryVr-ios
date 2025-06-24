//
//  OnboardingFlowView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/17/25.
//  🌱 Step-Based Flow Controller for Onboarding Screens
//

import SwiftUI

enum OnboardingStep {
    case intro
    case options
}

struct OnboardingFlowView: View {
    @State private var step: OnboardingStep = .intro
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            switch step {
            case .intro:
                OnboardingIntroView {
                    navigateTo(.options)
                }

            case .options:
                if authViewModel.userSession != nil || authViewModel.userSession == nil {
                    // ✅ Handles both logged-in or fresh guest login state
                    OnboardingOptionsView()
                        .environmentObject(authViewModel)
                } else {
                    Text("Error: Unable to load onboarding options.")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .accessibilityLabel("Error loading onboarding screen")
                        .accessibilityHint("There was an issue with user authentication.")
                }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: step)
    }

    // MARK: - Reusable Step Navigation

    private func navigateTo(_ nextStep: OnboardingStep) {
        withAnimation(.easeInOut) {
            step = nextStep
        }
    }
}
