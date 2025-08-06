//
//  NavigationCoordinator.swift
//  StryVr
//
//  Created by Joe Dormond on 8/1/25.
//  🧭 View factory and navigation coordination for StryVr app
//

import SwiftUI

/// Coordinates navigation between views and handles view creation
@MainActor
struct NavigationCoordinator {
    
    /// Shared router instance
    let router: AppRouter
    
    // MARK: - View Factory
    
    /// Creates the appropriate view for a given destination
    @ViewBuilder
    func view(for destination: AppDestination) -> some View {
        switch destination {
            
        // MARK: - Core App Views
        case .dashboard:
            DashboardView()
                .environmentObject(router)
            
        case .profile(let userId):
            ProfileView(userId: userId)
                .environmentObject(router)
            
        case .settings:
            SettingsView()
                .environmentObject(router)
            
        // MARK: - Reports & Analytics
        case .reports:
            ReportsView()
                .environmentObject(router)
            
        case .reportDetail(let reportId, let userId):
            ReportDetailView(reportId: reportId, userId: userId)
                .environmentObject(router)
            
        case .reportShare(let reportId):
            ReportShareView(reportId: reportId)
                .environmentObject(router)
            
        case .analytics(let userId):
            AnalyticsView(userId: userId)
                .environmentObject(router)
            
        case .performanceDetail(let metricId, let timeframe):
            PerformanceDetailView(metricId: metricId, timeframe: timeframe)
                .environmentObject(router)
            
        // MARK: - Career Development
        case .careerGoals(let userId):
            CareerGoalsView(userId: userId)
                .environmentObject(router)
            
        case .skillAssessment(let assessmentId):
            SkillAssessmentView(assessmentId: assessmentId)
                .environmentObject(router)
            
        case .careerAdvice(let userId):
            CareerAdviceView(userId: userId)
                .environmentObject(router)
            
        case .learningPath(let pathId):
            LearningPathView(pathId: pathId)
                .environmentObject(router)
            
        // MARK: - AI & Recommendations
        case .aiInsights(let userId):
            AIInsightsView(userId: userId)
                .environmentObject(router)
            
        case .personalizedRecommendations(let userId):
            PersonalizedRecommendationsView(userId: userId)
                .environmentObject(router)
            
        case .careerPredictions(let userId):
            CareerPredictionsView(userId: userId)
                .environmentObject(router)
            
        // MARK: - Subscription & Monetization
        case .subscription:
            SubscriptionView()
                .environmentObject(router)
            
        case .subscriptionManagement:
            SubscriptionManagementView()
                .environmentObject(router)
            
        case .pricing:
            PricingView()
                .environmentObject(router)
            
        case .paywall(let feature):
            PaywallView(feature: feature)
                .environmentObject(router)
            
        // MARK: - Onboarding & Authentication
        case .onboarding(let step):
            OnboardingView(step: step)
                .environmentObject(router)
            
        case .login:
            LoginView()
                .environmentObject(router)
            
        case .signup:
            SignupView()
                .environmentObject(router)
            
        case .emailVerification(let email):
            EmailVerificationView(email: email)
                .environmentObject(router)
            
        case .resetPassword:
            ResetPasswordView()
                .environmentObject(router)
            
        // MARK: - HR Integration & Verification
        case .hrVerification(let employerId):
            HRVerificationView(employerId: employerId)
                .environmentObject(router)
            
        case .employerDashboard(let employerId):
            EmployerDashboardView(employerId: employerId)
                .environmentObject(router)
            
        case .workplaceMetrics(let workplaceId):
            WorkplaceMetricsView(workplaceId: workplaceId)
                .environmentObject(router)
            
        case .teamAnalytics(let teamId):
            TeamAnalyticsView(teamId: teamId)
                .environmentObject(router)
            
        // MARK: - Social & Sharing
        case .shareProfile(let userId):
            ShareProfileView(userId: userId)
                .environmentObject(router)
            
        case .exportReport(let reportId, let format):
            ExportReportView(reportId: reportId, format: format)
                .environmentObject(router)
            
        case .deepLinkShare(let type, let id):
            DeepLinkShareView(type: type, id: id)
                .environmentObject(router)
            
        // MARK: - Support & Help
        case .help:
            HelpView()
                .environmentObject(router)
            
        case .support:
            SupportView()
                .environmentObject(router)
            
        case .feedback:
            FeedbackView()
                .environmentObject(router)
            
        case .about:
            AboutView()
                .environmentObject(router)
            
        case .privacyPolicy:
            PrivacyPolicyView()
                .environmentObject(router)
            
        case .termsOfService:
            TermsOfServiceView()
                .environmentObject(router)
        }
    }
}

// MARK: - Navigation Helpers

extension NavigationCoordinator {
    
    /// Apply liquid glass styling to navigation views
    @ViewBuilder
    func styledNavigationView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
    
    /// Create a navigation view with custom back button
    @ViewBuilder
    func customNavigationView<Content: View>(
        title: String,
        showBackButton: Bool = true,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if showBackButton {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            router.navigateBack()
                        } label: {
                            Image(systemName: "chevron.left")
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        .liquidGlassButton()
                    }
                }
            }
    }
}

// MARK: - Placeholder Views

/// Placeholder views for destinations that don't have implemented views yet
private struct PlaceholderView: View {
    let title: String
    let destination: AppDestination
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gear")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("This view is under development")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Go Back") {
                router.navigateBack()
            }
            .liquidGlassButton()
            .padding(.horizontal)
        }
        .padding()
        .liquidGlassCard()
        .padding()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Temporary View Implementations

// These are placeholder implementations - replace with actual views as they're built

private struct DashboardView: View {
    var body: some View {
        PlaceholderView(title: "Dashboard", destination: .dashboard)
    }
}

private struct ProfileView: View {
    let userId: String
    var body: some View {
        PlaceholderView(title: "Profile", destination: .profile(userId: userId))
    }
}

private struct SettingsView: View {
    var body: some View {
        PlaceholderView(title: "Settings", destination: .settings)
    }
}

private struct AnalyticsView: View {
    let userId: String
    var body: some View {
        PlaceholderView(title: "Analytics", destination: .analytics(userId: userId))
    }
}

private struct ReportDetailView: View {
    let reportId: String
    let userId: String
    var body: some View {
        PlaceholderView(title: "Report Detail", destination: .reportDetail(reportId: reportId, userId: userId))
    }
}

private struct ReportShareView: View {
    let reportId: String
    var body: some View {
        PlaceholderView(title: "Share Report", destination: .reportShare(reportId: reportId))
    }
}

private struct PerformanceDetailView: View {
    let metricId: String
    let timeframe: String
    var body: some View {
        PlaceholderView(title: "Performance Detail", destination: .performanceDetail(metricId: metricId, timeframe: timeframe))
    }
}

private struct CareerGoalsView: View {
    let userId: String
    var body: some View {
        PlaceholderView(title: "Career Goals", destination: .careerGoals(userId: userId))
    }
}

private struct SkillAssessmentView: View {
    let assessmentId: String
    var body: some View {
        PlaceholderView(title: "Skill Assessment", destination: .skillAssessment(assessmentId: assessmentId))
    }
}

private struct CareerAdviceView: View {
    let userId: String
    var body: some View {
        PlaceholderView(title: "Career Advice", destination: .careerAdvice(userId: userId))
    }
}

private struct LearningPathView: View {
    let pathId: String
    var body: some View {
        PlaceholderView(title: "Learning Path", destination: .learningPath(pathId: pathId))
    }
}

private struct AIInsightsView: View {
    let userId: String
    var body: some View {
        PlaceholderView(title: "AI Insights", destination: .aiInsights(userId: userId))
    }
}

private struct PersonalizedRecommendationsView: View {
    let userId: String
    var body: some View {
        PlaceholderView(title: "Recommendations", destination: .personalizedRecommendations(userId: userId))
    }
}

private struct CareerPredictionsView: View {
    let userId: String
    var body: some View {
        PlaceholderView(title: "Career Predictions", destination: .careerPredictions(userId: userId))
    }
}

private struct SubscriptionView: View {
    var body: some View {
        PlaceholderView(title: "Subscription", destination: .subscription)
    }
}

private struct SubscriptionManagementView: View {
    var body: some View {
        PlaceholderView(title: "Manage Subscription", destination: .subscriptionManagement)
    }
}

private struct PricingView: View {
    var body: some View {
        PlaceholderView(title: "Pricing", destination: .pricing)
    }
}

private struct PaywallView: View {
    let feature: String
    var body: some View {
        PlaceholderView(title: "Upgrade", destination: .paywall(feature: feature))
    }
}

private struct OnboardingView: View {
    let step: Int
    var body: some View {
        PlaceholderView(title: "Onboarding", destination: .onboarding(step: step))
    }
}

private struct LoginView: View {
    var body: some View {
        PlaceholderView(title: "Login", destination: .login)
    }
}

private struct SignupView: View {
    var body: some View {
        PlaceholderView(title: "Sign Up", destination: .signup)
    }
}

private struct EmailVerificationView: View {
    let email: String
    var body: some View {
        PlaceholderView(title: "Verify Email", destination: .emailVerification(email: email))
    }
}

private struct ResetPasswordView: View {
    var body: some View {
        PlaceholderView(title: "Reset Password", destination: .resetPassword)
    }
}

private struct HRVerificationView: View {
    let employerId: String
    var body: some View {
        PlaceholderView(title: "HR Verification", destination: .hrVerification(employerId: employerId))
    }
}

private struct EmployerDashboardView: View {
    let employerId: String
    var body: some View {
        PlaceholderView(title: "Employer Dashboard", destination: .employerDashboard(employerId: employerId))
    }
}

private struct WorkplaceMetricsView: View {
    let workplaceId: String
    var body: some View {
        PlaceholderView(title: "Workplace Metrics", destination: .workplaceMetrics(workplaceId: workplaceId))
    }
}

private struct TeamAnalyticsView: View {
    let teamId: String
    var body: some View {
        PlaceholderView(title: "Team Analytics", destination: .teamAnalytics(teamId: teamId))
    }
}

private struct ShareProfileView: View {
    let userId: String
    var body: some View {
        PlaceholderView(title: "Share Profile", destination: .shareProfile(userId: userId))
    }
}

private struct ExportReportView: View {
    let reportId: String
    let format: ExportFormat
    var body: some View {
        PlaceholderView(title: "Export Report", destination: .exportReport(reportId: reportId, format: format))
    }
}

private struct DeepLinkShareView: View {
    let type: ShareType
    let id: String
    var body: some View {
        PlaceholderView(title: "Share", destination: .deepLinkShare(type: type, id: id))
    }
}

private struct HelpView: View {
    var body: some View {
        PlaceholderView(title: "Help", destination: .help)
    }
}

private struct SupportView: View {
    var body: some View {
        PlaceholderView(title: "Support", destination: .support)
    }
}

private struct FeedbackView: View {
    var body: some View {
        PlaceholderView(title: "Feedback", destination: .feedback)
    }
}

private struct AboutView: View {
    var body: some View {
        PlaceholderView(title: "About", destination: .about)
    }
}

private struct PrivacyPolicyView: View {
    var body: some View {
        PlaceholderView(title: "Privacy Policy", destination: .privacyPolicy)
    }
}

private struct TermsOfServiceView: View {
    var body: some View {
        PlaceholderView(title: "Terms of Service", destination: .termsOfService)
    }
}