//
//  ClearMeConfig.swift
//  StryVr
//
//  🔐 ClearMe Configuration – Secure API credentials management
//

import Foundation

/// Secure ClearMe API Configuration
/// ClearMe Identity API for biometric verification
struct ClearMeConfig {
    
    // MARK: - ClearMe API Configuration
    
    /// ClearMe Identity API base URL
    static let baseURL = "https://api.clearme.com/v1"
    
    /// ClearMe API key (development)
    static var apiKey: String {
        #if DEBUG
        // Development API key - replace with your actual sandbox key
        return "YOUR_CLEARME_SANDBOX_API_KEY"
        #else
        // Production API key - must be set via environment variable
        guard let apiKey = ProcessInfo.processInfo.environment["CLEARME_API_KEY"] else {
            fatalError("CLEARME_API_KEY environment variable not set for production")
        }
        return apiKey
        #endif
    }
    
    /// ClearMe client secret (if required)
    static var clientSecret: String? {
        return ClearMeSecrets.clientSecret
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
    
    // MARK: - ClearMe API Endpoints
    
    /// Initiate verification endpoint
    static let initiateEndpoint = "/verification/initiate"
    
    /// Check status endpoint
    static let statusEndpoint = "/verification/status"
    
    /// Complete verification endpoint
    static let completeEndpoint = "/verification/complete"
    
    /// Cancel verification endpoint
    static let cancelEndpoint = "/verification/cancel"
    
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
    
    /// Build full URL for endpoint
    static func buildURL(for endpoint: String) -> URL? {
        return URL(string: "\(baseURL)\(endpoint)")
    }
    
    /// Get authorization header
    static func authorizationHeader() -> String {
        return "Bearer \(apiKey)"
    }
    
    /// Get default headers for API requests
    static func defaultHeaders() -> [String: String] {
        return [
            "Authorization": authorizationHeader(),
            "Content-Type": "application/json",
            "Accept": "application/json",
            "User-Agent": "StryVr-iOS/1.0"
        ]
    }
    
    /// Validate ClearMe API configuration
    static func validateConfiguration() -> Bool {
        #if DEBUG
        return !apiKey.isEmpty && apiKey != "YOUR_CLEARME_SANDBOX_API_KEY"
        #else
        return !apiKey.isEmpty
        #endif
    }
}

 /*
 
 🔐 SECURITY IMPORTANT:
 
 1. This file contains configuration, not secrets
 2. API keys are stored securely via environment variables
 3. Development keys should be replaced with actual sandbox keys
 4. Production keys must be set via CI/CD environment variables
 5. Never commit actual API keys to version control
 
 PRODUCTION DEPLOYMENT:
 
 Set the environment variable in your CI/CD pipeline:
 CLEARME_API_KEY=your_production_api_key_here
 
 APP STORE CONNECT:
 
 Add the environment variable in App Store Connect:
 - Go to App Store Connect > Your App > TestFlight > Builds
 - Add environment variable: CLEARME_API_KEY
 - Set the value to your production API key
 
 CLEARME SETUP:
 
 1. Sign up at https://verified.clearme.com
 2. Create a developer account
 3. Generate sandbox API key for testing
 4. Contact ClearMe support for production API key
 5. Configure webhook endpoints (optional)
 6. Set up verification levels
 
 SANDBOX TESTING:
 
 - Use sandbox API key for development
 - Magic OTP code: 123456 for testing
 - All verifications succeed by default in sandbox
 - Check "Reject verification" to test failure scenarios
 
 */ 