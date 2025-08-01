//
//  AuthViewModel.swift
//  StryVr
//
//  🔒 Fully Optimized Auth ViewModel with Enhanced Error Handling, Firebase Auth Integration, Real-Time Updates
//

import FirebaseAuth
import Foundation
import OSLog

@MainActor
final class AuthViewModel: ObservableObject {
    @MainActor static let shared = AuthViewModel()

    @Published private(set) var userSession: FirebaseAuth.User?
    @Published private(set) var errorMessage: String?
    @Published private(set) var isAuthenticated: Bool = false

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr.app", category: "AuthViewModel")
    private var authListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        configureAuthListener()
    }

    deinit {
        removeAuthListener()
    }

    // MARK: - Auth State Listener

    private func configureAuthListener() {
        authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.userSession = user
                self?.isAuthenticated = (user != nil)
                self?.logger.info(
                    "🔁 Auth state changed: \(self?.isAuthenticated == true ? "✅ Logged In" : "🚪 Logged Out")"
                )
            }
        }
    }

    func listenToAuthChanges() {
        // Auth listener is already configured in init(), this method exists for compatibility
        logger.info("🔁 Auth listener already active")
    }

    private func removeAuthListener() {
        if let handle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: - Email Sign In

    func signIn(email: String, password: String) {
        guard validate(email: email, password: password) else { return }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.processAuthError(error)
                    return
                }

                guard let user = result?.user else {
                    self?.updateError("An unknown sign-in error occurred.")
                    return
                }

                self?.updateAuthSuccess(user: user, action: "Sign-in")
            }
        }
    }

    // MARK: - User Registration

    func createUser(email: String, password: String) {
        guard validate(email: email, password: password) else { return }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.processAuthError(error)
                    return
                }

                guard let user = result?.user else {
                    self?.updateError("An unknown registration error occurred.")
                    return
                }

                self?.updateAuthSuccess(user: user, action: "Registration")
            }
        }
    }

    // MARK: - Password Reset

    func resetPassword(email: String) {
        guard isValidEmail(email) else {
            updateError("Enter a valid email address.")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.processAuthError(error)
                    return
                }

                self?.updateError("Password reset email sent. Check your inbox.")
                self?.logger.info("📧 Password reset initiated for \(email)")
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
                self.logger.info("🚪 User signed out successfully")
            }
        } catch {
            processAuthError(error)
        }
    }

    // MARK: - Registration (for use in RegisterView)
    func register(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, error)
                } else if result?.user != nil {
                    completion(true, nil)
                } else {
                    completion(false, NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown registration error"]))
                }
            }
        }
    }

    // MARK: - Validation & Helpers

    private func validate(email: String, password: String) -> Bool {
        guard isValidEmail(email), !password.isEmpty else {
            updateError("Please provide a valid email and password.")
            return false
        }
        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }

    private func updateAuthSuccess(user: FirebaseAuth.User, action: String) {
        userSession = user
        isAuthenticated = true
        errorMessage = nil
        logger.info("✅ \(action) successful for user: \(user.email ?? "unknown")")
    }

    private func updateError(_ message: String) {
        errorMessage = message
        logger.error("❌ Auth error: \(message)")
    }

    private func processAuthError(_ error: Error) {
        let nsError = error as NSError
        let code = AuthErrorCode.Code(rawValue: nsError.code)

        switch code {
        case .wrongPassword: updateError("Incorrect password. Please try again.")
        case .userNotFound: updateError("User not found. Consider signing up.")
        case .emailAlreadyInUse: updateError("Email already in use. Try logging in.")
        case .invalidEmail: updateError("Invalid email format.")
        case .networkError: updateError("Network error. Please check your connection.")
        default: updateError(error.localizedDescription)
        }

        logger.error("❌ FirebaseAuth detailed error: \(error.localizedDescription)")
    }
}

extension AuthViewModel {
    static var previewMock: AuthViewModel {
        let viewModel = AuthViewModel()
        // Note: In a real preview, we would need to mock FirebaseAuth.User
        // For now, we'll just return the viewModel without setting userSession
        // as FirebaseAuth.User cannot be easily mocked in previews
        return viewModel
    }
}
