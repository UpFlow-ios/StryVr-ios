//
//  StryVrApp.swift
//  StryVr
//
//  Created by Joe Dormond on 3/5/25.
//  🌱 App Entry Point with Firebase, Splash, and Auth Routing
//

import SwiftUI
import Firebase
import os

@main
struct StryVrApp: App {
    
    // MARK: - AppDelegate Integration
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // MARK: - Global State
    @StateObject private var authViewModel = AuthViewModel.shared
    @State private var showSplash = true
    
    // MARK: - Constants
    private let splashDuration: TimeInterval = 2.0
    private let logger = Logger(subsystem: "com.stryvr.app", category: "AppLifecycle")
    
    init() {
        configureFirebase()
    }
    
    var body: some Scene {
        WindowGroup {
            contentView
                .environmentObject(authViewModel)
        }
    }
    
    // MARK: - Views
    private var contentView: some View {
        Group {
            if showSplash {
                SplashScreenView()
                    .onAppear(perform: handleSplash)
            } else {
                if authViewModel.userSession != nil {
                    HomeView()
                } else {
                    LoginView()
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func configureFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            logger.info("🔥 Firebase configured successfully")
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
