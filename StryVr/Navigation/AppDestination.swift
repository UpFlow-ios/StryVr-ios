//
//  AppDestination.swift
//  StryVr
//
//  Created by Joe Dormond on 8/1/25.
//  🧭 Type-safe navigation destinations for StryVr app
//

import Foundation

/// Defines all possible navigation destinations in the StryVr app
/// Each case represents a unique screen or view that users can navigate to
enum AppDestination: Hashable {
    // MARK: - Core App Flows
    case dashboard
    case profile(userId: String)
    case settings
    
    // MARK: - Reports & Analytics
    case reports
    case reportDetail(reportId: String, userId: String)
    case reportShare(reportId: String)
    case analytics(userId: String)
    case performanceDetail(metricId: String, timeframe: String)
    
    // MARK: - Career Development
    case careerGoals(userId: String)
    case skillAssessment(assessmentId: String)
    case careerAdvice(userId: String)
    case learningPath(pathId: String)
    
    // MARK: - AI & Recommendations
    case aiInsights(userId: String)
    case personalizedRecommendations(userId: String)
    case careerPredictions(userId: String)
    
    // MARK: - Subscription & Monetization
    case subscription
    case subscriptionManagement
    case pricing
    case paywall(feature: String)
    
    // MARK: - Onboarding & Authentication
    case onboarding(step: Int)
    case login
    case signup
    case emailVerification(email: String)
    case resetPassword
    
    // MARK: - HR Integration & Verification
    case hrVerification(employerId: String)
    case employerDashboard(employerId: String)
    case workplaceMetrics(workplaceId: String)
    case teamAnalytics(teamId: String)
    
    // MARK: - Social & Sharing
    case shareProfile(userId: String)
    case exportReport(reportId: String, format: ExportFormat)
    case deepLinkShare(type: ShareType, id: String)
    
    // MARK: - Support & Help
    case help
    case support
    case feedback
    case about
    case privacyPolicy
    case termsOfService
}

// MARK: - Supporting Types

/// Export format options for reports
enum ExportFormat: String, CaseIterable {
    case pdf
    case csv
    case json
    case email
}

/// Share type for deep linking
enum ShareType: String, CaseIterable {
    case profile
    case report
    case achievement
    case goal
    case insight
}

// MARK: - Deep Linking Support

extension AppDestination {
    /// Creates an AppDestination from a URL for deep linking
    static func from(url: URL) -> AppDestination? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let host = components.host else {
            return nil
        }
        
        let pathComponents = components.path.components(separatedBy: "/").filter { !$0.isEmpty }
        
        switch host {
        case "dashboard":
            return .dashboard
            
        case "profile":
            guard pathComponents.count >= 1 else { return nil }
            return .profile(userId: pathComponents[0])
            
        case "reports":
            if pathComponents.count >= 2 {
                let (reportId, userId) = (pathComponents[0], pathComponents[1])
                return .reportDetail(reportId: reportId, userId: userId)
            }
            return .reports
            
        case "analytics":
            guard pathComponents.count >= 1 else { return nil }
            return .analytics(userId: pathComponents[0])
            
        case "subscription":
            return .subscription
            
        case "share":
            guard pathComponents.count >= 2,
                  let shareType = ShareType(rawValue: pathComponents[0]) else { return nil }
            let shareId = pathComponents[1]
            return .deepLinkShare(type: shareType, id: shareId)
            
        default:
            return nil
        }
    }
    
    /// Converts AppDestination to URL for sharing
    func toURL(baseURL: String = "stryvr://") -> URL? {
        let urlString: String
        
        switch self {
        case .dashboard:
            urlString = "\(baseURL)dashboard"
            
        case .profile(let userId):
            urlString = "\(baseURL)profile/\(userId)"
            
        case .reports:
            urlString = "\(baseURL)reports"
            
        case let .reportDetail(reportId, userId):
            urlString = "\(baseURL)reports/\(reportId)/\(userId)"
            
        case .analytics(let userId):
            urlString = "\(baseURL)analytics/\(userId)"
            
        case .subscription:
            urlString = "\(baseURL)subscription"
            
        case let .deepLinkShare(type, id):
            urlString = "\(baseURL)share/\(type.rawValue)/\(id)"
            
        default:
            return nil // Not all destinations support deep linking
        }
        
        return URL(string: urlString)
    }
}

// MARK: - Navigation Metadata

extension AppDestination {
    /// Human-readable title for the destination
    var title: String {
        switch self {
        case .dashboard:
            return "Dashboard"
        case .profile:
            return "Profile"
        case .reports:
            return "Reports"
        case .reportDetail:
            return "Report Details"
        case .analytics:
            return "Analytics"
        case .careerGoals:
            return "Career Goals"
        case .aiInsights:
            return "AI Insights"
        case .subscription:
            return "Subscription"
        case .settings:
            return "Settings"
        case .help:
            return "Help"
        default:
            return "StryVr"
        }
    }
    
    /// Whether this destination should show a back button
    var showsBackButton: Bool {
        switch self {
        case .dashboard, .login, .signup, .onboarding:
            return false
        default:
            return true
        }
    }
    
    /// Whether this destination requires authentication
    var requiresAuthentication: Bool {
        switch self {
        case .login, .signup, .onboarding, .resetPassword, .help, .about, .privacyPolicy, .termsOfService:
            return false
        default:
            return true
        }
    }
}
