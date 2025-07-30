//
//  StryVrApp.swift
//  StryVr
//
//  🌱 Entry Point with Firebase Setup, Splash Screen, Auth Routing
//

import SwiftUI

#if canImport(Firebase)
    import Firebase
#endif
#if canImport(os)
    import OSLog
#endif

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
                    NavigationStack {
                        if authViewModel.isAuthenticated {
                            HomeView()
                        } else {
                            LoginView()
                        }
                    }
                }
            }
            .environmentObject(authViewModel)
            .animation(.easeInOut, value: authViewModel.isAuthenticated)
        }
    }

    // MARK: - Firebase Setup

    private func configureFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            logger.info("🔥 Firebase configured")
        }
    }

    // MARK: - Splash Transition

    private func handleSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) {
            withAnimation {
                showSplash = false
            }
        }
    }
}
