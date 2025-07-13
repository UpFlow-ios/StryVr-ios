//
//  AuthService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25
//
//  🔐 Auth Service – Handles Firebase Email/Password Auth and Okta OIDC Integration
//

import AppAuth
import FirebaseAuth
import Foundation
import OSLog

final class AuthService: ObservableObject {
    static let shared = AuthService()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr.app", category: "AuthService")

    // MARK: - Firebase Email/Password Auth

    private init() {}

    func signUp(
        email: String, password: String,
        completion: @escaping (Result<AuthDataResult, Error>) -> Void
    ) {
        guard isValidEmail(email), isValidPassword(password) else {
            logger.error("❌ Invalid email or password format: Signup input validation failed")
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

    func logIn(
        email: String, password: String,
        completion: @escaping (Result<AuthDataResult, Error>) -> Void
    ) {
        guard isValidEmail(email), isValidPassword(password) else {
            logger.error("❌ Invalid email or password format: Login input validation failed")
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

    func logOut(completion: @escaping (Bool, Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            logger.info("🚪 User logged out")
            completion(true, nil)
        } catch {
            logger.error("❌ Logout error: \(error.localizedDescription)")
            completion(false, error)
        }
    }

    func sendPasswordReset(email: String, completion: @escaping (Bool, Error?) -> Void) {
        guard isValidEmail(email) else {
            logger.error("❌ Invalid email format: Password reset input validation failed")
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

    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }

    var isUserLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }

    func observeAuthStateChange(handler: @escaping (User?) -> Void) {
        Auth.auth().addStateDidChangeListener { _, user in
            handler(user)
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    // MARK: - Okta OIDC via AppAuth

    private var currentAuthorizationFlow: OIDExternalUserAgentSession?
    private var authState: OIDAuthState?

    // ✅ Replace with your Okta values:
    private let clientID = "YOUR_OKTA_CLIENT_ID"
    private let issuer = URL(string: "https://YOUR_OKTA_DOMAIN.okta.com/oauth2/default")!
    private let redirectURI = URL(string: "stryvr://callback")!

    func loginWithOkta(presentingViewController: UIViewController) {
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { config, error in
            guard let config = config else {
                self.logger.error(
                    "❌ OIDC discovery failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let request = OIDAuthorizationRequest(
                configuration: config,
                clientId: self.clientID,
                scopes: [OIDScopeOpenID, OIDScopeProfile, "email"],
                redirectURL: self.redirectURI,
                responseType: OIDResponseTypeCode,
                additionalParameters: nil
            )

            self.currentAuthorizationFlow = OIDAuthState.authState(
                byPresenting: request,
                presenting: presentingViewController
            ) { authState, error in
                if let authState = authState {
                    self.logger.info("✅ Okta Auth successful")
                    self.authState = authState
                    self.handleFirebaseOIDCLogin(authState)
                } else {
                    self.logger.error(
                        "❌ Okta Auth error: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }

    private func handleFirebaseOIDCLogin(_ authState: OIDAuthState) {
        guard let idToken = authState.lastTokenResponse?.idToken else {
            logger.error("❌ Missing ID Token from Okta")
            return
        }

        Auth.auth().signIn(withCustomToken: idToken) { _, error in
            if let error = error {
                self.logger.error(
                    "❌ Firebase sign-in failed: \(error.localizedDescription)")
            } else {
                self.logger.info("✅ Logged into Firebase with Okta token")
            }
        }
    }

    func resumeAuthFlow(_ url: URL) -> Bool {
        if let flow = currentAuthorizationFlow,
            flow.resumeExternalUserAgentFlow(with: url)
        {
            currentAuthorizationFlow = nil
            return true
        }
        return false
    }
}
