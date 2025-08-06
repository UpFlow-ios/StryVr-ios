//
//  StryVrApp.swift
//  StryVr
//
//  🌱 Entry Point with Firebase Setup, Splash Screen, Auth Routing
//

import Firebase
import OSLog
import SwiftUI

@main
struct StryVrApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject private var authViewModel = AuthViewModel.shared
    @StateObject private var performanceMonitor = PerformanceMonitor.shared
    @StateObject private var router = AppRouter()
    @State private var showSplash = true
    private let splashDuration: TimeInterval = 2.0
    private let logger = Logger(subsystem: "com.stryvr.app", category: "AppLifecycle")

    init() {
        configureFirebase()
        setupPerformanceMonitoring()
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashScreenView()
                        .onAppear(perform: handleSplash)
                } else {
                    NavigationRootView()
                        .environmentObject(router)
                        .environmentObject(authViewModel)
                }
            }
            .animation(.easeInOut, value: authViewModel.isAuthenticated)
            .onOpenURL { url in
                router.handleDeepLink(url: url)
            }
        }
    }

    // MARK: - Firebase Setup

    private func configureFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            logger.info("🔥 Firebase configured")
        }
    }

    // MARK: - Performance Monitoring

    private func setupPerformanceMonitoring() {
        performanceMonitor.startAppLaunch()
        logger.info("📊 Performance monitoring initialized")
    }

    // MARK: - Splash Transition

    private func handleSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) {
            withAnimation {
                showSplash = false
                performanceMonitor.endAppLaunch()
            }
        }
    }
}
