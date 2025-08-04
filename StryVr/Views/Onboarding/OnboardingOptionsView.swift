//
//  OnboardingOptionsView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/17/25.
//  🧭 Entry Point: Login, Register or Continue Without Account with iOS 18 Liquid Glass
//

import SwiftUI

struct OnboardingOptionsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLogin = false
    @State private var showRegister = false
    @State private var skipToApp = false
    @Namespace private var glassNamespace

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.large) {
                // MARK: - Branding

                if let logo = UIImage(named: "LogoDark") {
                    if #available(iOS 18.0, *) {
                        Image(uiImage: logo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .glassEffect(.regular.tint(Theme.Colors.accent.opacity(0.2)), in: RoundedRectangle(cornerRadius: 16))
                            .glassEffectID("options-logo", in: glassNamespace)
                            .accessibilityLabel("StryVr Logo")
                            .accessibilityHint("Displays the app logo")
                    } else {
                        Image(uiImage: logo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .accessibilityLabel("StryVr Logo")
                            .accessibilityHint("Displays the app logo")
                    }
                } else {
                    if #available(iOS 18.0, *) {
                        Text("StryVr")
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .glassEffect(.regular.tint(Theme.Colors.accent.opacity(0.1)), in: RoundedRectangle(cornerRadius: 12))
                            .glassEffectID("options-text-logo", in: glassNamespace)
                            .accessibilityLabel("StryVr Text Logo")
                    } else {
                        Text("StryVr")
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .accessibilityLabel("StryVr Text Logo")
                    }
                }

                if #available(iOS 18.0, *) {
                    Text("Welcome to StryVr")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .glassEffect(.regular.tint(Theme.Colors.textPrimary.opacity(0.05)), in: RoundedRectangle(cornerRadius: 8))
                        .glassEffectID("options-welcome-title", in: glassNamespace)
                        .accessibilityLabel("Welcome to StryVr")
                } else {
                    Text("Welcome to StryVr")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .accessibilityLabel("Welcome to StryVr")
                }

                Text("Your personalized skill journey starts here.")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.medium)
                    .applyOptionsMessageGlassEffect()

                Spacer()

                // MARK: - Options

                VStack(spacing: Theme.Spacing.medium) {
                    CustomButton(
                        title: "Log In",
                        action: { navigateTo(.login) },
                        backgroundColor: Theme.Colors.accent,
                        icon: "lock.fill"
                    )
                    .accessibilityLabel("Log In Button")
                    .accessibilityHint("Navigates to the login screen")

                    CustomButton(
                        title: "Sign Up",
                        action: { navigateTo(.register) },
                        backgroundColor: Theme.Colors.accent,
                        icon: "person.badge.plus"
                    )
                    .accessibilityLabel("Sign Up Button")
                    .accessibilityHint("Navigates to the registration screen")

                    Button(
                        action: {
                            navigateTo(.skip)
                        },
                        label: {
                            Text("Continue without an account")
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }
                    )
                    .applySkipButtonGlassEffect()
                    .accessibilityLabel("Continue without an account Button")
                    .accessibilityHint("Skips login and navigates to the app")
                }

                Spacer(minLength: 30)
            }
            .padding(.horizontal, Theme.Spacing.large)
        }

        // MARK: - Navigation Logic

        .sheet(isPresented: $showLogin) {
            LoginView()
                .environmentObject(authViewModel)
        }
        .sheet(isPresented: $showRegister) {
            RegisterView()
                .environmentObject(authViewModel)
        }
        .fullScreenCover(isPresented: $skipToApp) {
            AppShellView()
                .environmentObject(authViewModel)
        }
    }

    // MARK: - Navigation Helper

    private func navigateTo(_ destination: Destination) {
        switch destination {
        case .login:
            showLogin = true
        case .register:
            showRegister = true
        case .skip:
            skipToApp = true
        }
    }

    private enum Destination {
        case login, register, skip
    }
}

// MARK: - iOS 18 Liquid Glass Helper Extensions

extension View {
    /// Apply options message glass effect with iOS 18 Liquid Glass
    func applyOptionsMessageGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(Theme.Colors.textSecondary.opacity(0.05)), in: RoundedRectangle(cornerRadius: 8))
        } else {
            return self
        }
    }
    
    /// Apply skip button glass effect with iOS 18 Liquid Glass
    func applySkipButtonGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(Theme.Colors.textSecondary.opacity(0.1)), in: RoundedRectangle(cornerRadius: 6))
        } else {
            return self
        }
    }
}
