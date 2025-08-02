//
//  ErrorHandlingProtocol.swift
//  StryVr
//
//  🛡️ Error Handling Protocol – Abstracted interface for error management
//

import Foundation
import OSLog

/// Protocol defining error handling operations used in StryVr
protocol ErrorHandlingProtocol {
    /// Handle and log errors
    func handleError(_ error: Error, context: String)

    /// Handle and log network errors
    func handleNetworkError(_ error: Error, endpoint: String)

    /// Handle and log authentication errors
    func handleAuthError(_ error: Error, action: String)

    /// Handle and log data errors
    func handleDataError(_ error: Error, operation: String)

    /// Show user-friendly error message
    func showUserError(_ message: String, title: String)

    /// Log error to analytics
    func logErrorToAnalytics(_ error: Error, context: String)

    /// Check if error is recoverable
    func isRecoverable(_ error: Error) -> Bool

    /// Attempt error recovery
    func attemptRecovery(for error: Error, completion: @escaping (Bool) -> Void)
}

/// Default implementation for error handling
extension ErrorHandlingProtocol {
    func handleError(_ error: Error, context: String) {
        let logger = Logger(subsystem: "com.stryvr.app", category: "ErrorHandling")
        logger.error("❌ Error in \(context): \(error.localizedDescription)")
        logErrorToAnalytics(error, context: context)
    }

    func handleNetworkError(_ error: Error, endpoint: String) {
        let logger = Logger(subsystem: "com.stryvr.app", category: "NetworkError")
        logger.error("🌐 Network error for \(endpoint): \(error.localizedDescription)")
        logErrorToAnalytics(error, context: "Network: \(endpoint)")
    }

    func handleAuthError(_ error: Error, action: String) {
        let logger = Logger(subsystem: "com.stryvr.app", category: "AuthError")
        logger.error("🔐 Auth error during \(action): \(error.localizedDescription)")
        logErrorToAnalytics(error, context: "Auth: \(action)")
    }

    func handleDataError(_ error: Error, operation: String) {
        let logger = Logger(subsystem: "com.stryvr.app", category: "DataError")
        logger.error("📊 Data error during \(operation): \(error.localizedDescription)")
        logErrorToAnalytics(error, context: "Data: \(operation)")
    }

    func showUserError(_ message: String, title: String) {
        // Default implementation - can be overridden
        let logger = Logger(subsystem: "com.stryvr.app", category: "UserError")
        logger.error("👤 User error: \(title) - \(message)")
    }

    func logErrorToAnalytics(_ error: Error, context: String) {
        // Default implementation - can be overridden
        let logger = Logger(subsystem: "com.stryvr.app", category: "Analytics")
        logger.error("📈 Analytics error log: \(context) - \(error.localizedDescription)")
    }

    func isRecoverable(_ error: Error) -> Bool {
        // Default implementation - can be overridden
        return false
    }

    func attemptRecovery(for error: Error, completion: @escaping (Bool) -> Void) {
        // Default implementation - can be overridden
        completion(false)
    }
}
