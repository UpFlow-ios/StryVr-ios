//
//  AuthenticationProtocol.swift
//  StryVr
//
//  🔐 Authentication Protocol – Abstracted interface for authentication services
//

import Foundation
import FirebaseAuth

/// Protocol defining authentication service operations used in StryVr
protocol AuthenticationProtocol {
    /// Current authenticated user
    var currentUser: User? { get }
    
    /// Whether a user is currently authenticated
    var isUserLoggedIn: Bool { get }
    
    /// Sign up with email and password
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<AuthDataResult, Error>) -> Void
    )
    
    /// Sign in with email and password
    func logIn(
        email: String,
        password: String,
        completion: @escaping (Result<AuthDataResult, Error>) -> Void
    )
    
    /// Sign out current user
    func logOut(completion: @escaping (Bool, Error?) -> Void)
    
    /// Send password reset email
    func sendPasswordReset(
        email: String,
        completion: @escaping (Bool, Error?) -> Void
    )
    
    /// Observe authentication state changes
    func observeAuthStateChange(handler: @escaping (User?) -> Void)
} 