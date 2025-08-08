//
//  CoachingDashboardView.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  🎯 Revolutionary AI Coaching Dashboard - Real-Time Performance Insights
//  📈 Career Path Visualization & Personal Development Tracking
//

import Charts
import SwiftUI

struct CoachingDashboardView: View {
    @StateObject private var coachingService = AICoachingService.shared
    @State private var selectedTimeframe: TimeframeFilter = .week
    @State private var selectedMetric: PerformanceMetricType = .communicationClarity
    @State private var showingCareerPath = false
    @State private var showingCoachingSession = false
    @Namespace private var dashboardNamespace

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.LiquidGlass.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Theme.Spacing.large) {
                        // Header with live coaching status
                        coachingStatusHeader

                        // Quick action cards
                        quickActionCards

                        // Performance overview
                        performanceOverviewSection

                        // Career path progress
                        careerPathSection

                        // Recent insights
                        recentInsightsSection

                        // Coaching history
                        coachingHistorySection
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.top, Theme.Spacing.medium)
                }
            }
            .navigationTitle("AI Coaching")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCoachingSession = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Theme.Colors.neonBlue)
                            .font(.title2)
                            .neonGlow(color: Theme.Colors.neonBlue, pulse: true)
                    }
                }
            }
        }
        .sheet(isPresented: $showingCareerPath) {
            CareerPathDetailView()
        }
        .sheet(isPresented: $showingCoachingSession) {
            StartCoachingSessionView()
        }
        .onAppear {
            coachingService.generateCareerPathRecommendations()
        }
    }

    // MARK: - Coaching Status Header
    private var coachingStatusHeader: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Your Coaching Journey")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)

                    if coachingService.activeCoachingSessions.isEmpty {
                        Text("Ready for your next session")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    } else {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Theme.Colors.neonGreen)
                                .frame(width: 8, height: 8)
                                .neonGlow(color: Theme.Colors.neonGreen, pulse: true)

                            Text(
                                "\(coachingService.activeCoachingSessions.count) active session\(coachingService.activeCoachingSessions.count == 1 ? "" : "s")"
                            )
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.neonGreen)
                        }
                    }
                }

                Spacer()

                // Coaching score circle
                ZStack {
                    Circle()
                        .stroke(Theme.Colors.glassPrimary, lineWidth: 8)
                        .frame(width: 60, height: 60)

                    Circle()
                        .trim(from: 0, to: coachingService.performanceMetrics.overallScore / 100)
                        .stroke(
                            LinearGradient(
                                colors: [Theme.Colors.neonBlue, Theme.Colors.neonGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                        .animation(
                            .spring(), value: coachingService.performanceMetrics.overallScore)

                    Text("\(Int(coachingService.performanceMetrics.overallScore))")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.textPrimary)
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }

    // MARK: - Quick Action Cards
    private var quickActionCards: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: 2),
            spacing: Theme.Spacing.medium
        ) {
            QuickActionCard(
                title: "Start Session",
                subtitle: "Begin AI coaching",
                icon: "play.circle.fill",
                color: Theme.Colors.neonGreen,
                action: { showingCoachingSession = true }
            )

            QuickActionCard(
                title: "Career Path",
                subtitle: "View progress",
                icon: "map.fill",
                color: Theme.Colors.neonBlue,
                action: { showingCareerPath = true }
            )

            QuickActionCard(
                title: "Practice Mode",
                subtitle: "Solo training",
                icon: "brain.head.profile",
                color: Theme.Colors.neonPink,
                action: { /* Handle practice mode */  }
            )

            QuickActionCard(
                title: "Insights",
                subtitle: "\(coachingService.coachingInsights.count) new",
                icon: "lightbulb.fill",
                color: Theme.Colors.neonYellow,
                action: { /* Handle insights */  }
            )
        }
    }

    // MARK: - Performance Overview
    private var performanceOverviewSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(Theme.Colors.neonBlue)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonBlue, pulse: true)

                Text("Performance Overview")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()

                // Timeframe picker
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(TimeframeFilter.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue).tag(timeframe)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 160)
            }

            // Performance metrics grid
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 2),
                spacing: Theme.Spacing.medium
            ) {
                ForEach(
                    [
                        PerformanceMetricType.communicationClarity, .meetingParticipation,
                        .leadershipPresence, .technicalExplanation,
                    ], id: \.self
                ) { metric in
                    PerformanceMetricCard(
                        metric: metric,
                        isSelected: selectedMetric == metric,
                        value: getMetricValue(metric),
                        trend: getMetricTrend(metric),
                        action: { selectedMetric = metric }
                    )
                    .matchedGeometryEffect(id: "metric-\(metric)", in: dashboardNamespace)
                }
            }

            // Detailed chart for selected metric
            if selectedMetric != .communicationClarity {
                performanceChartView
            }
        }
        .padding()
        .liquidGlassCard()
    }

    private var performanceChartView: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            Text(selectedMetric.displayName + " Trend")
                .font(Theme.Typography.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)

            Chart {
                ForEach(getPerformanceData(for: selectedMetric), id: \.date) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Score", dataPoint.value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Theme.Colors.neonBlue, Theme.Colors.neonGreen],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .interpolationMethod(.catmullRom)

                    AreaMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Score", dataPoint.value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Theme.Colors.neonBlue.opacity(0.3),
                                Theme.Colors.neonGreen.opacity(0.1),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 150)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisValueLabel(format: .dateTime.month().day())
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
            }
            .chartYAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
            }
        }
        .padding(.top, Theme.Spacing.medium)
    }

    // MARK: - Career Path Section
    private var careerPathSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "map.fill")
                    .foregroundColor(Theme.Colors.neonGreen)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonGreen, pulse: true)

                Text("Career Path Progress")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()

                Button("View All") {
                    showingCareerPath = true
                }
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.neonGreen)
            }

            if coachingService.careerPathRecommendations.isEmpty {
                EmptyCareerPathView()
            } else {
                ForEach(coachingService.careerPathRecommendations.prefix(2)) { path in
                    CareerPathProgressCard(path: path) {
                        showingCareerPath = true
                    }
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }

    // MARK: - Recent Insights Section
    private var recentInsightsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(Theme.Colors.neonYellow)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonYellow, pulse: true)

                Text("Recent Insights")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()

                if !coachingService.coachingInsights.isEmpty {
                    Text("\(coachingService.coachingInsights.count) insights")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }

            if coachingService.coachingInsights.isEmpty {
                EmptyInsightsView()
            } else {
                ForEach(coachingService.coachingInsights.prefix(3)) { insight in
                    CoachingInsightCard(insight: insight)
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }

    // MARK: - Coaching History Section
    private var coachingHistorySection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(Theme.Colors.neonOrange)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonOrange, pulse: true)

                Text("Recent Sessions")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()
            }

            // Mock recent sessions
            ForEach(getMockRecentSessions()) { session in
                RecentSessionCard(session: session)
            }
        }
        .padding()
        .liquidGlassCard()
    }

    // MARK: - Helper Methods

    private func getMetricValue(_ metric: PerformanceMetricType) -> Double {
        let history = coachingService.getPerformanceHistory(
            for: metric, days: selectedTimeframe.days)
        return history.map { $0.value }.average()
    }

    private func getMetricTrend(_ metric: PerformanceMetricType) -> TrendDirection {
        let history = coachingService.getPerformanceHistory(
            for: metric, days: selectedTimeframe.days)
        guard history.count >= 2 else { return .stable }

        let recent = Array(history.suffix(3)).map { $0.value }.average()
        let previous = Array(history.prefix(history.count - 3)).map { $0.value }.average()

        if recent > previous * 1.05 {
            return .up
        } else if recent < previous * 0.95 {
            return .down
        } else {
            return .stable
        }
    }

    private func getPerformanceData(for metric: PerformanceMetricType) -> [PerformanceDataPoint] {
        let history = coachingService.getPerformanceHistory(
            for: metric, days: selectedTimeframe.days)
        return history.map { PerformanceDataPoint(date: $0.timestamp, value: $0.value) }
    }

    private func getMockRecentSessions() -> [MockSession] {
        return [
            MockSession(
                title: "Team Standup Leadership",
                date: Date().addingTimeInterval(-86400),
                score: 87,
                focus: "Meeting Facilitation"
            ),
            MockSession(
                title: "Product Demo Presentation",
                date: Date().addingTimeInterval(-172800),
                score: 92,
                focus: "Presentation Skills"
            ),
        ]
    }
}

// MARK: - Supporting Views

struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.small) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .neonGlow(color: color, pulse: true)

                VStack(spacing: 2) {
                    Text(title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PerformanceMetricCard: View {
    let metric: PerformanceMetricType
    let isSelected: Bool
    let value: Double
    let trend: TrendDirection
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.small) {
                HStack {
                    Text(metric.displayName)
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .lineLimit(1)

                    Spacer()

                    Image(systemName: trend.icon)
                        .font(.caption2)
                        .foregroundColor(trend.color)
                }

                HStack {
                    Text(String(format: "%.1f", value))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Spacer()
                }
            }
            .padding()
            .background(
                isSelected ? Theme.Colors.neonBlue.opacity(0.2) : Theme.Colors.glassPrimary,
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Theme.Colors.neonBlue : Color.clear, lineWidth: 1)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CareerPathProgressCard: View {
    let path: CareerPathRecommendation
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                HStack {
                    Text(path.title)
                        .font(Theme.Typography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Spacer()

                    Text("\(Int(path.progressPercentage))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.neonGreen)
                }

                Text(path.description)
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .lineLimit(2)

                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Theme.Colors.glassPrimary)
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [Theme.Colors.neonGreen, Theme.Colors.neonBlue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: geometry.size.width * (path.progressPercentage / 100),
                                height: 6
                            )
                            .animation(.spring(), value: path.progressPercentage)
                    }
                }
                .frame(height: 6)

                Text(
                    "Next: \(path.milestones.first { !path.completedMilestones.contains($0) }?.title ?? "Complete!")"
                )
                .font(.caption2)
                .foregroundColor(Theme.Colors.textTertiary)
            }
            .padding()
            .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CoachingInsightCard: View {
    let insight: CoachingInsight

    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            Image(systemName: insight.type.icon)
                .foregroundColor(insight.type.color)
                .font(.title3)
                .neonGlow(color: insight.type.color, pulse: true)

            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(insight.description)
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .lineLimit(2)

                if !insight.actionItems.isEmpty {
                    Text("• \(insight.actionItems.first!)")
                        .font(.caption2)
                        .foregroundColor(insight.type.color)
                }
            }

            Spacer()

            Text(insight.timestamp, style: .relative)
                .font(.caption2)
                .foregroundColor(Theme.Colors.textTertiary)
        }
        .padding()
        .background(insight.type.color.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(insight.type.color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct RecentSessionCard: View {
    let session: MockSession

    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(session.focus)
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)

                Text(session.date, style: .relative)
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textTertiary)
            }

            Spacer()

            VStack(spacing: 4) {
                Text("\(session.score)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(session.scoreColor)

                Text("Score")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textTertiary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(session.scoreColor.opacity(0.2), in: RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct EmptyCareerPathView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "map")
                .font(.title)
                .foregroundColor(Theme.Colors.textTertiary)

            Text("No career paths yet")
                .font(.caption)
                .foregroundColor(Theme.Colors.textSecondary)

            Text("Complete a coaching session to generate personalized career recommendations")
                .font(.caption2)
                .foregroundColor(Theme.Colors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.Colors.glassPrimary.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct EmptyInsightsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "lightbulb")
                .font(.title)
                .foregroundColor(Theme.Colors.textTertiary)

            Text("No insights yet")
                .font(.caption)
                .foregroundColor(Theme.Colors.textSecondary)

            Text("Start a coaching session to receive personalized insights and recommendations")
                .font(.caption2)
                .foregroundColor(Theme.Colors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.Colors.glassPrimary.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Supporting Types

enum TimeframeFilter: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case quarter = "Quarter"

    var days: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .quarter: return 90
        }
    }
}

enum TrendDirection {
    case up, down, stable

    var icon: String {
        switch self {
        case .up: return "arrow.up.right"
        case .down: return "arrow.down.right"
        case .stable: return "minus"
        }
    }

    var color: Color {
        switch self {
        case .up: return Theme.Colors.neonGreen
        case .down: return Theme.Colors.neonOrange
        case .stable: return Theme.Colors.textTertiary
        }
    }
}

struct PerformanceDataPoint {
    let date: Date
    let value: Double
}

struct MockSession: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let score: Int
    let focus: String

    var scoreColor: Color {
        switch score {
        case 90...100: return Theme.Colors.neonGreen
        case 80...89: return Theme.Colors.neonBlue
        case 70...79: return Theme.Colors.neonYellow
        default: return Theme.Colors.neonOrange
        }
    }
}

// MARK: - Extensions for Mock Data

extension PerformanceMetrics {
    var overallScore: Double {
        // Calculate overall performance score from all metrics
        return 87.5  // Mock value
    }
}

extension CoachingInsight.InsightType {
    var icon: String {
        switch self {
        case .improvement: return "arrow.up.circle.fill"
        case .achievement: return "trophy.fill"
        case .recommendation: return "lightbulb.fill"
        case .warning: return "exclamationmark.triangle.fill"
        }
    }

    var color: Color {
        switch self {
        case .improvement: return Theme.Colors.neonGreen
        case .achievement: return Theme.Colors.neonYellow
        case .recommendation: return Theme.Colors.neonBlue
        case .warning: return Theme.Colors.neonOrange
        }
    }
}

// MARK: - Placeholder Views (to be implemented)

struct CareerPathDetailView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Text("Career Path Details")
                .navigationTitle("Career Path")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

struct StartCoachingSessionView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Text("Start Coaching Session")
                .navigationTitle("New Session")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Start") { dismiss() }
                    }
                }
        }
    }
}

#Preview {
    CoachingDashboardView()
}
