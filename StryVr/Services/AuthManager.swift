//
//  AuthManager.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore
import os.log

/// Manages authentication, MFA, and session security in StryVr
final class AuthManager {

    static let shared = AuthManager()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AuthManager")

    private init() {}

    /// Sends a multi-factor authentication (MFA) verification email
    /// - Parameter completion: A closure that returns a boolean indicating success or failure, and an optional error.
    func sendMFAVerificationEmail(completion: @escaping (Bool, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false, NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }

        user.sendEmailVerification { error in
            if let error = error {
                self.logger.error("MFA Email Error: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("MFA Verification Email Sent")
                completion(true, nil)
            }
        }
    }

    /// Sends a multi-factor authentication (MFA) verification SMS
    /// - Parameters:
    ///   - phoneNumber: The phone number to send the verification SMS to.
    ///   - completion: A closure that returns a boolean indicating success or failure, and an optional error.
    func sendMFAVerificationSMS(phoneNumber: String, completion: @escaping (Bool, Error?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                self.logger.error("MFA SMS Error: \(error.localizedDescription)")
                completion(false, error)
            } else if let verificationID = verificationID {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.logger.info("MFA SMS Verification Code Sent")
                completion(true, nil)
            }
        }
    }

    /// Confirms MFA code for phone authentication
    /// - Parameters:
    ///   - code: The verification code received via SMS.
    ///   - completion: A closure that returns a boolean indicating success or failure, and an optional error.
    func confirmMFACode(_ code: String, completion: @escaping (Bool, Error?) -> Void) {

