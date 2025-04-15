//
//  AuthService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import os.log

/// Handles all authentication operations in the StryVr platform
final class AuthService {
    static let shared = AuthService()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr.app", category: "AuthService")

    private init() {}

    // MARK: - Register New User
    /// Registers a new user with the given email and password
    func signUp(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        guard isValidEmail(email), isValidPassword(password) else {
            self.logger.error("❌ Invalid email or password format")
            completion(.failure(AuthError.invalidInput))
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.logger.error("❌ Sign-up error: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let result = result {
                self.logger.info("✅ User signed up with UID: \(result.user.uid)")
                completion(.success(result))
            }
        }
    }

    // MARK: - Log In
    /// Logs in a user with the given email and password
    func logIn(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        guard isValidEmail(email), isValidPassword(password) else {
            self.logger.error("❌ Invalid email or password format")
            completion(.failure(AuthError.invalidInput))
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.logger.error("❌ Login error: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let result = result {
                self.logger.info("✅ User logged in: \(result.user.uid)")
                completion(.success(result))
            }
        }
    }

    // MARK: - Log Out
    /// Logs out the current user
    func logOut(completion: @escaping (Bool, Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            self.logger.info("🚪 User logged out")
            completion(true, nil)
        } catch {
            self.logger.error("❌ Logout error: \(error.localizedDescription)")
            completion(false, error)
        }
    }

    // MARK: - Reset Password
    /// Sends a password reset email to the given email address
    func sendPasswordReset(email: String, completion: @escaping (Bool, Error?) -> Void) {
        guard isValidEmail(email) else {
            self.logger.error("❌ Invalid email format")
            completion(false, AuthError.invalidInput)
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.logger.error("📩 Password reset failed: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("📬 Password reset email sent")
                completion(true, nil)
            }
        }
    }

    // MARK: - Current User
    /// Returns the currently logged-in user, if any
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }

    /// Checks if a user is currently logged in
    var isUserLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }

    // MARK: - Listener (Optional for real-time auth tracking)
    /// Observes authentication state changes
    func observeAuthStateChange(handler: @escaping (User?) -> Void) {
        Auth.auth().addStateDidChangeListener { _, user in
            handler(user)
        }
    }

    // MARK: - Input Validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}

/// Custom error type for authentication operations
enum AuthError: LocalizedError {
    case invalidInput

    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Invalid email or password format."
        }
    }
}
