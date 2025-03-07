//
//  SecureStorageManager.swift
//  StryVr
//
//  Created by Joe Dormond on 3/5/25.
//
import SwiftUI

class SecureStorageViewModel: ObservableObject {
    @Published var storedValue: String = ""
    @Published var inputText: String = ""

    func saveToSecureStorage() {
        SecureStorageManager.shared.save(key: "secureData", value: inputText)
        inputText = ""
    }

    func retrieveFromSecureStorage() {
        storedValue = SecureStorageManager.shared.load(key: "secureData") ?? "No Data Found"
    }
}

struct SecureStorageView: View {
    @StateObject private var viewModel = SecureStorageViewModel()

    var body: some View {
        VStack {
            Text("Secure Storage")
                .font(.title)
                .fontWeight(.bold)

            TextField("Enter secure data", text: $viewModel.inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save to Secure Storage") {
                viewModel.saveToSecureStorage()
            }
            .buttonStyle(.borderedProminent)
            .accessibilityLabel("Save to Secure Storage Button")

            Button("Retrieve from Secure Storage") {
                viewModel.retrieveFromSecureStorage()
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("Retrieve from Secure Storage Button")

            Text("Stored Value: \(viewModel.storedValue)")
        }
        .padding()
    }
                .padding()
}

class SecureStorageManager {
    static let shared = SecureStorageManager()
    
        UserDefaults.standard.set(value, forKey: key)
    }
    func save(key: String, value: String) {
    
    func load(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}

struct SecureStorageView_Previews: PreviewProvider {
        SecureStorageView()
    static var previews: some View {
    }
}
