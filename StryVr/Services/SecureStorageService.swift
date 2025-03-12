//
//  SecureStorageService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import Security
import LocalAuthentication
import os.log

/// Manages secure storage of sensitive data using Apple's Keychain API
final class SecureStorageService {

    static let shared = SecureStorageService()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "SecureStorageService")

    private init() {}

    /// Saves a value securely in the Keychain
    /// - Parameters:
    ///   - key: The key under which the value is stored.
    ///   - value: The value to be stored.
    func save(key: String, value: String) {
        guard let data = value.data(using: .utf8) else {
            logger.error("Failed to convert value to data")
            return
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        SecItemDelete(query as CFDictionary) // Prevent duplicates
        let status = SecItemAdd(query as CFDictionary, nil)

        if status != errSecSuccess {
            logger.error("Keychain Save Error: \(status)")
        }
    }

    /// Retrieves a securely stored value
    /// - Parameter key: The key under which the value is stored.
    /// - Returns: The retrieved value, or nil if not found.
    func retrieve(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let retrievedData = dataTypeRef as? Data {
            return String(data: retrievedData, encoding: .utf8)
        } else {
            logger.error("Keychain Retrieve Error: \(status)")
            return nil
        }
    }

    /// Deletes a value from Keychain
    /// - Parameter key: The key under which the value is stored.
    func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            logger.error("Keychain Delete Error: \(status)")
        }
    }

    /// Saves the authentication token securely
    /// - Parameter token: The authentication token to be stored.
    func saveAuthToken(_ token: String) {
        save(key: "authToken", value: token)
    }

    /// Retrieves the authentication token
    /// - Returns: The retrieved authentication token, or nil if not found.
    func retrieveAuthToken() -> String? {
        return retrieve(key: "authToken")
    }

    /// Deletes the authentication token (Logout)
    func deleteAuthToken() {
        delete(key: "authToken")
    }

    /// Authenticates the user with Face ID / Touch ID
    /// - Parameter completion: A closure that returns a boolean indicating success or failure.
    func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        let reason = "Authenticate to access StryVr securely"

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    completion(true)
                } else {
                    self.logger.error("Biometric Authentication Failed: \(error?.localizedDescription ?? "Unknown error")")
                    completion(false)
