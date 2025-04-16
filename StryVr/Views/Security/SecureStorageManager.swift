//
//  SecureStorageView.swift
//  StryVr
//
//  Created by Joseph Dormond on 4/15/25.
//  🔒 Optimized for Security & Scalability
//

import SwiftUI
import Security
import os.log

// MARK: - SecureStorageManager (Keychain-based)

final class SecureStorageManager {

    static let shared = SecureStorageManager()

    private init() {}

    func save(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }

        // Delete existing item first to prevent duplicates
        SecItemDelete([kSecClass: kSecClassGenericPassword,
                       kSecAttrAccount: key] as CFDictionary)

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            os_log("🔒 SecureStorageManager - Save failed with status: %{public}d", status)
        }

        return status == errSecSuccess
    }

    func load(key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status != errSecSuccess {
            os_log("🔒 SecureStorageManager - Load failed with status: %{public}d", status)
        }

        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }

        return value
    }
}

// MARK: - SecureStorageViewModel

final class SecureStorageViewModel: ObservableObject {
    @Published var storedValue: String = "No Data Found"
    @Published var inputText: String = ""

    func saveToSecureStorage() {
        DispatchQueue.global(qos: .userInitiated).async {
            let success = SecureStorageManager.shared.save(key: "secureData", value: self.inputText)
            DispatchQueue.main.async {
                if success {
                    self.storedValue = "Data Saved Successfully ✅"
                    self.inputText = ""
                } else {
                    self.storedValue = "Failed to Save Data 🚨"
                }
            }
        }
    }

    func retrieveFromSecureStorage() {
        DispatchQueue.global(qos: .userInitiated).async {
            let value = SecureStorageManager.shared.load(key: "secureData") ?? "No Data Found"
            DispatchQueue.main.async {
                self.storedValue = value
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
        SecureStorageView()
            .preferredColorScheme(.light)

        SecureStorageView()
            .preferredColorScheme(.dark)
    }
}
