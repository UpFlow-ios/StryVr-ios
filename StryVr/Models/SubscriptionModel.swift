import Foundation
import StoreKit

// MARK: - Subscription Tiers
enum SubscriptionTier: String, CaseIterable, Codable {
    case free
    case premium
    case team
    case enterprise

    var displayName: String {
        switch self {
        case .free: return "Free"
        case .premium: return "Premium"
        case .team: return "Team"
        case .enterprise: return "Enterprise"
        }
    }

    var monthlyPrice: Decimal {
        switch self {
        case .free: return 0.0
        case .premium: return 7.99
        case .team: return 29.99
        case .enterprise: return 99.99
        }
    }

    var yearlyPrice: Decimal {
        switch self {
        case .free: return 0.0
        case .premium: return 79.99  // 17% discount
        case .team: return 299.99  // 17% discount
        case .enterprise: return 999.99  // 17% discount
        }
    }

    var features: [SubscriptionFeature] {
        switch self {
        case .free:
            return [
                .basicSkillTracking,
                .limitedAIInsights,
                .threeCareerGoals,
                .basicReports,
                .communityAccess
            ]
        case .premium:
            return [
                .unlimitedAIInsights,
                .advancedAnalytics,
                .customCareerPaths,
                .prioritySupport,
                .exportReports,
                .premiumContent,
                .advancedGamification,
                .personalizedCoaching,
                .professionalReports,
                .skillAssessments
            ]
        case .team:
            return [
                .allPremiumFeatures,
                .teamAnalytics,
                .managerDashboard,
                .performanceInsights,
                .teamCollaboration,
                .customIntegrations,
                .teamReports,
                .adminControls
            ]
        case .enterprise:
            return [
                .allTeamFeatures,
                .whiteLabelOptions,
                .customBranding,
                .dedicatedSupport,
                .ssoIntegration,
                .advancedSecurity,
                .customWorkflows,
                .enterpriseAnalytics,
                .customIntegrations
            ]
        }
    }
}

// MARK: - Subscription Features
enum SubscriptionFeature: String, CaseIterable, Codable {
    case basicSkillTracking = "basic_skill_tracking"
    case limitedAIInsights = "limited_ai_insights"
    case threeCareerGoals = "three_career_goals"
    case basicReports = "basic_reports"
    case communityAccess = "community_access"
    case unlimitedAIInsights = "unlimited_ai_insights"
    case advancedAnalytics = "advanced_analytics"
    case customCareerPaths = "custom_career_paths"
    case prioritySupport = "priority_support"
    case exportReports = "export_reports"
    case premiumContent = "premium_content"
    case advancedGamification = "advanced_gamification"
    case personalizedCoaching = "personalized_coaching"
    case professionalReports = "professional_reports"
    case skillAssessments = "skill_assessments"
    case allPremiumFeatures = "all_premium_features"
    case teamAnalytics = "team_analytics"
    case managerDashboard = "manager_dashboard"
    case performanceInsights = "performance_insights"
    case teamCollaboration = "team_collaboration"
    case customIntegrations = "custom_integrations"
    case teamReports = "team_reports"
    case adminControls = "admin_controls"
    case allTeamFeatures = "all_team_features"
    case whiteLabelOptions = "white_label_options"
    case customBranding = "custom_branding"
    case dedicatedSupport = "dedicated_support"
    case ssoIntegration = "sso_integration"
    case advancedSecurity = "advanced_security"
    case customWorkflows = "custom_workflows"
    case enterpriseAnalytics = "enterprise_analytics"

    var displayName: String {
        switch self {
        case .basicSkillTracking: return "Basic Skill Tracking"
        case .limitedAIInsights: return "Limited AI Insights"
        case .threeCareerGoals: return "3 Career Goals"
        case .basicReports: return "Basic Reports"
        case .communityAccess: return "Community Access"
        case .unlimitedAIInsights: return "Unlimited AI Insights"
        case .advancedAnalytics: return "Advanced Analytics"
        case .customCareerPaths: return "Custom Career Paths"
        case .prioritySupport: return "Priority Support"
        case .exportReports: return "Export Reports"
        case .premiumContent: return "Premium Content"
        case .advancedGamification: return "Advanced Gamification"
        case .personalizedCoaching: return "Personalized Coaching"
        case .professionalReports: return "Professional Reports"
        case .skillAssessments: return "Skill Assessments"
        case .allPremiumFeatures: return "All Premium Features"
        case .teamAnalytics: return "Team Analytics"
        case .managerDashboard: return "Manager Dashboard"
        case .performanceInsights: return "Performance Insights"
        case .teamCollaboration: return "Team Collaboration"
        case .customIntegrations: return "Custom Integrations"
        case .teamReports: return "Team Reports"
        case .adminControls: return "Admin Controls"
        case .allTeamFeatures: return "All Team Features"
        case .whiteLabelOptions: return "White Label Options"
        case .customBranding: return "Custom Branding"
        case .dedicatedSupport: return "Dedicated Support"
        case .ssoIntegration: return "SSO Integration"
        case .advancedSecurity: return "Advanced Security"
        case .customWorkflows: return "Custom Workflows"
        case .enterpriseAnalytics: return "Enterprise Analytics"
        }
    }

    var description: String {
        switch self {
        case .basicSkillTracking: return "Track your core professional skills"
        case .limitedAIInsights: return "Get AI-powered insights (5 per month)"
        case .threeCareerGoals: return "Set up to 3 career goals"
        case .basicReports: return "Basic performance reports"
        case .communityAccess: return "Access to StryVr community"
        case .unlimitedAIInsights: return "Unlimited AI-powered career insights"
        case .advancedAnalytics: return "Deep dive into your performance data"
        case .customCareerPaths: return "Create personalized career roadmaps"
        case .prioritySupport: return "Get help when you need it most"
        case .exportReports: return "Export reports in multiple formats"
        case .premiumContent: return "Exclusive learning materials"
        case .advancedGamification: return "Enhanced achievement system"
        case .personalizedCoaching: return "AI-powered career coaching"
        case .professionalReports: return "HR-verified professional reports"
        case .skillAssessments: return "Comprehensive skill evaluations"
        case .allPremiumFeatures: return "Everything in Premium"
        case .teamAnalytics: return "Team performance insights"
        case .managerDashboard: return "Manage your team's growth"
        case .performanceInsights: return "Detailed team analytics"
        case .teamCollaboration: return "Team learning features"
        case .customIntegrations: return "Connect with your tools"
        case .teamReports: return "Comprehensive team reports"
        case .adminControls: return "Advanced team management"
        case .allTeamFeatures: return "Everything in Team"
        case .whiteLabelOptions: return "Customize with your branding"
        case .customBranding: return "Your company's look and feel"
        case .dedicatedSupport: return "Personal account manager"
        case .ssoIntegration: return "Single sign-on integration"
        case .advancedSecurity: return "Enterprise-grade security"
        case .customWorkflows: return "Tailored to your processes"
        case .enterpriseAnalytics: return "Advanced team performance insights"
        }
    }
}

// MARK: - Subscription Model
struct Subscription: Codable, Identifiable {
    let id: String
    let tier: SubscriptionTier
    let startDate: Date
    let endDate: Date?
    let isActive: Bool
    let isTrial: Bool
    let trialEndDate: Date?
    let autoRenew: Bool
    let paymentMethod: PaymentMethod?

    var isExpired: Bool {
        guard let endDate = endDate else { return false }
        return Date() > endDate
    }

    var daysRemaining: Int {
        guard let endDate = endDate else { return 0 }
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: Date(), to: endDate).day ?? 0
    }
}

// MARK: - Payment Method
enum PaymentMethod: String, CaseIterable, Codable {
    case applePay = "apple_pay"
    case creditCard = "credit_card"
    case paypal = "paypal"
    case bankTransfer = "bank_transfer"

    var displayName: String {
        switch self {
        case .applePay: return "Apple Pay"
        case .creditCard: return "Credit Card"
        case .paypal: return "PayPal"
        case .bankTransfer: return "Bank Transfer"
        }
    }
}

// MARK: - Additional Revenue Streams
enum RevenueStream: String, CaseIterable {
    case subscriptions = "subscriptions"
    case certifications = "certifications"
    case coaching = "coaching"
    case premiumContent = "premium_content"
    case consulting = "consulting"
    case whiteLabel = "white_label"
    case apiAccess = "api_access"

    var displayName: String {
        switch self {
        case .subscriptions: return "Subscriptions"
        case .certifications: return "Certification Programs"
        case .coaching: return "Career Coaching"
        case .premiumContent: return "Premium Content"
        case .consulting: return "Consulting Services"
        case .whiteLabel: return "White Label Solutions"
        case .apiAccess: return "API Access"
        }
    }

    var description: String {
        switch self {
        case .subscriptions: return "Monthly/yearly subscription plans"
        case .certifications: return "Industry-recognized certifications"
        case .coaching: return "Professional career coaching"
        case .premiumContent: return "Exclusive learning materials"
        case .consulting: return "Implementation consulting"
        case .whiteLabel: return "Custom branded solutions"
        case .apiAccess: return "API integration services"
        }
    }

    var estimatedRevenue: String {
        switch self {
        case .subscriptions: return "$50K - $500K/year"
        case .certifications: return "$10K - $100K/year"
        case .coaching: return "$20K - $200K/year"
        case .premiumContent: return "$5K - $50K/year"
        case .consulting: return "$100K - $1M/year"
        case .whiteLabel: return "$200K - $2M/year"
        case .apiAccess: return "$50K - $500K/year"
        }
    }
}
