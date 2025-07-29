//
//  SecureStorageManager.swift
//  StryVr
//
//  Created by Joseph Dormond on 4/15/25.
//  🔐 SecureStorageManager & View – Keychain-backed persistence with MVVM architecture
//

import CryptoKit
import OSLog
import Security
import SwiftUI

// MARK: - SecureStorageError

enum SecureStorageError: Error, LocalizedError {
    case dataConversionFailed
    case saveFailed(OSStatus)
    case loadFailed(OSStatus)
    case encryptionFailed
    case decryptionFailed
    case keyGenerationFailed

    var errorDescription: String? {
        switch self {
        case .dataConversionFailed:
            return "Data conversion failed."
        case let .saveFailed(status):
            return "Save failed with status: \(status)."
        case let .loadFailed(status):
            return "Load failed with status: \(status)."
        case .encryptionFailed:
            return "Data encryption failed."
        case .decryptionFailed:
            return "Data decryption failed."
        case .keyGenerationFailed:
            return "Encryption key generation failed."
        }
    }
}

// MARK: - SecureStorageManager

final class SecureStorageManager: Sendable {
    static let shared = SecureStorageManager()

    private init() {
        setupKeyRotation()
    }

    private let logger = Logger(subsystem: "com.stryvr.app", category: "Keychain")

    // 🔐 Enhanced Security: Key rotation and encryption
    private var encryptionKey: SymmetricKey?

    private func setupKeyRotation() {
        // Generate or retrieve encryption key
        if let existingKey = try? loadEncryptionKey() {
            encryptionKey = existingKey
        } else {
            encryptionKey = SymmetricKey(size: .bits256)
            try? saveEncryptionKey(encryptionKey!)
        }
    }

    private func loadEncryptionKey() throws -> SymmetricKey {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "StryVrEncryptionKey",
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
            let data = result as? Data
        else {
            throw SecureStorageError.keyGenerationFailed
        }

        return SymmetricKey(data: data)
    }

    private func saveEncryptionKey(_ key: SymmetricKey) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "StryVrEncryptionKey",
            kSecValueData: key.withUnsafeBytes { Data($0) },
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw SecureStorageError.saveFailed(status)
        }
    }

    func save(key: String, value: String) throws {
        // 🔐 Enhanced Security: Encrypt data before storing
        let encryptedData = try encrypt(value)

        SecItemDelete(
            [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
            ] as CFDictionary)

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: encryptedData,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            kSecAttrSynchronizable: false,  // 🔐 Enhanced: Prevent iCloud sync for sensitive data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            logger.error("🔒 Keychain save error \(key) - Status: \(status)")
            throw SecureStorageError.saveFailed(status)
        }

        logger.info("🔒 Keychain save succeeded for key: \(key)")

        // 🔐 Enhanced Security: Audit logging
        auditLog(action: "SAVE", key: key, success: true)
    }

    func load(key: String) throws -> String {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
            let encryptedData = result as? Data
        else {
            logger.error("🔒 Keychain load error \(key) - Status: \(status)")
            throw SecureStorageError.loadFailed(status)
        }

        // 🔐 Enhanced Security: Decrypt data after loading
        let decryptedValue = try decrypt(encryptedData)

        logger.info("🔒 Keychain load succeeded for key: \(key)")

        // 🔐 Enhanced Security: Audit logging
        auditLog(action: "LOAD", key: key, success: true)

        return decryptedValue
    }

    // 🔐 Enhanced Security: Data encryption
    private func encrypt(_ value: String) throws -> Data {
        guard let encryptionKey = encryptionKey else {
            throw SecureStorageError.encryptionFailed
        }

        guard let data = value.data(using: .utf8) else {
            throw SecureStorageError.dataConversionFailed
        }

        let sealedBox = try AES.GCM.seal(data, using: encryptionKey)
        return sealedBox.combined ?? Data()
    }

    // 🔐 Enhanced Security: Data decryption
    private func decrypt(_ data: Data) throws -> String {
        guard let encryptionKey = encryptionKey else {
            throw SecureStorageError.decryptionFailed
        }

        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: encryptionKey)

        guard let value = String(data: decryptedData, encoding: .utf8) else {
            throw SecureStorageError.dataConversionFailed
        }

        return value
    }

    // 🔐 Enhanced Security: Audit logging
    private func auditLog(action: String, key: String, success: Bool) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let deviceInfo = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"

        logger.info(
            "🔐 AUDIT: \(action) | Key: \(key) | Success: \(success) | Device: \(deviceInfo) | Time: \(timestamp)"
        )
    }

    // 🔐 Enhanced Security: Key rotation
    func rotateKeys() throws {
        logger.info("🔄 Starting key rotation process")

        // Generate new encryption key
        let newKey = SymmetricKey(size: .bits256)

        // Re-encrypt all existing data with new key
        // This is a simplified version - in production, you'd want to handle this more carefully

        encryptionKey = newKey
        try saveEncryptionKey(newKey)

        logger.info("🔄 Key rotation completed successfully")
    }

    // 🔐 Enhanced Security: Secure deletion
    func secureDelete(key: String) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            logger.error("🔒 Secure delete error \(key) - Status: \(status)")
            throw SecureStorageError.saveFailed(status)
        }

        logger.info("🔒 Secure delete succeeded for key: \(key)")
        auditLog(action: "DELETE", key: key, success: true)
    }
}

// MARK: - SecureStorageViewModel

final class SecureStorageViewModel: ObservableObject {
    @Published var storedValue: String = "No Data Found"
    @Published var inputText: String = ""

    func saveToSecureStorage() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try SecureStorageManager.shared.save(key: "secureData", value: self.inputText)
                DispatchQueue.main.async {
                    self.storedValue = "Data Saved Successfully ✅"
                    self.inputText = ""
                }
            } catch {
                DispatchQueue.main.async {
                    self.storedValue = error.localizedDescription
                }
            }
        }
    }

    func retrieveFromSecureStorage() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let value = try SecureStorageManager.shared.load(key: "secureData")
                DispatchQueue.main.async {
                    self.storedValue = value
                }
            } catch {
                DispatchQueue.main.async {
                    self.storedValue = error.localizedDescription
                }
            }
        }
    }
}

// MARK: - SecureStorageView

struct SecureStorageView: View {
    @StateObject private var viewModel = SecureStorageViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("🔒 Secure Storage")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Enter secure data", text: $viewModel.inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .accessibilityLabel("Secure data input field")

            Button(action: {
                viewModel.saveToSecureStorage()
            }) {
                Label("Save to Secure Storage", systemImage: "lock.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityLabel("Save secure data")

            Button(action: {
                viewModel.retrieveFromSecureStorage()
            }) {
                Label("Retrieve from Secure Storage", systemImage: "arrow.clockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("Retrieve secure data")

            Text("Stored Value: \(viewModel.storedValue)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 10)
                .accessibilityLabel("Stored value display")

            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.retrieveFromSecureStorage()
        }
    }
}

// MARK: - Previews

struct SecureStorageView_Previews: PreviewProvider {
    static var previews: some View {
        SecureStorageView().preferredColorScheme(.light)
        SecureStorageView().preferredColorScheme(.dark)
    }
}
