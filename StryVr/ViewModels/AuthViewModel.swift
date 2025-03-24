//
//  AuthViewModel.swift
//  StryVr
//
//  Created by Joe Dormond on 3/24/25.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func login() {
        // Simulate an authentication process
        if username == "user" && password == "password" {
            isAuthenticated = true
            errorMessage = nil
        } else {
            isAuthenticated = false
            errorMessage = "Invalid username or password"
        }
    }

    func logout() {
        isAuthenticated = false
        username = ""
        password = ""
    }
}
