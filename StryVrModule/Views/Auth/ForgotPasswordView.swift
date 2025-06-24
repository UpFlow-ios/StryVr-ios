//
//  ForgotPasswordView.swift
//  StryVr
//
//  🔐 Password Reset Integrated with AuthViewModel
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var email: String = ""
    @State private var message: String?
    @State private var isError: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.large) {
                Text("Reset Password")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.top, Theme.Spacing.xLarge)

                TextField("Enter your email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Theme.Colors.card)
                    .cornerRadius(Theme.CornerRadius.medium)

                if let message = message {
                    Text(message)
                        .font(Theme.Typography.caption)
                        .foregroundColor(isError ? .red : .green)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.medium)
                }

                Button(action: sendResetLink) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                    } else {
                        Text("Send Reset Link")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.whiteText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.Colors.accent)
                            .cornerRadius(Theme.CornerRadius.medium)
                    }
                }
                .disabled(isLoading)

                Button("Back to Login") {
                    simpleHaptic()
                    presentationMode.wrappedValue.dismiss()
                }
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.accent)
                .padding(.top, Theme.Spacing.small)

                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.large)
        }
    }

    // MARK: - Reset Password Logic

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
        simpleHaptic()
        authViewModel.resetPassword(email: email)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func simpleHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
