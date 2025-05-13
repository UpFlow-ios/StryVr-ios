//
//  RegisterView.swift
//  StryVr
//
//  🔐 Secure, Themed, Firebase-Integrated Account Creation
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    @State private var showSuccess = false

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.large) {
                Text("Create Account")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.top, Theme.Spacing.xLarge)

                // MARK: - Email + Password Inputs
                Group {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Theme.Colors.card)
                        .cornerRadius(Theme.CornerRadius.medium)

                    SecureField("Password", text: $password)
                        .textContentType(.newPassword)
                        .padding()
                        .background(Theme.Colors.card)
                        .cornerRadius(Theme.CornerRadius.medium)

                    SecureField("Confirm Password", text: $confirmPassword)
                        .textContentType(.password)
                        .padding()
                        .background(Theme.Colors.card)
                        .cornerRadius(Theme.CornerRadius.medium)
                }

                // MARK: - Error Feedback
                if let error = errorMessage {
                    Text(error)
                        .font(Theme.Typography.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.medium)
                }

                // MARK: - Register Button
                Button(action: registerUser) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                    } else {
                        Text("Register")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.whiteText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.Colors.accent)
                            .cornerRadius(Theme.CornerRadius.medium)
                    }
                }
                .disabled(isLoading)

                // MARK: - Already have an account?
                HStack {
                    Text("Already have an account?")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)

                    Button("Log In") {
                        simpleHaptic()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.accent)
                }

                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.large)
        }
    }

    // MARK: - Register User Logic
    private func registerUser() {
        errorMessage = nil
        simpleHaptic()

        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return
        }

        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        isLoading = true

        AuthService.shared.signUp(email: email, password: password) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    showSuccess = true
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
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
