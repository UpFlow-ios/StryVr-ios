//
//  LoginView.swift
//  StryVr
//
//  🔐 Login screen with Firebase Email + Okta SSO, styled with iOS 18 Liquid Glass
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @Namespace private var glassNamespace

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Spacing.large) {
                Spacer()

                // MARK: - Logo & Title
                VStack(spacing: Theme.Spacing.small) {
                    if #available(iOS 18.0, *) {
                        Image("stryvr_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .glassEffect(.regular.tint(Theme.Colors.accent.opacity(0.2)), in: RoundedRectangle(cornerRadius: 20))
                            .glassEffectID("login-logo", in: glassNamespace)
                    } else {
                        Image("stryvr_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }

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
                        .applyLoginFieldGlassEffect()

                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .padding()
                        .applyLoginFieldGlassEffect()

                    if let error = errorMessage {
                        Text(error)
                            .font(Theme.Typography.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .applyErrorGlassEffect()
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
                    .applyLoginButtonGlassEffect()
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
                        if #available(iOS 18.0, *) {
                            Image(systemName: "lock.shield.fill")
                                .glassEffect(.regular.tint(.white.opacity(0.3)), in: Circle())
                                .glassEffectID("sso-icon", in: glassNamespace)
                        } else {
                            Image(systemName: "lock.shield.fill")
                        }
                        Text("Sign in with SSO")
                    }
                    .font(Theme.Typography.body)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .applySSOButtonGlassEffect()
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

// MARK: - iOS 18 Liquid Glass Helper Extensions

extension View {
    /// Apply login field glass effect with iOS 18 Liquid Glass
    func applyLoginFieldGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(Theme.Colors.card.opacity(0.3)), in: RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
        } else {
            return self.background(Theme.Colors.card)
                .cornerRadius(Theme.CornerRadius.medium)
        }
    }
    
    /// Apply login button glass effect with iOS 18 Liquid Glass
    func applyLoginButtonGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(Theme.Colors.accent.opacity(0.3)), in: RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
                .foregroundColor(Theme.Colors.whiteText)
        } else {
            return self.background(Theme.Colors.accent)
                .foregroundColor(Theme.Colors.whiteText)
                .cornerRadius(Theme.CornerRadius.medium)
        }
    }
    
    /// Apply SSO button glass effect with iOS 18 Liquid Glass
    func applySSOButtonGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(.black.opacity(0.3)), in: RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
                .foregroundColor(.white)
        } else {
            return self.background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(Theme.CornerRadius.medium)
        }
    }
    
    /// Apply error glass effect with iOS 18 Liquid Glass
    func applyErrorGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(.red.opacity(0.1)), in: RoundedRectangle(cornerRadius: 8))
        } else {
            return self
        }
    }
}
