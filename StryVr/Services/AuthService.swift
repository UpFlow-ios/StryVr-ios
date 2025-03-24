//
//  AuthService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import FirebaseAuth
import os.log

/// Manages user authentication, login, signup, and password security
final class AuthService {

    static let shared = AuthService()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AuthService")

    private init() {}

    /// Signs up a new user with email & password
    /// - Parameters:
    ///   - email: The email address of the new user.
    ///   - password: The password for the new user.
    ///   - completion: A closure that returns a result containing either the authentication data or an error.
    func signUp(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.logger.error("Sign up error: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let result = result {
                completion(.success(result))
            }
        }
    }

    /// Logs in an existing user
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password of the user.
    ///   - completion: A closure that returns a result containing either the authentication data or an error.
    func logIn(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.logger.error("Log in error: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let result = result {
                completion(.success(result))
            }
        }
    }

    /// Logs out the current user
    /// - Parameter completion: A closure that returns a boolean indicating success or failure, and an optional error.
    func logOut(completion: @escaping (Bool, Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true, nil)
        } catch {
            self.logger.error("Log out error: \(error.localizedDescription)")
            completion(false, error)
        }
    }

    /// Sends a password reset email
    /// - Parameters:
    ///   - email: The email address to send the password reset to.
    ///   - completion: A closure that returns a boolean indicating success or failure, and an optional error.
    func sendPasswordReset(email: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.logger.error("Password reset error: \(error.localizedDescription)")
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }

    /// Retrieves the currently logged-in user
    /// - Returns: The currently logged-in user, or nil if no user is logged in.
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
}
