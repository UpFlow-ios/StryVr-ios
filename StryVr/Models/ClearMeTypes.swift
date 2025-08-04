//
//  ClearMeTypes.swift
//  StryVr
//
//  ClearMe API Types and Enums
//

import Foundation

/// ClearMe verification levels
enum ClearMeVerificationLevel: String, Codable, CaseIterable {
    case basic = "Basic"
    case standard = "Standard"
    case premium = "Premium"
    case enterprise = "Enterprise"

    var description: String {
        switch self {
        case .basic: return "Basic identity verification"
        case .standard: return "Standard verification with document check"
        case .premium: return "Premium verification with background check"
        case .enterprise: return "Enterprise-level comprehensive verification"
        }
    }

    var verificationScore: Double {
        switch self {
        case .basic: return 0.7
        case .standard: return 0.85
        case .premium: return 0.95
        case .enterprise: return 0.99
        }
    }
} 
