//
//  LoginView.swift
//  StryVr
//
//  🔐 Login screen with Firebase Email + Okta SSO, styled with full StryVr theme
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Spacing.large) {
                Spacer()

                // MARK: - Logo & Title
                VStack(spacing: Theme.Spacing.small) {
                    Image("stryvr_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)

                    Text("Welcome to StryVr")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                }

                // MARK: - Email & Password Fields
                VStack(spacing: Theme.Spacing.medium) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Theme.Colors.card)
                        .cornerRadius(Theme.CornerRadius.medium)

                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .padding()
                        .background(Theme.Colors.card)
                        .cornerRadius(Theme.CornerRadius.medium)

                    if let error = errorMessage {
                        Text(error)
                            .font(Theme.Typography.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

                    Button(action: handleEmailLogin) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Login")
                                .font(Theme.Typography.buttonText)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(isLoading)
                    .padding()
                    .background(Theme.Colors.accent)
                    .foregroundColor(Theme.Colors.whiteText)
                    .cornerRadius(Theme.CornerRadius.medium)
                }

                // MARK: - Divider
                HStack {
                    Rectangle().frame(height: 1).foregroundColor(Theme.Colors.textSecondary)
                    Text("or").font(Theme.Typography.caption).foregroundColor(
                        Theme.Colors.textSecondary)
                    Rectangle().frame(height: 1).foregroundColor(Theme.Colors.textSecondary)
                }

                // MARK: - Okta SSO Login Button
                Button(action: handleOktaLogin) {
                    HStack {
                        Image(systemName: "lock.shield.fill")
                        Text("Sign in with SSO")
                    }
                    .font(Theme.Typography.body)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(Theme.CornerRadius.medium)
                }

                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.medium)
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Sign In")
        }
    }

    // MARK: - Login with Email
    private func handleEmailLogin() {
        errorMessage = nil
        isLoading = true

        authViewModel.signIn(email: email, password: password)

        // Reset loading state after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }

    // MARK: - Login with Okta
    private func handleOktaLogin() {
        // Placeholder for Okta SSO - would integrate with actual Okta service
        errorMessage = "SSO login coming soon!"
    }
}
