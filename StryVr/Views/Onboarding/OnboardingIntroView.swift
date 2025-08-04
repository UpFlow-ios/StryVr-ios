//
//  OnboardingIntroView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/17/25.
//  🌳 Animated Welcome Screen for StryVr Onboarding with iOS 18 Liquid Glass
//

import SwiftUI

struct OnboardingIntroView: View {
    var onContinue: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var glassNamespace

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.large) {
                Spacer()

                // MARK: - Logo

                if let logo = logoForCurrentColorScheme() {
                    if #available(iOS 18.0, *) {
                        Image(uiImage: logo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .glassEffect(.regular.tint(Theme.Colors.accent.opacity(0.2)), in: RoundedRectangle(cornerRadius: 20))
                            .glassEffectID("onboarding-logo", in: glassNamespace)
                            .accessibilityLabel("StryVr Logo")
                            .accessibilityHint("Displays the app logo")
                    } else {
                        Image(uiImage: logo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .accessibilityLabel("StryVr Logo")
                            .accessibilityHint("Displays the app logo")
                    }
                } else {
                    if #available(iOS 18.0, *) {
                        Text("StryVr")
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .glassEffect(.regular.tint(Theme.Colors.accent.opacity(0.1)), in: RoundedRectangle(cornerRadius: 12))
                            .glassEffectID("onboarding-text-logo", in: glassNamespace)
                            .accessibilityLabel("StryVr Text Logo")
                    } else {
                        Text("StryVr")
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .accessibilityLabel("StryVr Text Logo")
                    }
                }

                // MARK: - Welcome Message

                VStack(spacing: Theme.Spacing.small) {
                    if #available(iOS 18.0, *) {
                        Text("Welcome to StryVr")
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .multilineTextAlignment(.center)
                            .glassEffect(.regular.tint(Theme.Colors.textPrimary.opacity(0.05)), in: RoundedRectangle(cornerRadius: 8))
                            .glassEffectID("welcome-title", in: glassNamespace)
                            .accessibilityLabel("Welcome to StryVr")
                    } else {
                        Text("Welcome to StryVr")
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .multilineTextAlignment(.center)
                            .accessibilityLabel("Welcome to StryVr")
                    }

                    Text("A smarter way to grow your skills and advance your career path.")
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.medium)
                        .applyWelcomeMessageGlassEffect()
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

// MARK: - iOS 18 Liquid Glass Helper Extensions

extension View {
    /// Apply welcome message glass effect with iOS 18 Liquid Glass
    func applyWelcomeMessageGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(Theme.Colors.textSecondary.opacity(0.05)), in: RoundedRectangle(cornerRadius: 8))
        } else {
            return self
        }
    }
}
