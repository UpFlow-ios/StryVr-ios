//
//  ForgotPasswordView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/14/25.
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
            Color.background.ignoresSafeArea()

            VStack(spacing: Spacing.large) {
                // MARK: - Title
                Text("Reset Password")
                    .font(FontStyle.title)
                    .foregroundColor(.whiteText)
                    .padding(.top, Spacing.xLarge)
                    .accessibilityLabel("Reset your password")

                // MARK: - Email Field
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.card)
                    .cornerRadius(10)
                    .foregroundColor(.whiteText)
                    .autocapitalization(.none)
                    .accessibilityLabel("Email field")

                // MARK: - Message
                if let message = message {
                    Text(message)
                        .font(FontStyle.caption)
                        .foregroundColor(isError ? .red : .green)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.medium)
                        .accessibilityLabel("Message: \(message)")
                }

                // MARK: - Send Link Button
                Button(action: sendResetLink) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .neonBlue))
                            .accessibilityLabel("Loading")
                    } else {
                        Text("Send Reset Link")
                            .font(FontStyle.body)
                            .foregroundColor(.whiteText)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.neonBlue)
                            .cornerRadius(10)
                            .accessibilityLabel("Send Reset Link button")
                    }
                }
                .disabled(isLoading)

                // MARK: - Back to Login
                Button("Back to Login") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(FontStyle.caption)
                .foregroundColor(.neonBlue)
                .padding(.top, Spacing.small)
                .accessibilityLabel("Back to login")

                Spacer()
            }
            .padding(.horizontal, Spacing.large)
        }
    }

    private func sendResetLink() {
        guard !email.isEmpty else {
            message = "Please enter your email."
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
}
