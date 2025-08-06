//
//  SubscriptionView.swift
//  StryVr
//
//  Created by Joe Dormond on 8/1/25.
//  💎 Subscription management with pricing tiers and premium features
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject private var viewModel = SubscriptionViewModel()
    @State private var selectedPlan: SubscriptionPlan?
    @State private var showingPaywall = false
    @State private var isProcessingPurchase = false
    @Namespace private var subscriptionNamespace
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Premium Header
                premiumHeader
                
                // Current Plan Status
                if viewModel.hasActiveSubscription {
                    currentPlanSection
                }
                
                // Pricing Plans
                pricingPlansSection
                
                // Features Comparison
                featuresComparisonSection
                
                // Success Stories / Testimonials
                successStoriesSection
                
                // FAQ Section
                faqSection
            }
            .padding()
        }
        .background(subscriptionGradientBackground)
        .navigationTitle("Subscription")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.hasActiveSubscription {
                    Button {
                        router.navigate(to: .subscriptionManagement)
                    } label: {
                        Text("Manage")
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                    .liquidGlassButton()
                }
            }
        }
        .onAppear {
            viewModel.loadSubscriptionData()
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView(selectedPlan: selectedPlan)
                .environmentObject(router)
        }
    }
    
    // MARK: - Premium Header
    
    private var premiumHeader: some View {
        VStack(spacing: 20) {
            // Crown Icon with Animation
            ZStack {
                Circle()
                    .fill(Theme.Colors.glassPrimary)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Theme.Colors.neonYellow)
                    .symbolEffect(.bounce.up, options: .repeating)
            }
            .neonGlow(color: Theme.Colors.neonYellow, pulse: true)
            
            VStack(spacing: 12) {
                Text("Unlock Your Full Potential")
                    .font(Theme.Typography.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Get AI-powered insights, unlimited analytics, and personalized career guidance")
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Current Plan Section
    
    @ViewBuilder
    private var currentPlanSection: some View {
        if let currentPlan = viewModel.currentSubscription {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current Plan")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                        
                        Text(currentPlan.name)
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Next Billing")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                        
                        Text(currentPlan.renewalDate.formatted(date: .abbreviated, time: .omitted))
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                }
                
                // Usage Stats
                if currentPlan.tier == .premium || currentPlan.tier == .professional {
                    UsageStatsView(usage: viewModel.usageStats)
                }
            }
            .padding()
            .liquidGlassCard()
            .neonGlow(color: currentPlan.tier.color.opacity(0.3))
        }
    }
    
    // MARK: - Pricing Plans Section
    
    private var pricingPlansSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Choose Your Plan")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(viewModel.availablePlans, id: \.id) { plan in
                    PricingPlanCard(
                        plan: plan,
                        isSelected: selectedPlan?.id == plan.id,
                        isCurrentPlan: viewModel.currentSubscription?.tier == plan.tier,
                        namespace: subscriptionNamespace
                    ) {
                        selectedPlan = plan
                        showingPaywall = true
                    }
                }
            }
            
            // Annual Discount Banner
            if !viewModel.hasActiveSubscription {
                DiscountBanner()
            }
        }
    }
    
    // MARK: - Features Comparison
    
    private var featuresComparisonSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Feature Comparison")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(SubscriptionFeature.allFeatures, id: \.name) { feature in
                    FeatureComparisonRow(feature: feature)
                }
            }
            .padding()
            .liquidGlassCard()
        }
    }
    
    // MARK: - Success Stories
    
    private var successStoriesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Success Stories")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.testimonials, id: \.id) { testimonial in
                        TestimonialCard(testimonial: testimonial)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - FAQ Section
    
    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Frequently Asked Questions")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ForEach(viewModel.faqs, id: \.question) { faq in
                FAQItemView(faq: faq)
            }
        }
    }
    
    // MARK: - Background
    
    private var subscriptionGradientBackground: some View {
        LinearGradient(
            colors: [
                Theme.Colors.deepNavyBlue,
                Theme.Colors.softCharcoalGray.opacity(0.8),
                Theme.Colors.subtleLightGray.opacity(0.6)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Component Views

private struct PricingPlanCard: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let isCurrentPlan: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // Plan Header
                VStack(spacing: 8) {
                    if plan.isPopular {
                        Text("MOST POPULAR")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Theme.Colors.neonOrange)
                            .clipShape(Capsule())
                    }
                    
                    Text(plan.name)
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    VStack(spacing: 4) {
                        HStack(alignment: .top, spacing: 2) {
                            Text("$")
                                .font(.title3)
                                .foregroundColor(plan.tier.color)
                            
                            Text("\(plan.price)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(plan.tier.color)
                        }
                        
                        Text(plan.billingPeriod)
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }
                
                // Key Features
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(plan.keyFeatures, id: \.self) { feature in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(plan.tier.color)
                                .font(.caption)
                            
                            Text(feature)
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.textPrimary)
                            
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                
                // Action Button
                Group {
                    if isCurrentPlan {
                        Text("Current Plan")
                            .foregroundColor(Theme.Colors.textSecondary)
                    } else {
                        Text(plan.tier == .free ? "Current" : "Upgrade")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    Group {
                        if isCurrentPlan {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Theme.Colors.glassPrimary)
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(plan.tier.color)
                        }
                    }
                )
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 280)
        }
        .disabled(isCurrentPlan)
        .liquidGlassCard()
        .overlay(
            Group {
                if plan.isPopular {
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                        .stroke(Theme.Colors.neonOrange, lineWidth: 2)
                        .neonGlow(color: Theme.Colors.neonOrange)
                }
            }
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(), value: isSelected)
    }
}

private struct UsageStatsView: View {
    let usage: UsageStats
    
    var body: some View {
        VStack(spacing: 12) {
            Text("This Month's Usage")
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            
            HStack(spacing: 20) {
                UsageStatItem(
                    title: "AI Insights",
                    current: usage.aiInsightsUsed,
                    limit: usage.aiInsightsLimit
                )
                
                UsageStatItem(
                    title: "Reports",
                    current: usage.reportsGenerated,
                    limit: usage.reportsLimit
                )
                
                UsageStatItem(
                    title: "Exports",
                    current: usage.exportsUsed,
                    limit: usage.exportsLimit
                )
            }
        }
        .padding()
        .background(Theme.Colors.glassPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct UsageStatItem: View {
    let title: String
    let current: Int
    let limit: Int?
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(current)")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Text(title)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            
            if let limit = limit {
                Text("of \(limit)")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
            } else {
                Text("Unlimited")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.neonGreen)
            }
        }
    }
}

private struct DiscountBanner: View {
    var body: some View {
        HStack {
            Image(systemName: "gift.fill")
                .foregroundColor(Theme.Colors.neonGreen)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Save 25% with Annual Plans")
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text("Limited time offer")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            Spacer()
        }
        .padding()
        .liquidGlassCard()
        .neonGlow(color: Theme.Colors.neonGreen.opacity(0.3))
    }
}

private struct FeatureComparisonRow: View {
    let feature: SubscriptionFeature
    
    var body: some View {
        HStack {
            Text(feature.name)
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Spacer()
            
            HStack(spacing: 20) {
                FeatureAvailabilityIcon(availability: feature.freeAvailability)
                FeatureAvailabilityIcon(availability: feature.premiumAvailability)
                FeatureAvailabilityIcon(availability: feature.professionalAvailability)
            }
        }
    }
}

private struct FeatureAvailabilityIcon: View {
    let availability: FeatureAvailability
    
    var body: some View {
        Group {
            switch availability {
            case .available:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Theme.Colors.neonGreen)
            case .limited(let count):
                Text("\(count)")
                    .font(.caption)
                    .foregroundColor(Theme.Colors.neonYellow)
            case .unavailable:
                Image(systemName: "xmark.circle")
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
        .frame(width: 30)
    }
}

private struct TestimonialCard: View {
    let testimonial: Testimonial
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\"\(testimonial.text)\"")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textPrimary)
                .italic()
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(testimonial.name)
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .fontWeight(.semibold)
                    
                    Text(testimonial.title)
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < testimonial.rating ? "star.fill" : "star")
                            .foregroundColor(Theme.Colors.neonYellow)
                            .font(.caption2)
                    }
                }
            }
        }
        .padding()
        .frame(width: 250)
        .liquidGlassCard()
    }
}

private struct FAQItemView: View {
    let faq: FAQ
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(faq.question)
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }
            
            if isExpanded {
                Text(faq.answer)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .transition(.opacity.combined(with: .slide))
            }
        }
        .padding()
        .liquidGlassCard()
    }
}

#Preview {
    NavigationStack {
        SubscriptionView()
            .environmentObject(AppRouter())
    }
}