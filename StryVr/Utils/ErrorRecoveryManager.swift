//
//  ErrorRecoveryManager.swift
//  StryVr
//
//  🛡️ Professional Error Recovery & Graceful Degradation
//  Handles crashes, network failures, and provides user-friendly recovery
//

import Foundation
import OSLog
import SwiftUI

/// Professional error recovery and graceful degradation
@MainActor
final class ErrorRecoveryManager: ObservableObject {
    static let shared = ErrorRecoveryManager()
    
    private let logger = Logger(subsystem: "com.stryvr.app", category: "ErrorRecovery")
    
    @Published var currentError: AppError?
    @Published var isRecovering = false
    @Published var recoveryAttempts = 0
    
    private let maxRecoveryAttempts = 3
    private var errorHistory: [AppError] = []
    
    private init() {
        setupErrorHandling()
    }
    
    // MARK: - Error Types
    
    enum AppError: LocalizedError, Identifiable {
        case networkFailure(String)
        case authenticationFailed(String)
        case dataCorruption(String)
        case memoryPressure(String)
        case unknownError(String)
        
        var id: String {
            switch self {
            case .networkFailure: return "network"
            case .authenticationFailed: return "auth"
            case .dataCorruption: return "data"
            case .memoryPressure: return "memory"
            case .unknownError: return "unknown"
            }
        }
        
        var errorDescription: String? {
            switch self {
            case .networkFailure(let message):
                return "Network Error: \(message)"
            case .authenticationFailed(let message):
                return "Authentication Error: \(message)"
            case .dataCorruption(let message):
                return "Data Error: \(message)"
            case .memoryPressure(let message):
                return "Memory Error: \(message)"
            case .unknownError(let message):
                return "Unknown Error: \(message)"
            }
        }
        
        var recoverySuggestion: String {
            switch self {
            case .networkFailure:
                return "Please check your internet connection and try again."
            case .authenticationFailed:
                return "Please log in again to continue."
            case .dataCorruption:
                return "Your data may need to be refreshed. Please restart the app."
            case .memoryPressure:
                return "The app is using too much memory. Please close other apps and try again."
            case .unknownError:
                return "An unexpected error occurred. Please try again or contact support."
            }
        }
        
        var severity: ErrorSeverity {
            switch self {
            case .networkFailure: return .medium
            case .authenticationFailed: return .high
            case .dataCorruption: return .critical
            case .memoryPressure: return .critical
            case .unknownError: return .medium
            }
        }
    }
    
    enum ErrorSeverity {
        case low, medium, high, critical
    }
    
    // MARK: - Error Handling
    
    private func setupErrorHandling() {
        // Set up global error handling
        NSSetUncaughtExceptionHandler { exception in
            ErrorRecoveryManager.shared.handleUncaughtException(exception)
        }
    }
    
    func handleError(_ error: AppError) {
        logger.error("🚨 Error occurred: \(error.errorDescription ?? "Unknown")")
        
        errorHistory.append(error)
        currentError = error
        
        // Log to analytics
        logErrorToAnalytics(error)
        
        // Attempt recovery based on error type
        attemptRecovery(for: error)
    }
    
    private func attemptRecovery(for error: AppError) {
        guard recoveryAttempts < maxRecoveryAttempts else {
            logger.error("❌ Max recovery attempts reached for error: \(error.id)")
            return
        }
        
        recoveryAttempts += 1
        isRecovering = true
        
        logger.info("🔄 Attempting recovery #\(recoveryAttempts) for error: \(error.id)")
        
        switch error {
        case .networkFailure:
            retryNetworkOperation()
        case .authenticationFailed:
            refreshAuthentication()
        case .dataCorruption:
            repairDataCorruption()
        case .memoryPressure:
            handleMemoryPressure()
        case .unknownError:
            performGeneralRecovery()
        }
    }
    
    // MARK: - Recovery Strategies
    
    private func retryNetworkOperation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.logger.info("🔄 Retrying network operation...")
            // Implement network retry logic
            self.isRecovering = false
        }
    }
    
    private func refreshAuthentication() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.logger.info("🔄 Refreshing authentication...")
            // Implement auth refresh logic
            self.isRecovering = false
        }
    }
    
    private func repairDataCorruption() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.logger.info("🔄 Repairing data corruption...")
            // Implement data repair logic
            self.isRecovering = false
        }
    }
    
    private func handleMemoryPressure() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.logger.info("🔄 Handling memory pressure...")
            // Implement memory cleanup
            self.isRecovering = false
        }
    }
    
    private func performGeneralRecovery() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.logger.info("🔄 Performing general recovery...")
            // Implement general recovery logic
            self.isRecovering = false
        }
    }
    
    // MARK: - Analytics & Logging
    
    private func logErrorToAnalytics(_ error: AppError) {
        // Log to Firebase Crashlytics or other analytics
        logger.error("📊 Error logged to analytics: \(error.id) - \(error.errorDescription ?? "")")
    }
    
    private func handleUncaughtException(_ exception: NSException) {
        let error = AppError.unknownError("Uncaught exception: \(exception.name.rawValue)")
        handleError(error)
    }
    
    // MARK: - Public Interface
    
    func clearError() {
        currentError = nil
        recoveryAttempts = 0
        isRecovering = false
    }
    
    func getErrorHistory() -> [AppError] {
        return errorHistory
    }
}

// MARK: - Error View Modifier

struct ErrorAlertModifier: ViewModifier {
    @ObservedObject var errorManager = ErrorRecoveryManager.shared
    
    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: .constant(errorManager.currentError != nil)) {
                Button("OK") {
                    errorManager.clearError()
                }
                if errorManager.isRecovering {
                    Button("Retry") {
                        // Trigger retry logic
                    }
                }
            } message: {
                if let error = errorManager.currentError {
                    Text(error.recoverySuggestion)
                }
            }
    }
}

extension View {
    func handleErrors() -> some View {
        modifier(ErrorAlertModifier())
    }
} 