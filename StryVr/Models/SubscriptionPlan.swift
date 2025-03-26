//
//  SubscriptionPlan.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25.
//

import Foundation

enum SubscriptionTier: String, Codable {
    case freemium
    case plus
    case premium
    case enterprise
}

struct SubscriptionPlan: Identifiable, Codable {
    let id: String
    let tier: SubscriptionTier
    let monthlyPrice: Double
    let yearlyPrice: Double?
    let features: [String]
    let isRecommended: Bool
}
