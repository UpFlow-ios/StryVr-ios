//
//  AuthManager.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25
//
//  🔐 Auth Manager – Handles MFA (email & SMS) and secure session management
//
import CryptoKit
#if canImport(FirebaseAuth)
import FirebaseAuth
#endif
#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif
import Foundation
#if canImport(os)
import OSLog
#endif

/// Manages authentication, MFA, and session security in StryVr
final class AuthManager {
    static let shared = AuthManager()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "AuthManager")

    private init() {}

    // MARK: - Send Email Verification (MFA)

    /// Sends an email verification for MFA
    func sendMFAVerificationEmail(completion: @escaping (Bool, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false, AuthError.userNotAuthenticated)
            return
        }

        user.sendEmailVerification { error in
            if let error = error {
                self.logger.error("📩 MFA email error: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("✅ MFA email sent")
                completion(true, nil)
            }
        }
    }

    // MARK: - Send SMS for MFA

    /// Sends an SMS verification code for MFA
    func sendMFAVerificationSMS(phoneNumber: String, completion: @escaping (Bool, Error?) -> Void) {
        guard !phoneNumber.isEmpty else {
            logger.error("❌ Invalid phone number")
            completion(false, AuthError.invalidInput)
            return
        }

        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                self.logger.error("📲 MFA SMS error: \(error.localizedDescription)")
                completion(false, error)
            } else if let verificationID = verificationID {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.logger.info("✅ MFA SMS code sent")
                completion(true, nil)
            }
        }
    }

    // MARK: - Confirm SMS Code (MFA Login)

    /// Confirms the SMS verification code for MFA login
    func confirmMFACode(_ code: String, completion: @escaping (Bool, Error?) -> Void) {
        guard !code.isEmpty else {
            logger.error("❌ Invalid verification code")
            completion(false, AuthError.invalidInput)
            return
        }

        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            logger.error("❌ Verification ID not available")
            completion(false, AuthError.verificationIDNotFound)
            return
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)

        Auth.auth().signIn(with: credential) { _, error in
            if let error = error {
                self.logger.error("❌ MFA code confirmation failed: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("🔐 MFA login successful")
                completion(true, nil)
            }
        }
    }
}

// MARK: - Custom Error Type

enum AuthError: LocalizedError {
    case userNotAuthenticated
    case invalidInput
    case verificationIDNotFound

    var errorDescription: String? {
        switch self {
        case .userNotAuthenticated:
            return "User not authenticated."
        case .invalidInput:
            return "Invalid input provided."
        case .verificationIDNotFound:
            return "Verification ID not found."
        }
    }
}
