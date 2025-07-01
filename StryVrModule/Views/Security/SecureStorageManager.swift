//
//  SecureStorageManager.swift
//  StryVr
//
//  Created by Joseph Dormond on 4/15/25.
//  🔐 SecureStorageManager & View – Keychain-backed persistence with MVVM architecture
//

#if canImport(os)
import os.log
#endif
import Security
import SwiftUI

// MARK: - SecureStorageError

enum SecureStorageError: Error, LocalizedError {
    case dataConversionFailed
    case saveFailed(OSStatus)
    case loadFailed(OSStatus)

    var errorDescription: String? {
        switch self {
        case .dataConversionFailed:
            return "Data conversion failed."
        case let .saveFailed(status):
            return "Save failed with status: \(status)."
        case let .loadFailed(status):
            return "Load failed with status: \(status)."
        }
    }
}

// MARK: - SecureStorageManager

final class SecureStorageManager {
    static let shared = SecureStorageManager()

    private init() {}

    func save(key: String, value: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw SecureStorageError.dataConversionFailed
        }

        SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
        ] as CFDictionary)

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            os_log("🔒 Keychain save error %{public}@ - Status: %{public}d", key, status)
            throw SecureStorageError.saveFailed(status)
        }

        os_log("🔒 Keychain save succeeded for key: %{public}@", key)
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
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8)
        else {
            os_log("🔒 Keychain load error %{public}@ - Status: %{public}d", key, status)
            throw SecureStorageError.loadFailed(status)
        }

        os_log("🔒 Keychain load succeeded for key: %{public}@", key)

        return value
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
