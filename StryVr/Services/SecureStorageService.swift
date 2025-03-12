//
//  SecureStorageService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import Security
import os.log

/// Manages secure storage using Apple's Keychain for sensitive user data
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
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]

        SecItemDelete(query as CFDictionary) // Ensure no duplicates
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
}
