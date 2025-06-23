//
//  OnboardingIntroView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/17/25.
//  🌳 Animated Welcome Screen for StryVr Onboarding
//

import SwiftUI

struct OnboardingIntroView: View {
    var onContinue: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.large) {
                Spacer()

                // MARK: - Logo
                if let logo = logoForCurrentColorScheme() {
                    Image(uiImage: logo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .accessibilityLabel("StryVr Logo")
                        .accessibilityHint("Displays the app logo")
                } else {
                    Text("StryVr")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .accessibilityLabel("StryVr Text Logo")
                }

                // MARK: - Welcome Message
                VStack(spacing: Theme.Spacing.small) {
                    Text("Welcome to StryVr")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                        .accessibilityLabel("Welcome to StryVr")

                    Text("A smarter way to grow your skills, and dominate your career path.")
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.medium)
                        .accessibilityLabel("Welcome message")
                        .accessibilityHint("Describes the purpose of the app")
                }

                Spacer()

                // MARK: - Get Started Button
                CustomButton(
                    title: "Get Started",
                    action: onContinue,
                    backgroundColor: Theme.Colors.accent,
                    icon: "arrow.right"
                )
                .accessibilityLabel("Get Started Button")
                .accessibilityHint("Navigates to the next onboarding step")
                .padding(.bottom, Theme.Spacing.large)
            }
            .padding(.horizontal, Theme.Spacing.large)
        }
    }

    // MARK: - Helper for Logo
    private func logoForCurrentColorScheme() -> UIImage? {
        let logoName = colorScheme == .dark ? "LogoDark" : "LogoLight"
        return UIImage(named: logoName)
    }
}
