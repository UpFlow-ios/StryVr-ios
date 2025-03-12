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

    // MARK: - Secure Storage Methods

    /// Saves a value securely in the Keychain
    /// - Parameters:
    ///   - key: The key under which the value is stored.
    ///   - value: The value to be stored.
    func save(key: String, value: String) {
        guard let data = value.data(using: .utf8) else {
            logger.error("🔴 Failed to convert value to data")
            return
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        if status == errSecSuccess {
            let updateStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            if updateStatus == errSecSuccess {
                logger.info("✅ Successfully updated key: \(key)")
            } else {
                logger.error("🔴 Keychain Update Error (\(key)): \(updateStatus)")
            }
        } else {
            var newQuery = query
            newQuery.merge(attributes) { (_, new) in new }
            let addStatus = SecItemAdd(newQuery as CFDictionary, nil)
            if addStatus == errSecSuccess {
                logger.info("✅ Successfully stored key: \(key)")
            } else {
                logger.error("🔴 Keychain Save Error (\(key)): \(addStatus)")
            }
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

        if status == errSecSuccess, let retrievedData = dataTypeRef as? Data, let result = String(data: retrievedData, encoding: .utf8) {
            logger.info("✅ Successfully retrieved key: \(key)")
            return result
        } else {
            logger.error("🔴 Keychain Retrieve Error (\(key)): \(status)")
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
        if status == errSecSuccess {
            logger.info("✅ Successfully deleted key: \(key)")
        } else {
            logger.error("🔴 Keychain Delete Error (\(key)): \(status)")
        }
    }

    // MARK: - Authentication Token Management

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

    // MARK: - API Key Management

    /// Saves an API key securely
    /// - Parameters:
    ///   - key: API key to store.
    ///   - service: Service name for better identification.
    func saveAPIKey(_ key: String, service: String) {
        save(key: "\(service)_API_KEY", value: key)
    }

    /// Retrieves an API key securely
    /// - Parameter service: Service name for better identification.
    /// - Returns: The API key, or nil if not found.
    func getAPIKey(service: String) -> String? {
        return retrieve(key: "\(service)_API_KEY")
    }

    // MARK: - Biometric Authentication

    /// Authenticates the user with Face ID / Touch ID
    /// - Parameter completion: A closure that returns a boolean indicating success or failure.
    func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        context.localizedReason = "Authenticate to access StryVr securely"
        
        // Check if device supports Face ID / Touch ID
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            logger.error("🔴 Biometric authentication not available: \(error?.localizedDescription ?? "Unknown error")")
            completion(false)
            return
        }

        // Perform authentication
