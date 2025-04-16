//
//  ForgotPasswordView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/14/25.
//  🔐 Password Reset – Secure, Themed, Accessible
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var email: String = ""
    @State private var message: String?
    @State private var isError: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.large) {

                // MARK: - Title
                Text("Reset Password")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.top, Theme.Spacing.xLarge)
                    .accessibilityLabel("Reset your password")

                // MARK: - Email Field
                TextField("Enter your email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Theme.Colors.card)
                    .cornerRadius(Theme.CornerRadius.medium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityLabel("Email input field")
                    .accessibilityHint("Enter the email address associated with your account")

                // MARK: - Message
                if let message = message {
                    Text(message)
                        .font(Theme.Typography.caption)
                        .foregroundColor(isError ? .red : .green)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.medium)
                        .accessibilityLabel("Message: \(message)")
                }

                // MARK: - Send Reset Link Button
                Button(action: sendResetLink) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                            .accessibilityLabel("Sending reset link")
                    } else {
                        Text("Send Reset Link")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.whiteText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.Colors.accent)
                            .cornerRadius(Theme.CornerRadius.medium)
                            .accessibilityLabel("Send reset link button")
                            .accessibilityHint("Tap to send a password reset link to your email")
                    }
                }
                .disabled(isLoading)

                // MARK: - Back Navigation
                Button("Back to Login") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.accent)
                .padding(.top, Theme.Spacing.small)
                .accessibilityLabel("Back to login screen")
                .accessibilityHint("Tap to return to the login screen")

                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.large)
        }
    }

    // MARK: - Send Password Reset Email
    private func sendResetLink() {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            message = "Please enter your email."
            isError = true
            return
        }

        guard isValidEmail(email) else {
            message = "Please enter a valid email address."
            isError = true
            return
        }

        isLoading = true
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    message = error.localizedDescription
                    isError = true
                } else {
                    message = "✅ A password reset link has been sent to \(email)."
                    isError = false
                }
            }
        }
    }

    // MARK: - Email Validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}

#Preview {
    ForgotPasswordView()
}
