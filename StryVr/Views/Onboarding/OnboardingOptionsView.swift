//
//  OnboardingOptionsView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/17/25.
//  🧭 Entry Point: Login, Register or Continue Without Account
//

import SwiftUI

struct OnboardingOptionsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLogin = false
    @State private var showRegister = false
    @State private var skipToApp = false

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.large) {
                // MARK: - Branding

                if let logo = UIImage(named: "LogoDark") {
                    Image(uiImage: logo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .accessibilityLabel("StryVr Logo")
                        .accessibilityHint("Displays the app logo")
                } else {
                    Text("StryVr")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .accessibilityLabel("StryVr Text Logo")
                }

                Text("Welcome to StryVr")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityLabel("Welcome to StryVr")

                Text("Your personalized skill journey starts here.")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.medium)

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
