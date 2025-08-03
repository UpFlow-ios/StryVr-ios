//
//  OktaConfig.swift
//  StryVr
//
//  🔐 Secure Okta Configuration
//  Store sensitive Okta settings securely for production
//

import Foundation
import CommonCrypto

/// Secure Okta configuration management
struct OktaConfig {
    
    // MARK: - Environment-Based Configuration
    
    /// Okta domain for authentication
    static var domain: String {
        #if DEBUG
        // Development domain - safe to expose in debug builds
        return "dev-72949354.okta.com"
        #else
        // Production domain - must be set via environment variable
        guard let domain = ProcessInfo.processInfo.environment["OKTA_DOMAIN"] else {
            fatalError("OKTA_DOMAIN environment variable not set for production")
        }
        return domain
        #endif
    }
    
    /// Okta OAuth client ID
    static var clientId: String {
        #if DEBUG
        // Development client ID - your actual dev client ID
        return "0oapwakxg7155usbd5d7"
        #else
        // Production client ID - must be set via environment variable
        guard let clientId = ProcessInfo.processInfo.environment["OKTA_CLIENT_ID"] else {
            fatalError("OKTA_CLIENT_ID environment variable not set for production")
        }
        return clientId
        #endif
    }
    
    /// Okta client secret (if required)
    static var clientSecret: String? {
        #if DEBUG
        return nil // Not needed for public client
        #else
        return ProcessInfo.processInfo.environment["OKTA_CLIENT_SECRET"]
        #endif
    }
    
    // MARK: - OAuth Configuration
    
    /// Redirect URI for OAuth callback
    static let redirectUri = "com.stryvr.app://oauth/callback"
    
    /// OAuth scopes for authentication
    static let scopes = [
        "openid",
        "profile", 
        "email",
        "workforce_identity"
    ]
    
    /// Authorization endpoint
    static var authorizationEndpoint: URL {
        return URL(string: "https://\(domain)/oauth2/v1/authorize")!
    }
    
    /// Token endpoint
    static var tokenEndpoint: URL {
        return URL(string: "https://\(domain)/oauth2/v1/token")!
    }
    
    /// User info endpoint
    static var userInfoEndpoint: URL {
        return URL(string: "https://\(domain)/oauth2/v1/userinfo")!
    }
    
    /// Workforce Identity API endpoint
    static var workforceIdentityEndpoint: URL {
        return URL(string: "https://\(domain)/api/v1/users/me")!
    }
    
    // MARK: - Security Configuration
    
    /// PKCE (Proof Key for Code Exchange) configuration
    static let usePKCE = true
    
    /// State parameter for CSRF protection
    static var state: String {
        return UUID().uuidString
    }
    
    /// Code verifier for PKCE
    static var codeVerifier: String {
        return generateCodeVerifier()
    }
    
    /// Code challenge for PKCE
    static var codeChallenge: String {
        return generateCodeChallenge(from: codeVerifier)
    }
    
    // MARK: - Helper Methods
    
    /// Generate a secure code verifier for PKCE
    private static func generateCodeVerifier() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let length = 128
        return String((0..<length).map { _ in characters.randomElement()! })
    }
    
    /// Generate code challenge from verifier
    private static func generateCodeChallenge(from verifier: String) -> String {
        guard let data = verifier.data(using: .utf8) else { return "" }
        
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress, CC_LONG(buffer.count), &hash)
        }
        
        return Data(hash).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

// MARK: - Environment Variables Documentation

/*
 
 PRODUCTION ENVIRONMENT VARIABLES REQUIRED:
 
 Set these in your production environment (CI/CD, App Store Connect, etc.):
 
 OKTA_DOMAIN=your-production-domain.okta.com
 OKTA_CLIENT_ID=your-production-client-id
 OKTA_CLIENT_SECRET=your-production-client-secret (if required)
 
 DEVELOPMENT SETUP:
 
 1. Replace "YOUR_DEV_CLIENT_ID" with your actual development client ID
 2. Keep the development domain as is for testing
 3. Never commit production credentials to version control
 
 SECURITY NOTES:
 
 - Production domains should never be exposed in code
 - Use environment variables for all production settings
 - Implement proper key management for production deployments
 - Consider using Apple's Keychain for additional security
 
 */ 