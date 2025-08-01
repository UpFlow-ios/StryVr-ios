//
//  SubscriptionPlan.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25
//
//  💳 Subscription Plan Model – Handles pricing tiers, labels, validation, and features
//
import Foundation

/// Represents a pricing tier and features for subscriptions
struct SubscriptionPlan: Identifiable, Codable, Hashable {
    /// Unique identifier for the subscription plan
    let id: String = UUID().uuidString
    /// Tier of the subscription (e.g., freemium, premium)
    let tier: SubscriptionTier
    /// Monthly price of the subscription
    let monthlyPrice: Double
    /// Yearly price of the subscription (optional)
    let yearlyPrice: Double?
    /// List of features included in the subscription
    let features: [String]
    /// Indicates if this plan is recommended
    let isRecommended: Bool

    // MARK: - Static Cases

    static let freemium = SubscriptionPlan(
        tier: .freemium,
        monthlyPrice: 0.0,
        yearlyPrice: nil,
        features: ["Basic skill tracking", "Limited reports", "Community access"],
        isRecommended: false
    )

    static let plus = SubscriptionPlan(
        tier: .plus,
        monthlyPrice: 9.99,
        yearlyPrice: 99.99,
        features: ["Advanced analytics", "Priority support", "Custom goals", "Team insights"],
        isRecommended: false
    )

    static let premium = SubscriptionPlan(
        tier: .premium,
        monthlyPrice: 19.99,
        yearlyPrice: 199.99,
        features: [
            "AI-powered insights", "Advanced reporting", "Mentor matching", "Career coaching"
        ],
        isRecommended: true
    )

    static let enterprise = SubscriptionPlan(
        tier: .enterprise,
        monthlyPrice: 49.99,
        yearlyPrice: 499.99,
        features: [
            "Custom integrations", "Dedicated support", "Advanced security", "Team management"
        ],
        isRecommended: false
    )

    static var allCases: [SubscriptionPlan] {
        return [.freemium, .plus, .premium, .enterprise]
    }

    // MARK: - Pricing Labels

    /// Returns a formatted price label for the subscription
    var priceLabel: String {
        if let yearly = yearlyPrice {
            return "$\(monthlyPrice)/mo or $\(yearly)/yr"
        } else {
            return "$\(monthlyPrice)/mo"
        }
    }

    /// Calculates the yearly equivalent of the monthly price if `yearlyPrice` is not provided
    var calculatedYearlyPrice: Double {
        return yearlyPrice ?? (monthlyPrice * 12)
    }

    // MARK: - Validation

    /// Validates that the prices are non-negative
    var isValid: Bool {
        monthlyPrice >= 0 && (yearlyPrice == nil || (yearlyPrice ?? 0) >= 0)
    }

    // MARK: - Placeholder Plan

    /// A placeholder subscription plan
    static let empty = SubscriptionPlan(
        id: UUID().uuidString,
        tier: .freemium,
        monthlyPrice: 0.0,
        yearlyPrice: nil,
        features: [],
        isRecommended: false
    )
}
