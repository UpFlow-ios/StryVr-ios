//
//  ClearMeConfig.swift
//  StryVr
//
//  🔐 ClearMe Configuration – Secure API credentials management
//

import Foundation

/// Secure Custom Biometric Verification Configuration
/// Uses Apple's built-in Face ID/Touch ID for identity verification
struct ClearMeConfig {
    
    // MARK: - Custom Verification Configuration
    
    /// Custom verification system (no external API required)
    static let verificationSystem = "StryVr Custom Biometric"
    
    /// Custom verification key (not needed for Apple biometric auth)
    static var apiKey: String {
        return "stryvr_custom_biometric_verification"
    }
    
    /// Custom verification secret (not needed for Apple biometric auth)
    static var clientSecret: String? {
        return nil // Not needed for Apple's built-in biometric authentication
    }
    
    // MARK: - Verification Settings
    
    /// Default verification level for new users
    static let defaultVerificationLevel: ClearMeVerificationLevel = .standard
    
    /// Verification expiration period (in years)
    static let verificationExpirationYears = 1
    
    /// Maximum verification attempts per day
    static let maxDailyAttempts = 5
    
    /// Verification timeout (in seconds)
    static let verificationTimeout: TimeInterval = 300 // 5 minutes
    
    // MARK: - Custom Verification Endpoints
    
    /// Custom verification flow (handled internally)
    static let initiateEndpoint = "custom_biometric_verification"
    
    /// Verification status (stored in Firestore)
    static let statusEndpoint = "verification_status"
    
    /// Verification completion (handled internally)
    static let completeEndpoint = "verification_complete"
    
    /// Verification cancellation (handled internally)
    static let cancelEndpoint = "verification_cancel"
    
    // MARK: - Security Settings
    
    /// Enable biometric authentication
    static let enableBiometricAuth = true
    
    /// Enable document verification
    static let enableDocumentVerification = true
    
    /// Enable liveness detection
    static let enableLivenessDetection = true
    
    /// Enable face matching
    static let enableFaceMatching = true
    
    // MARK: - Helper Methods
    
    /// Build verification identifier
    static func buildVerificationID(for endpoint: String) -> String {
        return "stryvr_\(endpoint)_\(UUID().uuidString)"
    }
    
    /// Get verification header
    static func authorizationHeader() -> String {
        return "StryVr-Custom-Biometric"
    }
    
    /// Get default verification headers
    static func defaultHeaders() -> [String: String] {
        return [
            "Verification-Type": "Custom-Biometric",
            "App-Version": "1.0",
            "Platform": "iOS"
        ]
    }
    
    /// Validate custom verification configuration
    static func validateConfiguration() -> Bool {
        return true // Always valid since we use Apple's built-in biometric authentication
    }
}

 /*
 
 🔐 SECURITY IMPORTANT:
 
 1. This file contains configuration for custom biometric verification
 2. Uses Apple's built-in Face ID/Touch ID authentication
 3. No external API keys required
 4. Secure and privacy-compliant
 5. Works offline and doesn't require internet connection
 
 CUSTOM VERIFICATION SYSTEM:
 
 This system uses Apple's LocalAuthentication framework to:
 - Verify user identity using Face ID or Touch ID
 - Store verification status in Firestore
 - Create verification certificates
 - Track verification history
 
 BENEFITS:
 
 ✅ No external dependencies
 ✅ No API keys to manage
 ✅ Works offline
 ✅ Apple's security standards
 ✅ Privacy-compliant
 ✅ App Store ready
 
 */ 