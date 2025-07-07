//
//  CrashHandlingService.swift
//  StryVr
//
//  Created by Joe Dormond on 4/12/25
//
//  📉 Crash Monitoring Service – FirebaseCrashlytics Integration
//

import FirebaseCrashlytics
import Foundation
import OSLog

final class CrashHandlingService {
    static let shared = CrashHandlingService()
    private let logger = Logger(subsystem: "com.stryvr.app", category: "CrashHandling")

    private init() {}

    /// Log a custom error message to FirebaseCrashlytics
    func log(error: Error, context: String? = nil) {
        let errorDescription = context != nil ? "\(context!): \(error.localizedDescription)" : error.localizedDescription
        Crashlytics.crashlytics().record(error: error)
        logger.error("🧨 Logged error to Crashlytics: \(errorDescription)")
    }

    /// Manually log a non-fatal event for debugging
    func log(message: String) {
        Crashlytics.crashlytics().log(message)
        logger.info("🪵 Crashlytics log: \(message)")
    }

    /// Force a simulated crash (for testing Crashlytics integration)
    func simulateCrash() {
        logger.fault("💥 Simulated crash triggered")
        fatalError("💥 Simulated crash for testing purposes")
    }
}
