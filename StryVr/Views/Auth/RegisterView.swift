//
//  RegisterView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/14/25.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            VStack(spacing: Spacing.large) {
                // MARK: - Title
                Text("Create Your Account")
                    .font(FontStyle.title)
                    .foregroundColor(.whiteText)
                    .padding(.top, Spacing.xLarge)
                    .accessibilityLabel("Create your account")

                // MARK: - Email
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.card)
                    .cornerRadius(10)
                    .foregroundColor(.whiteText)
                    .autocapitalization(.none)
                    .accessibilityLabel("Email field")

                // MARK: - Password
                SecureField("Password", text: $password)
                    .textContentType(.newPassword)
                    .padding()
                    .background(Color.card)
                    .cornerRadius(10)
                    .foregroundColor(.whiteText)
                    .accessibilityLabel("Password field")

                // MARK: - Confirm Password
                SecureField("Confirm Password", text: $confirmPassword)
                    .textContentType(.password)
                    .padding()
                    .background(Color.card)
                    .cornerRadius(10)
                    .foregroundColor(.whiteText)
                    .accessibilityLabel("Confirm password field")

                // MARK: - Error
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(FontStyle.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.medium)
                        .accessibilityLabel("Error message: \(errorMessage)")
                }

                // MARK: - Register Button
                Button(action: registerUser) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .neonBlue))
                            .accessibilityLabel("Loading")
                    } else {
                        Text("Register")
                            .font(FontStyle.body)
                            .foregroundColor(.whiteText)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.neonBlue)
                            .cornerRadius(10)
                            .accessibilityLabel("Register button")
                    }
                }
                .disabled(isLoading)
                .padding(.top, Spacing.medium)

                Spacer()
            }
            .padding(.horizontal, Spacing.large)
        }
    }

    private func registerUser() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
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
}
