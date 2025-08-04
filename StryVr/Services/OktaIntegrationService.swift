//
//  OktaIntegrationService.swift
//  StryVr
//
//  🔗 Okta Integration Service – Enterprise HR data sync and authentication
//  Integrates with Okta OIDC for seamless HR verification and data synchronization
//

import AuthenticationServices
import Foundation
import OSLog

@MainActor
class OktaIntegrationService: ObservableObject {
    private let logger = Logger(subsystem: "com.stryvr.app", category: "OktaIntegration")

    // MARK: - Okta Configuration

    // Use secure configuration from OktaConfig
    private let oktaConfig = OktaConfig.self

    @Published var isAuthenticated = false
    @Published var currentUser: OktaUser?
    @Published var hrData: OktaHRData?
    @Published var isLoading = false

    // MARK: - Authentication

    /// Initiate Okta OIDC authentication
    func authenticateWithOkta() async throws -> OktaUser {
        logger.info("Initiating Okta OIDC authentication")

        isLoading = true
        defer { isLoading = false }

        let authURL = oktaConfig.authorizationEndpoint

        // Use ASWebAuthenticationSession for secure authentication
        let session = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: "stryvr"
        ) { [weak self] callbackURL, error in
            Task { @MainActor in
                if let error = error {
                    self?.logger.error("Okta authentication failed: \(error.localizedDescription)")
                    return
                }

                if let callbackURL = callbackURL {
                    try await self?.handleCallback(callbackURL)
                }
            }
        }

        session.presentationContextProvider = self
        session.start()

        // Wait for authentication to complete
        while !isAuthenticated {
            try await Task.sleep(nanoseconds: 100_000_000)  // 0.1 seconds
        }

        guard let user = currentUser else {
            throw OktaError.authenticationFailed
        }

        return user
    }

    /// Handle Okta callback and exchange code for tokens
    private func handleCallback(_ callbackURL: URL) async throws {
        guard let code = extractCode(from: callbackURL) else {
            throw OktaError.invalidCallback
        }

        let tokens = try await exchangeCodeForTokens(code)
        let userInfo = try await fetchUserInfo(accessToken: tokens.accessToken)

        currentUser = OktaUser(
            id: userInfo.sub,
            email: userInfo.email,
            name: userInfo.name,
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken,
            expiresAt: Date().addingTimeInterval(tokens.expiresIn)
        )

        isAuthenticated = true
        logger.info("Okta authentication successful for user: \(userInfo.email)")
    }

    // MARK: - HR Data Sync

    /// Sync HR data from Okta Workforce Identity
    func syncHRData() async throws -> OktaHRData {
        guard let user = currentUser, isAuthenticated else {
            throw OktaError.notAuthenticated
        }

        logger.info("Syncing HR data for user: \(user.email)")

        let hrData = try await fetchHRData(accessToken: user.accessToken)
        self.hrData = hrData

        // Update verification status with HR data
        try await updateVerificationWithHRData(hrData)

        logger.info("HR data sync completed successfully")
        return hrData
    }

    /// Fetch employment data from Okta
    private func fetchHRData(accessToken: String) async throws -> OktaHRData {
        let url = oktaConfig.workforceIdentityEndpoint

        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw OktaError.apiError("Failed to fetch HR data")
        }

        let userData = try JSONDecoder().decode(OktaUserData.self, from: data)

        return OktaHRData(
            employeeId: userData.id,
            email: userData.profile.email,
            firstName: userData.profile.firstName,
            lastName: userData.profile.lastName,
            title: userData.profile.title,
            department: userData.profile.department,
            manager: userData.profile.manager,
            hireDate: userData.profile.hireDate,
            status: userData.status,
            groups: userData.profile.groups
        )
    }

    // MARK: - Verification Integration

    /// Update verification status with HR data
    private func updateVerificationWithHRData(_ hrData: OktaHRData) async throws {
        guard let user = currentUser else { return }

        let employmentData = EmploymentVerificationData(
            companyName: "Verified via Okta",
            position: hrData.title,
            startDate: hrData.hireDate,
            endDate: nil,
            supervisorName: hrData.manager,
            supervisorEmail: nil,
            supervisorPhone: nil,
            performanceRating: nil,
            responsibilities: [],
            achievements: [],
            salary: nil,
            verificationStatus: "Okta Verified"
        )

        // Update verification service
        let verificationService = VerificationService()
        try await verificationService.verifyEmployment(
            for: user.id,
            employmentData: employmentData
        )

        logger.info("Verification updated with Okta HR data")
    }

    // MARK: - Token Management

    /// Exchange authorization code for tokens
    private func exchangeCodeForTokens(_ code: String) async throws -> OktaTokens {
        let url = oktaConfig.tokenEndpoint

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": oktaConfig.redirectUri,
            "client_id": oktaConfig.clientId,
        ]

        request.httpBody = body.percentEncoded()

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw OktaError.apiError("Token exchange failed")
        }

        return try JSONDecoder().decode(OktaTokens.self, from: data)
    }

    /// Fetch user information from Okta
    private func fetchUserInfo(accessToken: String) async throws -> OktaUserInfo {
        let url = oktaConfig.userInfoEndpoint

        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw OktaError.apiError("Failed to fetch user info")
        }

        return try JSONDecoder().decode(OktaUserInfo.self, from: data)
    }

    // MARK: - Helper Methods

    /// Build Okta authorization URL with PKCE
    private func buildAuthURL() -> URL {
        guard var components = URLComponents(url: oktaConfig.authorizationEndpoint, resolvingAgainstBaseURL: false) else {
            fatalError("Failed to create URL components for authorization endpoint")
        }
        components.queryItems = [
            URLQueryItem(name: "client_id", value: oktaConfig.clientId),
            URLQueryItem(name: "redirect_uri", value: oktaConfig.redirectUri),
            URLQueryItem(name: "scope", value: oktaConfig.scopes.joined(separator: " ")),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "state", value: oktaConfig.state),
            URLQueryItem(name: "code_challenge", value: oktaConfig.codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "S256")
        ]
        
        guard let url = components.url else {
            fatalError("Failed to create authorization URL")
        }
        return url
    }

    /// Extract authorization code from callback URL
    private func extractCode(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let code = components.queryItems?.first(where: { $0.name == "code" })?.value
        else {
            return nil
        }
        return code
    }

    /// Refresh access token
    func refreshToken() async throws {
        guard let user = currentUser,
            let refreshToken = user.refreshToken
        else {
            throw OktaError.notAuthenticated
        }

        let url = oktaConfig.tokenEndpoint

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
            "client_id": oktaConfig.clientId,
        ]

        request.httpBody = body.percentEncoded()

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw OktaError.apiError("Token refresh failed")
        }

        let tokens = try JSONDecoder().decode(OktaTokens.self, from: data)

        currentUser?.accessToken = tokens.accessToken
        currentUser?.expiresAt = Date().addingTimeInterval(tokens.expiresIn)

        logger.info("Access token refreshed successfully")
    }

    /// Sign out from Okta
    func signOut() {
        currentUser = nil
        hrData = nil
        isAuthenticated = false
        logger.info("User signed out from Okta")
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding

extension OktaIntegrationService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        // Return the main window for authentication presentation
        return ASPresentationAnchor()
    }
}

// MARK: - Data Models

struct OktaUser {
    let id: String
    let email: String
    let name: String
    var accessToken: String
    var refreshToken: String?
    var expiresAt: Date

    var isTokenExpired: Bool {
        return Date() > expiresAt
    }
}

struct OktaHRData {
    let employeeId: String
    let email: String
    let firstName: String
    let lastName: String
    let title: String
    let department: String
    let manager: String?
    let hireDate: Date
    let status: String
    let groups: [String]

    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

struct OktaTokens: Codable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: TimeInterval
    let tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}

struct OktaUserInfo: Codable {
    let sub: String
    let email: String
    let name: String
}

struct OktaUserData: Codable {
    let id: String
    let status: String
    let profile: OktaUserProfile
}

struct OktaUserProfile: Codable {
    let email: String
    let firstName: String
    let lastName: String
    let title: String
    let department: String
    let manager: String?
    let hireDate: Date
    let groups: [String]

    enum CodingKeys: String, CodingKey {
        case email, firstName, lastName, title, department, manager, groups
        case hireDate
    }
}

// MARK: - Errors

enum OktaError: Error, LocalizedError {
    case invalidURL
    case authenticationFailed
    case invalidCallback
    case notAuthenticated
    case apiError(String)
    case tokenExpired

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid Okta URL"
        case .authenticationFailed:
            return "Okta authentication failed"
        case .invalidCallback:
            return "Invalid authentication callback"
        case .notAuthenticated:
            return "User not authenticated with Okta"
        case .apiError(let message):
            return "Okta API Error: \(message)"
        case .tokenExpired:
            return "Okta access token expired"
        }
    }
}

// MARK: - Extensions

extension Dictionary where Key == String, Value == String {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey =
                "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue =
                "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
