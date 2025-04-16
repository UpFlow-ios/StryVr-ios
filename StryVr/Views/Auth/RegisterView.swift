//
//  RegisterView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/14/25.
//  🔐 Secure Account Creation – Firebase Auth & Themed UI
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.large) {

                // MARK: - Title
                Text("Create Account")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.top, Theme.Spacing.xLarge)
                    .accessibilityLabel("Create Account")

                // MARK: - Email Field
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Theme.Colors.card)
                    .cornerRadius(Theme.CornerRadius.medium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityLabel("Email field")
                    .accessibilityHint("Enter your email address")

                // MARK: - Password Field
                SecureField("Password", text: $password)
                    .textContentType(.newPassword)
                    .padding()
                    .background(Theme.Colors.card)
                    .cornerRadius(Theme.CornerRadius.medium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityLabel("Password field")
                    .accessibilityHint("Enter a secure password")

                // MARK: - Confirm Password
                SecureField("Confirm Password", text: $confirmPassword)
                    .textContentType(.password)
                    .padding()
                    .background(Theme.Colors.card)
                    .cornerRadius(Theme.CornerRadius.medium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityLabel("Confirm password field")
                    .accessibilityHint("Re-enter your password to confirm")

                // MARK: - Error Message
                if let error = errorMessage {
                    Text(error)
                        .font(Theme.Typography.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.medium)
                        .accessibilityLabel("Error message: \(error)")
                }

                // MARK: - Register Button
                Button(action: registerUser) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                            .accessibilityLabel("Registering...")
                    } else {
                        Text("Register")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.whiteText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.Colors.accent)
                            .cornerRadius(Theme.CornerRadius.medium)
                            .accessibilityLabel("Register account")
                            .accessibilityHint("Tap to create your account")
                    }
                }
                .disabled(isLoading)

                // MARK: - Back to Login
                HStack {
                    Text("Already have an account?")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)

                    Button("Log In") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.accent)
                    .accessibilityLabel("Back to login")
                    .accessibilityHint("Tap to return to the login screen")
                }

                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.large)
        }
    }

    // MARK: - Firebase Registration Logic
    private func registerUser() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return
        }

        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters long."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        isLoading = true

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else if let user = result?.user {
                    self.errorMessage = nil
                    authViewModel.userSession = user
                } else {
                    self.errorMessage = "An unexpected error occurred. Please try again."
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
    RegisterView().environmentObject(AuthViewModel.shared)
}
