//
//  MarketResearchDashboard.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  📊 Revolutionary Market Research Dashboard - Data-Driven Strategy Validation
//  🎯 Professional Development App Market Intelligence & Competitive Analysis
//

import Charts
import SwiftUI

struct MarketResearchDashboard: View {
    @StateObject private var researchService = MarketResearchValidationService.shared
    @State private var selectedTab: ResearchTab = .overview
    @State private var selectedInsight: MarketInsight?
    @State private var showingInsightDetails = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with key metrics
                researchMetricsHeader

                // Tab Navigation
                researchTabBar

                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    OverviewTab()
                        .tag(ResearchTab.overview)

                    MarketTrendsTab()
                        .tag(ResearchTab.trends)

                    CompetitorAnalysisTab()
                        .tag(ResearchTab.competitors)

                    UserPersonasTab()
                        .tag(ResearchTab.personas)

                    ValidationTab()
                        .tag(ResearchTab.validation)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .background(Theme.Colors.backgroundPrimary)
            .navigationTitle("Market Research")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingInsightDetails) {
                if let insight = selectedInsight {
                    InsightDetailView(insight: insight)
                }
            }
        }
        .environmentObject(researchService)
    }

    // MARK: - Research Metrics Header

    private var researchMetricsHeader: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack(spacing: Theme.Spacing.large) {
                // Market Size
                MetricCard(
                    title: "Market Size",
                    value: "$12.8B",
                    subtitle: "TAM 2024",
                    color: Theme.Colors.neonGreen,
                    icon: "chart.bar.xaxis"
                )

                // StryVr Advantage
                MetricCard(
                    title: "Competitive Edge",
                    value: "94%",
                    subtitle: "Market Alignment",
                    color: Theme.Colors.neonBlue,
                    icon: "star.fill"
                )

                // Projected Growth
                MetricCard(
                    title: "Growth Rate",
                    value: "+23%",
                    subtitle: "Annual",
                    color: Theme.Colors.neonPurple,
                    icon: "chart.line.uptrend.xyaxis"
                )
            }

            // Confidence Score
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(Theme.Colors.neonYellow)
                    .font(.title3)

                Text("Research Confidence")
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()

                Text("89%")
                    .font(Theme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.neonYellow)
            }
            .padding()
            .applyLiquidGlassCard()
        }
        .padding()
    }

    // MARK: - Tab Bar

    private var researchTabBar: some View {
        HStack(spacing: 0) {
            ForEach(ResearchTab.allCases, id: \.self) { tab in
                ResearchTabButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: { selectedTab = tab }
                )
            }
        }
        .padding(.horizontal)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Research Tabs

enum ResearchTab: String, CaseIterable {
    case overview = "Overview"
    case trends = "Trends"
    case competitors = "Competitors"
    case personas = "Personas"
    case validation = "Validation"

    var icon: String {
        switch self {
        case .overview: return "chart.bar.fill"
        case .trends: return "chart.line.uptrend.xyaxis"
        case .competitors: return "building.2.fill"
        case .personas: return "person.3.fill"
        case .validation: return "checkmark.seal.fill"
        }
    }
}

struct ResearchTabButton: View {
    let tab: ResearchTab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(
                        isSelected ? Theme.Colors.neonBlue : Theme.Colors.textSecondary)

                Text(tab.rawValue)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(
                        isSelected ? Theme.Colors.neonBlue : Theme.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Theme.Colors.neonBlue.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Overview Tab

struct OverviewTab: View {
    @EnvironmentObject private var researchService: MarketResearchValidationService

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.large) {
                // Market positioning summary
                marketPositioningCard

                // Key insights
                keyInsightsCard

                // Engagement projections
                engagementProjectionsCard

                // Strategic recommendations
                strategicRecommendationsCard
            }
            .padding()
        }
    }

    private var marketPositioningCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "target")
                    .foregroundColor(Theme.Colors.neonBlue)
                    .font(.title2)

                Text("Market Positioning")
                    .font(Theme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()
            }

            let positioning = researchService.generateMarketPositioning()

            VStack(alignment: .leading, spacing: 12) {
                Text("Unique Value Proposition")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textSecondary)

                Text(positioning.uniqueValueProposition)
                    .font(.body)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding()
                    .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 12))

                HStack(spacing: Theme.Spacing.large) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("TAM")
                            .font(.caption2)
                            .foregroundColor(Theme.Colors.textSecondary)

                        Text("$\(positioning.marketSize, specifier: "%.1f")B")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.Colors.neonGreen)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Target Share")
                            .font(.caption2)
                            .foregroundColor(Theme.Colors.textSecondary)

                        Text("\(Int(positioning.targetMarketShare * 100))%")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.Colors.neonBlue)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Revenue Projection")
                            .font(.caption2)
                            .foregroundColor(Theme.Colors.textSecondary)

                        Text("$\(Int(positioning.revenueProjection))M")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.Colors.neonPurple)
                    }

                    Spacer()
                }
            }
        }
        .padding()
        .applyLiquidGlassCard()
    }

    private var keyInsightsCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(Theme.Colors.neonYellow)
                    .font(.title3)

                Text("Key Market Insights")
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()
            }

            LazyVStack(spacing: 12) {
                ForEach(researchService.marketInsights.prefix(3)) { insight in
                    InsightSummaryRow(insight: insight)
                }
            }
        }
        .padding()
        .applyLiquidGlassCard()
    }

    private var engagementProjectionsCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "chart.bar.xaxis")
                    .foregroundColor(Theme.Colors.neonPink)
                    .font(.title3)

                Text("Engagement Projections")
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()

                Text("vs Industry")
                    .font(.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            EngagementComparisonChart(metrics: researchService.engagementMetrics)
        }
        .padding()
        .applyLiquidGlassCard()
    }

    private var strategicRecommendationsCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(Theme.Colors.neonGreen)
                    .font(.title3)

                Text("Strategic Recommendations")
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()
            }

            LazyVStack(spacing: 8) {
                ForEach(
                    researchService.validationResults.filter {
                        $0.recommendation == .stronglyRecommended
                    }
                ) { result in
                    RecommendationRow(result: result)
                }
            }
        }
        .padding()
        .applyLiquidGlassCard()
    }
}

// MARK: - Market Trends Tab

struct MarketTrendsTab: View {
    @EnvironmentObject private var researchService: MarketResearchValidationService

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.medium) {
                ForEach(researchService.marketTrends) { trend in
                    MarketTrendCard(trend: trend)
                }
            }
            .padding()
        }
    }
}

// MARK: - Competitor Analysis Tab

struct CompetitorAnalysisTab: View {
    @EnvironmentObject private var researchService: MarketResearchValidationService

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.medium) {
                ForEach(researchService.competitorAnalysis) { competitor in
                    CompetitorCard(competitor: competitor)
                }
            }
            .padding()
        }
    }
}

// MARK: - User Personas Tab

struct UserPersonasTab: View {
    @EnvironmentObject private var researchService: MarketResearchValidationService

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.medium) {
                ForEach(researchService.userPersonas) { persona in
                    UserPersonaCard(persona: persona)
                }
            }
            .padding()
        }
    }
}

// MARK: - Validation Tab

struct ValidationTab: View {
    @EnvironmentObject private var researchService: MarketResearchValidationService

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.medium) {
                ForEach(researchService.validationResults) { result in
                    ValidationResultCard(result: result)
                }
            }
            .padding()
        }
    }
}

// MARK: - Supporting Views

struct InsightSummaryRow: View {
    let insight: MarketInsight

    var body: some View {
        HStack {
            Circle()
                .fill(priorityColor)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(insight.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(insight.description)
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .lineLimit(2)
            }

            Spacer()

            Text("\(Int(insight.confidence * 100))%")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(priorityColor)
        }
        .padding(.vertical, 4)
    }

    private var priorityColor: Color {
        switch insight.priority {
        case .low: return Theme.Colors.neonGreen
        case .medium: return Theme.Colors.neonYellow
        case .high: return Theme.Colors.neonOrange
        case .urgent: return Theme.Colors.neonRed
        }
    }
}

struct EngagementComparisonChart: View {
    let metrics: EngagementMetrics

    var body: some View {
        VStack(spacing: 12) {
            EngagementMetricRow(
                title: "Daily Active Users",
                stryVrValue: metrics.projectedDAU,
                industryValue: 0.23,
                color: Theme.Colors.neonBlue
            )

            EngagementMetricRow(
                title: "7-Day Retention",
                stryVrValue: metrics.projected7DayRetention,
                industryValue: 0.42,
                color: Theme.Colors.neonGreen
            )

            EngagementMetricRow(
                title: "Session Length",
                stryVrValue: metrics.projectedSessionLength / 20.0,  // Normalized for display
                industryValue: 8.5 / 20.0,
                color: Theme.Colors.neonPurple
            )

            EngagementMetricRow(
                title: "Conversion Rate",
                stryVrValue: metrics.projectedConversionRate * 10,  // Scale for display
                industryValue: 0.034 * 10,
                color: Theme.Colors.neonYellow
            )
        }
    }
}

struct EngagementMetricRow: View {
    let title: String
    let stryVrValue: Double
    let industryValue: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()

                Text("+\(Int((stryVrValue / industryValue - 1) * 100))%")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }

            HStack(spacing: 4) {
                // StryVr bar
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color)
                        .frame(width: geometry.size.width * stryVrValue)
                }
                .frame(height: 6)

                // Industry bar
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Theme.Colors.textTertiary.opacity(0.5))
                        .frame(width: geometry.size.width * industryValue)
                }
                .frame(height: 6)
            }
        }
    }
}

struct RecommendationRow: View {
    let result: ValidationResult

    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Theme.Colors.neonGreen)
                .font(.body)

            VStack(alignment: .leading, spacing: 2) {
                Text(result.strategy)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(result.rationale)
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .lineLimit(2)
            }

            Spacer()

            Text("\(Int(result.recommendationConfidence * 100))%")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(Theme.Colors.neonGreen)
        }
        .padding(.vertical, 4)
    }
}

struct MarketTrendCard: View {
    let trend: MarketTrend

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(trendColor)
                    .font(.title3)

                Text(trend.name)
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()

                StatusBadge(status: trend.implementationStatus)
            }

            Text(trend.description)
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
                .lineLimit(3)

            HStack(spacing: Theme.Spacing.large) {
                MetricDisplay(
                    title: "Adoption",
                    value: "\(Int(trend.adoptionRate * 100))%",
                    color: trendColor
                )

                MetricDisplay(
                    title: "Growth",
                    value: "+\(Int(trend.growthRate * 100))%",
                    color: trendColor
                )

                MetricDisplay(
                    title: "StryVr Fit",
                    value: "\(Int(trend.relevanceToStryVr * 100))%",
                    color: trendColor
                )

                Spacer()
            }
        }
        .padding()
        .applyLiquidGlassCard()
        .liquidGlassGlow(color: trendColor, radius: 8, intensity: 0.4)
    }

    private var trendColor: Color {
        switch trend.impact {
        case .low: return Theme.Colors.neonGreen
        case .medium: return Theme.Colors.neonYellow
        case .high: return Theme.Colors.neonOrange
        case .critical: return Theme.Colors.neonRed
        }
    }
}

struct StatusBadge: View {
    let status: ImplementationStatus

    var body: some View {
        Text(statusText)
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(statusColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.2), in: Capsule())
    }

    private var statusText: String {
        switch status {
        case .notStarted: return "Not Started"
        case .planned: return "Planned"
        case .inProgress: return "In Progress"
        case .implemented: return "Implemented"
        case .optimizing: return "Optimizing"
        }
    }

    private var statusColor: Color {
        switch status {
        case .notStarted: return Theme.Colors.textTertiary
        case .planned: return Theme.Colors.neonBlue
        case .inProgress: return Theme.Colors.neonYellow
        case .implemented: return Theme.Colors.neonGreen
        case .optimizing: return Theme.Colors.neonPurple
        }
    }
}

struct MetricDisplay: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(title)
                .font(.caption2)
                .foregroundColor(Theme.Colors.textSecondary)
        }
    }
}

struct CompetitorCard: View {
    let competitor: CompetitorInsight

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "building.2.fill")
                    .foregroundColor(categoryColor)
                    .font(.title3)

                Text(competitor.name)
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(competitor.userRating, specifier: "%.1f")★")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.neonYellow)

                    Text("\(Int(competitor.marketShare * 100))% share")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }

            // Strengths and weaknesses
            HStack(spacing: Theme.Spacing.medium) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Strengths")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.neonGreen)

                    ForEach(competitor.strengths.prefix(2), id: \.self) { strength in
                        Text("• \(strength)")
                            .font(.caption2)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Weaknesses")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.neonOrange)

                    ForEach(competitor.weaknesses.prefix(2), id: \.self) { weakness in
                        Text("• \(weakness)")
                            .font(.caption2)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }
            }

            // StryVr advantages
            VStack(alignment: .leading, spacing: 4) {
                Text("StryVr Advantages")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.neonBlue)

                ForEach(competitor.stryVrAdvantages.prefix(3), id: \.self) { advantage in
                    Text("• \(advantage)")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }
        }
        .padding()
        .applyLiquidGlassCard()
        .liquidGlassGlow(color: categoryColor, radius: 8, intensity: 0.4)
    }

    private var categoryColor: Color {
        switch competitor.category {
        case .directCompetitor: return Theme.Colors.neonRed
        case .indirectCompetitor: return Theme.Colors.neonYellow
        case .adjacentMarket: return Theme.Colors.neonGreen
        }
    }
}

struct UserPersonaCard: View {
    let persona: UserPersona

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(fitColor)
                    .font(.title2)

                VStack(alignment: .leading, spacing: 2) {
                    Text(persona.name)
                        .font(Theme.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text("\(persona.ageRange) • \(persona.role)")
                        .font(.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                Text("\(Int(persona.stryVrFit * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(fitColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(fitColor.opacity(0.2), in: Capsule())
            }

            // Goals
            VStack(alignment: .leading, spacing: 4) {
                Text("Goals")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.neonGreen)

                ForEach(persona.goals.prefix(3), id: \.self) { goal in
                    Text("• \(goal)")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }

            // Pain points
            VStack(alignment: .leading, spacing: 4) {
                Text("Pain Points")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.neonOrange)

                ForEach(persona.painPoints.prefix(3), id: \.self) { painPoint in
                    Text("• \(painPoint)")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }

            // Preferences
            HStack {
                ForEach(persona.preferences.prefix(3), id: \.self) { preference in
                    Text(preference)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.Colors.neonBlue)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Theme.Colors.neonBlue.opacity(0.2), in: Capsule())
                }

                Spacer()
            }
        }
        .padding()
        .applyLiquidGlassCard()
        .liquidGlassGlow(color: fitColor, radius: 8, intensity: 0.4)
    }

    private var fitColor: Color {
        if persona.stryVrFit > 0.9 { return Theme.Colors.neonGreen }
        if persona.stryVrFit > 0.8 { return Theme.Colors.neonBlue }
        if persona.stryVrFit > 0.7 { return Theme.Colors.neonYellow }
        return Theme.Colors.neonOrange
    }
}

struct ValidationResultCard: View {
    let result: ValidationResult

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(Theme.Colors.fromString(result.recommendation.color))
                    .font(.title3)

                Text(result.strategy)
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()

                Text(result.recommendation.displayName)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.fromString(result.recommendation.color))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Theme.Colors.fromString(result.recommendation.color).opacity(0.2),
                        in: Capsule())
            }

            Text(result.rationale)
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
                .lineLimit(3)

            HStack(spacing: Theme.Spacing.large) {
                ValidationMetric(
                    title: "Market Demand",
                    value: result.marketDemand,
                    color: Theme.Colors.neonBlue
                )

                ValidationMetric(
                    title: "Differentiation",
                    value: result.competitiveDifferentiation,
                    color: Theme.Colors.neonGreen
                )

                ValidationMetric(
                    title: "ROI",
                    value: result.expectedROI,
                    color: Theme.Colors.neonPurple
                )

                Spacer()
            }

            // Confidence bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Confidence")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)

                    Spacer()

                    Text("\(Int(result.recommendationConfidence * 100))%")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.fromString(result.recommendation.color))
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Theme.Colors.glassPrimary)
                            .frame(height: 4)

                        RoundedRectangle(cornerRadius: 2)
                            .fill(Theme.Colors.fromString(result.recommendation.color))
                            .frame(
                                width: geometry.size.width * result.recommendationConfidence,
                                height: 4
                            )
                            .animation(.spring(), value: result.recommendationConfidence)
                    }
                }
                .frame(height: 4)
            }
        }
        .padding()
        .applyLiquidGlassCard()
        .liquidGlassGlow(
            color: Theme.Colors.fromString(result.recommendation.color), radius: 8, intensity: 0.4)
    }
}

struct ValidationMetric: View {
    let title: String
    let value: Double
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text("\(Int(value * 100))%")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(title)
                .font(.caption2)
                .foregroundColor(Theme.Colors.textSecondary)
        }
    }
}

// MARK: - Insight Detail View

struct InsightDetailView: View {
    let insight: MarketInsight
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    // Insight header
                    VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(Theme.Colors.neonYellow)
                                .font(.title2)

                            Text(insight.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.Colors.textPrimary)

                            Spacer()
                        }

                        Text(insight.description)
                            .font(.body)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    .padding()
                    .applyLiquidGlassCard()

                    // Data points
                    VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                        Text("Key Data Points")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.Colors.textPrimary)

                        LazyVStack(spacing: 8) {
                            ForEach(insight.dataPoints, id: \.self) { dataPoint in
                                HStack {
                                    Image(systemName: "chart.bar.fill")
                                        .foregroundColor(Theme.Colors.neonBlue)
                                        .font(.body)

                                    Text(dataPoint)
                                        .font(.body)
                                        .foregroundColor(Theme.Colors.textPrimary)

                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding()
                    .applyLiquidGlassCard()

                    // Implications
                    VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                        Text("Strategic Implications")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.Colors.textPrimary)

                        LazyVStack(spacing: 8) {
                            ForEach(insight.implications, id: \.self) { implication in
                                HStack {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .foregroundColor(Theme.Colors.neonGreen)
                                        .font(.body)

                                    Text(implication)
                                        .font(.body)
                                        .foregroundColor(Theme.Colors.textPrimary)

                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding()
                    .applyLiquidGlassCard()

                    // Action items
                    VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                        Text("Recommended Actions")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.Colors.textPrimary)

                        LazyVStack(spacing: 8) {
                            ForEach(insight.actionItems, id: \.self) { actionItem in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Theme.Colors.neonYellow)
                                        .font(.body)

                                    Text(actionItem)
                                        .font(.body)
                                        .foregroundColor(Theme.Colors.textPrimary)

                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding()
                    .applyLiquidGlassCard()
                }
                .padding()
            }
            .navigationTitle("Market Insight")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    MarketResearchDashboard()
}
