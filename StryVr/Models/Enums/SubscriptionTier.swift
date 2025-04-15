//
//  SubscriptionTier.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//

import Foundation

/// Defines the available subscription levels in StryVr
enum SubscriptionTier: String, Codable, CaseIterable {
    /// Free tier with limited features
    case freemium
    /// Plus tier with additional features
    case plus
    /// Premium tier with full features
    case premium
    /// Enterprise tier for organizations
    case enterprise

    /// Display label for UI
    var label: String {
        switch self {
        case .freemium: return "Freemium"
        case .plus: return "Plus"
        case .premium: return "Premium"
        case .enterprise: return "Enterprise"
        }
    }

    /// Determines if this tier is paid
    var isPaid: Bool {
        return self != .freemium
    }

    /// Provides a description for each subscription tier
    var description: String {
        switch self {
        case .freemium: return "Access basic features for free."
        case .plus: return "Unlock additional features with the Plus plan."
        case .premium: return "Get full access to all features with the Premium plan."
        case .enterprise: return "Tailored solutions for organizations with the Enterprise plan."
        }
    }

    /// Validates if a given string matches a valid subscription tier
    static func isValidTier(_ tier: String) -> Bool {
        return SubscriptionTier(rawValue: tier) != nil
    }
}
