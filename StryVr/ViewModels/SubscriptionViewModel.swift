//
//  SubscriptionViewModel.swift
//  StryVr
//
//  Created by Joe Dormond on 8/1/25.
//  💎 View model for subscription management and in-app purchases
//

import Foundation
import StoreKit
import SwiftUI

@MainActor
class SubscriptionViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isLoading = false
    @Published var hasActiveSubscription = false
    @Published var currentSubscription: SubscriptionPlan?
    @Published var availablePlans: [SubscriptionPlan] = []
    @Published var usageStats = UsageStats()
    @Published var testimonials: [Testimonial] = []
    @Published var faqs: [FAQ] = []
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private let subscriptionService = SubscriptionService.shared
    
    // MARK: - Public Methods
    
    func loadSubscriptionData() {
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.loadMockData()
            self.isLoading = false
        }
    }
    
    func purchasePlan(_ plan: SubscriptionPlan) async throws {
        isLoading = true
        defer { isLoading = false }
        
        // Implementation would integrate with StoreKit 2
        try await subscriptionService.purchase(plan)
        
        // Update local state
        currentSubscription = plan
        hasActiveSubscription = true
    }
    
    func restorePurchases() async throws {
        isLoading = true
        defer { isLoading = false }
        
        try await subscriptionService.restorePurchases()
    }
    
    func cancelSubscription() async throws {
        // Implementation would handle subscription cancellation
        try await subscriptionService.cancelSubscription()
        
        // Update local state
        hasActiveSubscription = false
        currentSubscription = availablePlans.first { $0.tier == .free }
    }
    
    // MARK: - Private Methods
    
    private func loadMockData() {
        loadAvailablePlans()
        loadCurrentSubscription()
        loadUsageStats()
        loadTestimonials()
        loadFAQs()
    }
    
    private func loadAvailablePlans() {
        availablePlans = [
            SubscriptionPlan(
                id: "free",
                name: "Free",
                tier: .free,
                price: 0,
                billingPeriod: "Forever",
                keyFeatures: [
                    "Basic reports",
                    "5 AI insights/month",
                    "Limited analytics"
                ],
                isPopular: false
            ),
            SubscriptionPlan(
                id: "premium_monthly",
                name: "Premium",
                tier: .premium,
                price: 29,
                billingPeriod: "per month",
                keyFeatures: [
                    "Unlimited AI insights",
                    "Advanced analytics",
                    "Export reports",
                    "Career predictions"
                ],
                isPopular: true
            ),
            SubscriptionPlan(
                id: "professional_monthly",
                name: "Professional",
                tier: .professional,
                price: 49,
                billingPeriod: "per month",
                keyFeatures: [
                    "Everything in Premium",
                    "HR integration",
                    "Team analytics",
                    "Priority support",
                    "Custom branding"
                ],
                isPopular: false
            )
        ]
    }
    
    private func loadCurrentSubscription() {
        // Mock: User has a premium subscription
        hasActiveSubscription = true
        currentSubscription = SubscriptionPlan(
            id: "premium_active",
            name: "Premium",
            tier: .premium,
            price: 29,
            billingPeriod: "per month",
            keyFeatures: [],
            isPopular: false,
            renewalDate: Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        )
    }
    
    private func loadUsageStats() {
        usageStats = UsageStats(
            aiInsightsUsed: 47,
            aiInsightsLimit: nil, // Unlimited for premium
            reportsGenerated: 12,
            reportsLimit: nil, // Unlimited for premium
            exportsUsed: 8,
            exportsLimit: nil // Unlimited for premium
        )
    }
    
    private func loadTestimonials() {
        testimonials = [
            Testimonial(
                id: "1",
                name: "Sarah Chen",
                title: "Product Manager at Google",
                text: "StryVr's AI insights helped me identify skill gaps and land my dream role. The career predictions were spot-on!",
                rating: 5
            ),
            Testimonial(
                id: "2",
                name: "Marcus Rodriguez",
                title: "Senior Developer at Microsoft",
                text: "The analytics dashboard gives me clear visibility into my growth trajectory. Worth every penny.",
                rating: 5
            ),
            Testimonial(
                id: "3",
                name: "Emily Watson",
                title: "Engineering Manager at Stripe",
                text: "Professional features transformed how I manage my team's development. Game-changer for performance reviews.",
                rating: 5
            )
        ]
    }
    
    private func loadFAQs() {
        faqs = [
            FAQ(
                question: "Can I cancel anytime?",
                answer: "Yes, you can cancel your subscription at any time. You'll continue to have access to premium features until the end of your current billing period."
            ),
            FAQ(
                question: "What's included in the free plan?",
                answer: "The free plan includes basic reports, 5 AI insights per month, and limited analytics. It's perfect for getting started with StryVr."
            ),
            FAQ(
                question: "How accurate are the AI predictions?",
                answer: "Our AI models are trained on industry data and have an 85% accuracy rate for career predictions within 12 months."
            ),
            FAQ(
                question: "Is my data secure?",
                answer: "Absolutely. We use enterprise-grade encryption and never share your personal data with third parties. Your privacy is our priority."
            ),
            FAQ(
                question: "Can I upgrade or downgrade my plan?",
                answer: "Yes, you can change your plan at any time. Upgrades take effect immediately, while downgrades take effect at the next billing cycle."
            )
        ]
    }
}

// MARK: - Data Models

struct SubscriptionPlan: Identifiable {
    let id: String
    let name: String
    let tier: SubscriptionTier
    let price: Int
    let billingPeriod: String
    let keyFeatures: [String]
    let isPopular: Bool
    let renewalDate: Date?
    
    init(id: String, name: String, tier: SubscriptionTier, price: Int, billingPeriod: String, keyFeatures: [String], isPopular: Bool, renewalDate: Date? = nil) {
        self.id = id
        self.name = name
        self.tier = tier
        self.price = price
        self.billingPeriod = billingPeriod
        self.keyFeatures = keyFeatures
        self.isPopular = isPopular
        self.renewalDate = renewalDate
    }
}

enum SubscriptionTier: String, CaseIterable {
    case free = "Free"
    case premium = "Premium"
    case professional = "Professional"
    
    var color: Color {
        switch self {
        case .free: return Theme.Colors.textSecondary
        case .premium: return Theme.Colors.neonBlue
        case .professional: return Theme.Colors.neonOrange
        }
    }
}

struct UsageStats {
    let aiInsightsUsed: Int
    let aiInsightsLimit: Int?
    let reportsGenerated: Int
    let reportsLimit: Int?
    let exportsUsed: Int
    let exportsLimit: Int?
    
    init(aiInsightsUsed: Int = 0, aiInsightsLimit: Int? = nil, reportsGenerated: Int = 0, reportsLimit: Int? = nil, exportsUsed: Int = 0, exportsLimit: Int? = nil) {
        self.aiInsightsUsed = aiInsightsUsed
        self.aiInsightsLimit = aiInsightsLimit
        self.reportsGenerated = reportsGenerated
        self.reportsLimit = reportsLimit
        self.exportsUsed = exportsUsed
        self.exportsLimit = exportsLimit
    }
}

struct Testimonial: Identifiable {
    let id: String
    let name: String
    let title: String
    let text: String
    let rating: Int
}

struct FAQ {
    let question: String
    let answer: String
}

struct SubscriptionFeature {
    let name: String
    let freeAvailability: FeatureAvailability
    let premiumAvailability: FeatureAvailability
    let professionalAvailability: FeatureAvailability
    
    static let allFeatures: [SubscriptionFeature] = [
        SubscriptionFeature(
            name: "AI Insights",
            freeAvailability: .limited(5),
            premiumAvailability: .available,
            professionalAvailability: .available
        ),
        SubscriptionFeature(
            name: "Advanced Analytics",
            freeAvailability: .unavailable,
            premiumAvailability: .available,
            professionalAvailability: .available
        ),
        SubscriptionFeature(
            name: "Export Reports",
            freeAvailability: .unavailable,
            premiumAvailability: .available,
            professionalAvailability: .available
        ),
        SubscriptionFeature(
            name: "Career Predictions",
            freeAvailability: .unavailable,
            premiumAvailability: .available,
            professionalAvailability: .available
        ),
        SubscriptionFeature(
            name: "HR Integration",
            freeAvailability: .unavailable,
            premiumAvailability: .unavailable,
            professionalAvailability: .available
        ),
        SubscriptionFeature(
            name: "Team Analytics",
            freeAvailability: .unavailable,
            premiumAvailability: .unavailable,
            professionalAvailability: .available
        ),
        SubscriptionFeature(
            name: "Priority Support",
            freeAvailability: .unavailable,
            premiumAvailability: .unavailable,
            professionalAvailability: .available
        ),
        SubscriptionFeature(
            name: "Custom Branding",
            freeAvailability: .unavailable,
            premiumAvailability: .unavailable,
            professionalAvailability: .available
        )
    ]
}

enum FeatureAvailability {
    case available
    case limited(Int)
    case unavailable
}

// MARK: - Subscription Service

class SubscriptionService {
    static let shared = SubscriptionService()
    private init() {}
    
    func purchase(_ plan: SubscriptionPlan) async throws {
        // Implementation would use StoreKit 2
        // This is a mock implementation
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        print("Purchased plan: \(plan.name)")
    }
    
    func restorePurchases() async throws {
        // Implementation would restore purchases via StoreKit
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        print("Restored purchases")
    }
    
    func cancelSubscription() async throws {
        // Implementation would handle cancellation
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        print("Cancelled subscription")
    }
    
    func loadProducts() async throws -> [Product] {
        // Implementation would load StoreKit products
        return []
    }
}