//
//  StryVrApp.swift
//  StryVr
//
//  🌱 Entry Point with Firebase Setup, Splash Screen, Auth Routing
//

import SwiftUI
import Firebase
import os

@main
struct StryVrApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject private var authViewModel = AuthViewModel.shared
    @State private var showSplash = true
    private let splashDuration: TimeInterval = 2.0
    private let logger = Logger(subsystem: "com.stryvr.app", category: "AppLifecycle")

    init() {
        configureFirebase()
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashScreenView()
                        .onAppear(perform: handleSplash)
                } else {
                    if authViewModel.isAuthenticated {
                        HomeView()
                    } else {
                        LoginView()
                    }
                }
            }
            .environmentObject(authViewModel)
            .animation(.easeInOut, value: authViewModel.isAuthenticated)
        }
    }

    private func configureFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            logger.info("🔥 Firebase configured")
        }
    }

    private func handleSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) {
            withAnimation {
                showSplash = false
            }
        }
    }
}
