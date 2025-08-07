//
//  AIInsightsView.swift
//  StryVr
//
//  Created by Joe Dormond on 8/1/25.
//  🧠 AI-powered insights and personalized career recommendations
//

import SwiftUI

struct AIInsightsView: View {
    let userId: String
    
    @EnvironmentObject var router: AppRouter
    @StateObject private var viewModel = AIInsightsViewModel()
    @State private var selectedInsightType: InsightType = .careerGrowth
    @State private var showingDetailView = false
    @State private var selectedRecommendation: AIRecommendation?
    @Namespace private var animationNamespace
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // AI Status Header
                aiStatusHeader
                
                // Insight Type Selector
                insightTypeSelector
                
                // Main Insights Content
                mainInsightsContent
                
                // Quick Actions
                quickActionsSection
                
                // Recent Activity Feed
                recentActivitySection
            }
            .padding()
        }
        .background(aiGradientBackground)
        .navigationTitle("AI Insights")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.refreshInsights()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(Theme.Colors.textPrimary)
                }
                .liquidGlassButton()
            }
        }
        .onAppear {
            viewModel.loadInsights(for: userId)
        }
        .sheet(item: $selectedRecommendation) { recommendation in
            AIRecommendationDetailView(recommendation: recommendation)
                .environmentObject(router)
        }
    }
    
    // MARK: - AI Status Header
    
    private var aiStatusHeader: some View {
        VStack(spacing: 16) {
            // AI Brain Animation
            ZStack {
                Circle()
                    .fill(Theme.Colors.glassPrimary)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "brain.head.profile.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Theme.Colors.neonGreen)
                    .symbolEffect(.pulse.byLayer, options: .repeating)
            }
            .neonGlow(color: Theme.Colors.neonGreen, pulse: true)
            
            VStack(spacing: 8) {
                Text("AI Analysis Complete")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text("Based on your performance data and industry trends")
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                
                // Confidence Score
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(Theme.Colors.neonGreen)
                    
                    Text("95% Confidence")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Insight Type Selector
    
    private var insightTypeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(InsightType.allCases, id: \.self) { type in
                    InsightTypeButton(
                        type: type,
                        isSelected: selectedInsightType == type,
                        action: {
                            withAnimation(.spring()) {
                                selectedInsightType = type
                            }
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Main Insights Content
    
    @ViewBuilder
    private var mainInsightsContent: some View {
        switch selectedInsightType {
        case .careerGrowth:
            careerGrowthInsights
        case .skillDevelopment:
            skillDevelopmentInsights
        case .marketTrends:
            marketTrendsInsights
        case .salaryOptimization:
            salaryOptimizationInsights
        }
    }
    
    private var careerGrowthInsights: some View {
        VStack(spacing: 16) {
            // Career Path Prediction
            CareerPathCard(
                currentRole: "Senior iOS Developer",
                nextRole: "Lead iOS Developer",
                timeframe: "6-12 months",
                probability: 0.85,
                namespace: animationNamespace
            ) {
                router.navigate(to: .careerPredictions(userId: userId))
            }
            
            // Growth Opportunities
            VStack(alignment: .leading, spacing: 12) {
                Text("Growth Opportunities")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                ForEach(viewModel.growthOpportunities, id: \.id) { opportunity in
                    GrowthOpportunityCard(opportunity: opportunity)
                }
            }
        }
    }
    
    private var skillDevelopmentInsights: some View {
        VStack(spacing: 16) {
            // Skill Gap Analysis
            SkillGapAnalysisCard(gaps: viewModel.skillGaps)
            
            // Recommended Learning Paths
            VStack(alignment: .leading, spacing: 12) {
                Text("Recommended Learning")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                ForEach(viewModel.learningRecommendations, id: \.id) { recommendation in
                    LearningPathCard(recommendation: recommendation) {
                        router.navigate(to: .learningPath(pathId: recommendation.id))
                    }
                }
            }
        }
    }
    
    private var marketTrendsInsights: some View {
        VStack(spacing: 16) {
            // Industry Trends
            MarketTrendsCard(trends: viewModel.marketTrends)
            
            // Salary Benchmarks
            SalaryBenchmarkCard(
                currentSalary: viewModel.currentSalary,
                marketAverage: viewModel.marketAverage,
                topPercentile: viewModel.topPercentile
            )
        }
    }
    
    private var salaryOptimizationInsights: some View {
        VStack(spacing: 16) {
            // Salary Optimization
            SalaryOptimizationCard(
                currentSalary: viewModel.currentSalary,
                potentialIncrease: viewModel.potentialSalaryIncrease,
                recommendations: viewModel.salaryRecommendations
            )
            
            // Negotiation Tips
            NegotiationTipsCard(tips: viewModel.negotiationTips)
        }
    }
    
    // MARK: - Quick Actions
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                AIActionCard(
                    title: "Career Goals",
                    icon: "target",
                    color: Theme.Colors.neonBlue
                ) {
                    router.navigate(to: .careerGoals(userId: userId))
                }
                
                AIActionCard(
                    title: "Skill Assessment",
                    icon: "brain",
                    color: Theme.Colors.neonGreen
                ) {
                    router.navigate(to: .skillAssessment(assessmentId: "new"))
                }
                
                AIActionCard(
                    title: "Career Advice",
                    icon: "lightbulb.fill",
                    color: Theme.Colors.neonYellow
                ) {
                    router.navigate(to: .careerAdvice(userId: userId))
                }
                
                AIActionCard(
                    title: "Analytics",
                    icon: "chart.bar.fill",
                    color: Theme.Colors.neonOrange
                ) {
                    router.navigate(to: .analytics(userId: userId))
                }
            }
        }
    }
    
    // MARK: - Recent Activity
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent AI Activity")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ForEach(viewModel.recentActivities, id: \.id) { activity in
                ActivityCard(activity: activity)
            }
        }
    }
    
    // MARK: - Background
    
    private var aiGradientBackground: some View {
        LinearGradient(
            colors: [
                Theme.Colors.deepNavyBlue,
                Theme.Colors.softCharcoalGray,
                Theme.Colors.subtleLightGray
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Supporting Types

enum InsightType: String, CaseIterable {
    case careerGrowth = "Career Growth"
    case skillDevelopment = "Skill Development"
    case marketTrends = "Market Trends"
    case salaryOptimization = "Salary Optimization"
    
    var icon: String {
        switch self {
        case .careerGrowth: return "arrow.up.right"
        case .skillDevelopment: return "brain.head.profile"
        case .marketTrends: return "chart.line.uptrend.xyaxis"
        case .salaryOptimization: return "dollarsign.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .careerGrowth: return Theme.Colors.neonBlue
        case .skillDevelopment: return Theme.Colors.neonGreen
        case .marketTrends: return Theme.Colors.neonOrange
        case .salaryOptimization: return Theme.Colors.neonYellow
        }
    }
}

// MARK: - Component Views

private struct InsightTypeButton: View {
    let type: InsightType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: type.icon)
                    .foregroundColor(isSelected ? .white : type.color)
                
                Text(type.rawValue)
                    .font(Theme.Typography.caption)
                    .foregroundColor(isSelected ? .white : Theme.Colors.textPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(
            Group {
                if isSelected {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(type.color)
                        .neonGlow(color: type.color)
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Theme.Colors.glassPrimary)
                }
            }
        )
        .animation(.spring(), value: isSelected)
    }
}

private struct CareerPathCard: View {
    let currentRole: String
    let nextRole: String
    let timeframe: String
    let probability: Double
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                HStack {
                    Text("Career Path Prediction")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Spacer()
                    
                    Text("\(Int(probability * 100))%")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.neonGreen)
                }
                
                HStack {
                    // Current Role
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                        
                        Text(currentRole)
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                    
                    Spacer()
                    
                    // Arrow
                    Image(systemName: "arrow.right")
                        .foregroundColor(Theme.Colors.neonBlue)
                        .symbolEffect(.pulse)
                    
                    Spacer()
                    
                    // Next Role
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Predicted")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                        
                        Text(nextRole)
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                }
                
                Text("Timeline: \(timeframe)")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            .padding()
        }
        .liquidGlassCard()
        .neonGlow(color: Theme.Colors.neonBlue.opacity(0.3))
    }
}

private struct AIActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, minHeight: 80)
        }
        .liquidGlassCard()
        .neonGlow(color: color.opacity(0.3))
    }
}

// MARK: - Placeholder Components (to be implemented)

private struct GrowthOpportunityCard: View {
    let opportunity: GrowthOpportunity
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(opportunity.title)
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text(opportunity.description)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            Spacer()
            
            Text(opportunity.impact)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.neonGreen)
        }
        .padding()
        .liquidGlassCard()
    }
}

private struct SkillGapAnalysisCard: View {
    let gaps: [SkillGap]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Skill Gap Analysis")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ForEach(gaps, id: \.skill) { gap in
                HStack {
                    Text(gap.skill)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Spacer()
                    
                    Text("Gap: \(gap.gapLevel)%")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.neonOrange)
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
}

private struct LearningPathCard: View {
    let recommendation: LearningRecommendation
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(recommendation.title)
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text("\(recommendation.duration) • \(recommendation.difficulty)")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            .padding()
        }
        .liquidGlassCard()
    }
}

private struct MarketTrendsCard: View {
    let trends: [MarketTrend]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Industry Trends")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ForEach(trends, id: \.name) { trend in
                HStack {
                    Text(trend.name)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Spacer()
                    
                    Text(trend.changePercentage > 0 ? "+\(trend.changePercentage)%" : "\(trend.changePercentage)%")
                        .foregroundColor(trend.changePercentage > 0 ? Theme.Colors.neonGreen : Theme.Colors.neonOrange)
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
}

private struct SalaryBenchmarkCard: View {
    let currentSalary: Int
    let marketAverage: Int
    let topPercentile: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Salary Benchmark")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            VStack(spacing: 8) {
                SalaryRow(title: "Your Salary", amount: currentSalary, color: .white)
                SalaryRow(title: "Market Average", amount: marketAverage, color: Theme.Colors.neonBlue)
                SalaryRow(title: "Top 10%", amount: topPercentile, color: Theme.Colors.neonGreen)
            }
        }
        .padding()
        .liquidGlassCard()
    }
}

private struct SalaryRow: View {
    let title: String
    let amount: Int
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(Theme.Colors.textSecondary)
            
            Spacer()
            
            Text("$\(amount.formatted())")
                .foregroundColor(color)
                .fontWeight(.semibold)
        }
    }
}

private struct SalaryOptimizationCard: View {
    let currentSalary: Int
    let potentialIncrease: Int
    let recommendations: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Salary Optimization")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            HStack {
                Text("Potential Increase:")
                    .foregroundColor(Theme.Colors.textSecondary)
                
                Spacer()
                
                Text("+$\(potentialIncrease.formatted())")
                    .foregroundColor(Theme.Colors.neonGreen)
                    .fontWeight(.bold)
            }
            
            ForEach(recommendations, id: \.self) { recommendation in
                Text("• \(recommendation)")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
        .padding()
        .liquidGlassCard()
    }
}

private struct NegotiationTipsCard: View {
    let tips: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Negotiation Tips")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ForEach(tips, id: \.self) { tip in
                Text("💡 \(tip)")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
        .padding()
        .liquidGlassCard()
    }
}

private struct ActivityCard: View {
    let activity: AIActivity
    
    var body: some View {
        HStack {
            Image(systemName: activity.icon)
                .foregroundColor(activity.color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.title)
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text(activity.timestamp)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            Spacer()
        }
        .padding()
        .liquidGlassCard()
    }
}

#Preview {
    NavigationStack {
        AIInsightsView(userId: "sample_user")
            .environmentObject(AppRouter())
    }
}
