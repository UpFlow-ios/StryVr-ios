//
//  AppConfig.swift
//  StryVr
//
//  🌍 Central App Config – Optimized for Environment URLs, API Keys, and Feature Flags
//

import Foundation
import os.log

/// Defines app environments
enum AppEnvironment: String {
    case development = "Development"
    case staging = "Staging"
    case production = "Production"
}

/// Global configuration for the app
struct AppConfig {

    // MARK: - Environment

    /// Set the current running environment here
    static let currentEnvironment: AppEnvironment = .development

    /// Base API URL based on current environment
    static var apiBaseURL: String {
        switch currentEnvironment {
        case .development:
            return "http://192.168.1.234:3000" // 🔧 ← Replace with your current local IP
        case .staging:
            return "https://staging.stryvr.app"
        case .production:
            return "https://api.stryvr.app"
        }
    }

    /// Optional: Unified logger (for debug-only prints)
    static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "AppConfig")

    // MARK: - Feature Flags

    static let enableMockData: Bool = false
    static let enableConfetti: Bool = true
    static let enableAnalytics: Bool = true
    static let enableDeepLinks: Bool = true

    // MARK: - API Paths (Centralize common endpoints)

    struct Endpoints {
        static let skills = "/api/skills"
        static let recommendations = "/api/recommendations"
        static let userProfile = "/api/user"
        static let achievements = "/api/achievements"
        static let challenges = "/api/challenges"
    }

    // MARK: - Utilities

    /// Returns the full API URL for a given path
    static func fullAPIURL(for path: String) -> String {
        return "\(apiBaseURL)\(path)"
    }

    /// Logs current environment
    static func logCurrentEnvironment() {
        #if DEBUG
        logger.info("🚀 Running in \(currentEnvironment.rawValue) environment. Base URL: \(apiBaseURL)")
        #endif
    }
}

