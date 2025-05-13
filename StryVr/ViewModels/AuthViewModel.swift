//
//  AuthViewModel.swift
//  StryVr
//
//  🔒 Unified Auth ViewModel – Firebase Auth + Okta, with real-time tracking
//

import Foundation
import FirebaseAuth
import os.log

final class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()

    @Published var userSession: FirebaseAuth.User?
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr.app", category: "AuthViewModel")

    private init() {
        listenToAuthChanges()
    }

    // MARK: - Live Auth State Listener
    func listenToAuthChanges() {
        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                self.userSession = user
                self.isAuthenticated = (user != nil)
                self.logger.info("🔁 Auth state changed: \(self.isAuthenticated ? "✅ Logged In" : "🚪 Logged Out")")
            }
        }
    }

    // MARK: - Email/Password Sign In
    func signIn(email: String, password: String) {
        guard isValidEmail(email), !password.isEmpty else {
            errorMessage = "Please enter a valid email and password."
            logger.error("❌ Sign-in failed: Invalid credentials format")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.handleAuthError(error)
                    return
                }

                guard let user = result?.user else {
                    self?.errorMessage = "An unknown error occurred."
                    self?.logger.error("❌ Sign-in failed: No user returned")
                    return
                }

                self?.userSession = user
                self?.errorMessage = nil
                self?.isAuthenticated = true
                self?.logger.info("✅ Email login: \(user.email ?? "unknown")")
            }
        }
    }

    // MARK: - Register
    func createUser(email: String, password: String) {
        guard isValidEmail(email), !password.isEmpty else {
            errorMessage = "Please enter a valid email and password."
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.handleAuthError(error)
                    return
                }

                guard let user = result?.user else {
                    self?.errorMessage = "Sign-up failed. Try again."
                    return
                }

                self?.userSession = user
                self?.errorMessage = nil
                self?.isAuthenticated = true
                self?.logger.info("✅ User signed up: \(user.email ?? "unknown")")
            }
        }
    }

    // MARK: - Password Reset
    func resetPassword(email: String) {
        guard isValidEmail(email) else {
            errorMessage = "Enter a valid email address."
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.handleAuthError(error)
                } else {
                    self?.errorMessage = "Password reset email sent."
                    self?.logger.info("📧 Reset email sent")
                }
            }
        }
    }

    // MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.userSession = nil
                self.isAuthenticated = false
                self.errorMessage = nil
                self.logger.info("🚪 User signed out")
            }
        } catch {
            self.errorMessage = "Failed to sign out: \(error.localizedDescription)"
            self.logger.error("❌ Sign-out failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^\S+@\S+\.\S+$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func handleAuthError(_ error: Error) {
        let nsError = error as NSError
        let code = AuthErrorCode.Code(rawValue: nsError.code)

        switch code {
        case .wrongPassword: errorMessage = "Incorrect password."
        case .userNotFound: errorMessage = "No account found. Please sign up."
        case .emailAlreadyInUse: errorMessage = "Email is already registered."
        case .networkError: errorMessage = "Network error. Try again."
        default: errorMessage = "Error: \(error.localizedDescription)"
        }

        logger.error("❌ FirebaseAuth error: \(error.localizedDescription)")
    }
}
