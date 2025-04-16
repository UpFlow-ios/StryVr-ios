//
//  AuthViewModel.swift
//  StryVr
//
//  Created by Joe Dormond on 3/24/25.
//  🔒 Optimized for Security, Performance, and Maintainability
//

import Foundation
import FirebaseAuth
import os.log

final class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()

    @Published var userSession: FirebaseAuth.User?
    @Published var errorMessage: String?

    private init() {
        self.userSession = Auth.auth().currentUser
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) {
        guard isValidEmail(email), !password.isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = "Please enter a valid email and password."
            }
            os_log("❌ Sign-in failed: Invalid credentials format", log: .default, type: .error)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.handleAuthError(error)
                    return
                }

                guard let user = result?.user else {
                    self?.errorMessage = "An unknown error occurred. Please try again."
                    os_log("❌ Sign-in failed: No user returned", log: .default, type: .error)
                    return
                }

                self?.userSession = user
                self?.errorMessage = nil
                os_log("✅ User signed in: %{public}@", log: .default, type: .info, user.email ?? "unknown")
            }
        }
    }

    // MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.userSession = nil
                self.errorMessage = nil
                os_log("🚪 User signed out successfully", log: .default, type: .info)
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to sign out: \(error.localizedDescription)"
            }
            os_log("❌ Sign-out failed: %{public}@", log: .default, type: .error, error.localizedDescription)
        }
    }

    // MARK: - Helper Methods
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^\S+@\S+\.\S+$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func handleAuthError(_ error: Error) {
        let nsError = error as NSError
        let errorCode = AuthErrorCode.Code(rawValue: nsError.code)
        DispatchQueue.main.async {
            switch errorCode {
            case .wrongPassword:
                self.errorMessage = "Incorrect password. Please try again."
            case .userNotFound:
                self.errorMessage = "No account found with this email. Please sign up."
            case .networkError:
                self.errorMessage = "Network error. Check your internet connection."
            default:
                self.errorMessage = "An error occurred: \(error.localizedDescription)"
            }
        }
        os_log("❌ Authentication error: %{public}@", log: .default, type: .error, error.localizedDescription)
    }
}
