//
//  SecureStorageService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//  🔐 SecureStorageService – Keychain-based sensitive data handler with biometric authentication support
//
import Foundation
import LocalAuthentication
import Security

#if canImport(os)
    import OSLog
#endif

/// Manages secure storage of sensitive data using Apple's Keychain API
final class SecureStorageService {
    static let shared = SecureStorageService()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "SecureStorageService")

    private init() {}

    // MARK: - Secure Storage Methods

    /// Saves a value securely in the Keychain
    func save(key: String, value: String) {
        guard !key.isEmpty, !value.isEmpty else {
            logger.error("🔴 Invalid key or value provided")
            return
        }

        guard let data = value.data(using: .utf8) else {
            logger.error("🔴 Failed to convert value to data")
            return
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        if status == errSecSuccess {
            let updateStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            if updateStatus == errSecSuccess {
                logger.info("✅ Updated key securely")
            } else {
                logger.error("🔴 Update error, code: \(updateStatus)")
            }
        } else {
            var newQuery = query
            newQuery.merge(attributes) { _, new in new }
            let addStatus = SecItemAdd(newQuery as CFDictionary, nil)
            if addStatus == errSecSuccess {
                logger.info("✅ Saved key securely")
            } else {
                logger.error("🔴 Save error, code: \(addStatus)")
            }
        }
    }

    /// Retrieves a value securely from the Keychain
    func retrieve(key: String) -> String? {
        guard !key.isEmpty else {
            logger.error("🔴 Invalid key provided")
            return nil
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess,
            let retrievedData = dataTypeRef as? Data,
            let result = String(data: retrievedData, encoding: .utf8)
        {
            logger.info("✅ Retrieved key securely")
            return result
        } else {
            logger.error("🔴 Retrieve error, code: \(status)")
            return nil
        }
    }

    /// Deletes a value securely from the Keychain
    func delete(key: String) {
        guard !key.isEmpty else {
            logger.error("🔴 Invalid key provided")
            return
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            logger.info("✅ Deleted key securely")
        } else {
            logger.error("🔴 Delete error, code: \(status)")
        }
    }

    // MARK: - Biometric Authentication

    /// Uses Face ID / Touch ID to validate the user
    func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        context.localizedReason = "Authenticate to access StryVr securely"

        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        else {
            logger.error(
                "🔴 Biometrics unavailable: \(error?.localizedDescription ?? "Unknown error")")
            completion(false)
            return
        }

        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics, localizedReason: context.localizedReason
        ) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.logger.info("✅ Biometric authentication succeeded")
                    completion(true)
                } else {
                    self.logger.error(
                        "❌ Biometric failed: \(error?.localizedDescription ?? "Unknown reason")")
                    completion(false)
                }
            }
        }
    }
}
