//
//  AuthViewModel.swift
//  StryVr
//
//  Created by Joe Dormond on 3/24/25.
//

import Foundation
import FirebaseAuth
import os.log

class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()

    @Published var userSession: FirebaseAuth.User?
    @Published var errorMessage: String?

    private init() {
        self.userSession = Auth.auth().currentUser
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    os_log("❌ Sign-in failed: %{public}@", log: .default, type: .error, error.localizedDescription)
                    return
                }

                guard let user = result?.user else {
                    self?.errorMessage = "Unexpected error occurred during sign-in."
                    os_log("❌ Sign-in failed: Unexpected error", log: .default, type: .error)
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
                os_log("🚪 User signed out", log: .default, type: .info)
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to sign out: \(error.localizedDescription)"
            }
            os_log("❌ Sign-out error: %{public}@", log: .default, type: .error, error.localizedDescription)
        }
    }
} 
