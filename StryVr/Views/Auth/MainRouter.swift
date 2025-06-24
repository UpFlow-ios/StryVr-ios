//
//  MainRouter.swift
//  StryVr
//
//  🚦 Root-level navigation router based on Firebase auth state
//

import SwiftUI

struct MainRouter: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                HomeView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            authViewModel.listenToAuthChanges()
        }
        .animation(.easeInOut, value: authViewModel.isAuthenticated)
    }
}
