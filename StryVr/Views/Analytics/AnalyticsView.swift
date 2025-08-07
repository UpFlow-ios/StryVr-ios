//
//  AnalyticsView.swift
//  StryVr
//
//  Created by Joe Dormond on 8/1/25.
//  📊 Comprehensive analytics dashboard with interactive charts
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    let userId: String
    
    @EnvironmentObject var router: AppRouter
    @StateObject private var viewModel = AnalyticsViewModel()
    @State private var selectedTimeFrame: TimeFrame = .month
    @State private var selectedMetric: AnalyticsMetric = .performance
    @State private var showingDetailView = false
    @Namespace private var chartNamespace
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Time Frame Selector
                timeFrameSelector
                
                // Key Metrics Overview
                keyMetricsOverview
                
                // Main Chart Section
                mainChartSection
                
                // Performance Breakdown
                performanceBreakdown
                
                // Trends and Insights
                trendsSection
                
                // Export and Actions
                actionButtonsSection
            }
            .padding()
        }
        .background(analyticsGradientBackground)
        .navigationTitle("Analytics")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        viewModel.exportAnalytics()
                    } label: {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                        router.navigate(to: .performanceDetail(metricId: "overview", timeframe: selectedTimeFrame.rawValue))
                    } label: {
                        Label("Detailed View", systemImage: "chart.bar.doc.horizontal")
                    }
                    
                    Button {
                        viewModel.refreshData()
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .foregroundColor(Theme.Colors.textPrimary)
                }
                .liquidGlassButton()
            }
        }
        .onAppear {
            viewModel.loadAnalytics(for: userId, timeFrame: selectedTimeFrame)
        }
        .onChange(of: selectedTimeFrame) { timeFrame in
            viewModel.loadAnalytics(for: userId, timeFrame: timeFrame)
        }
    }
    
    // MARK: - Time Frame Selector
    
    private var timeFrameSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                    TimeFrameButton(
                        timeFrame: timeFrame,
                        isSelected: selectedTimeFrame == timeFrame,
                        action: {
                            withAnimation(.spring()) {
                                selectedTimeFrame = timeFrame
                            }
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Key Metrics Overview
    
    private var keyMetricsOverview: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            MetricCard(
                title: "Performance Score",
                value: "\(viewModel.performanceScore)",
                change: viewModel.performanceChange,
                icon: "chart.line.uptrend.xyaxis",
                color: Theme.Colors.neonGreen
            )
            
            MetricCard(
                title: "Skill Growth",
                value: "+\(viewModel.skillGrowth)%",
                change: viewModel.skillGrowthChange,
                icon: "brain.head.profile",
                color: Theme.Colors.neonBlue
            )
            
            MetricCard(
                title: "Goal Completion",
                value: "\(viewModel.goalCompletion)%",
                change: viewModel.goalCompletionChange,
                icon: "target",
                color: Theme.Colors.neonOrange
            )
            
            MetricCard(
                title: "Market Position",
                value: "Top \(viewModel.marketPosition)%",
                change: viewModel.marketPositionChange,
                icon: "chart.bar.fill",
                color: Theme.Colors.neonYellow
            )
        }
    }
    
    // MARK: - Main Chart Section
    
    private var mainChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Performance Trends")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Menu {
                    ForEach(AnalyticsMetric.allCases, id: \.self) { metric in
                        Button(metric.displayName) {
                            selectedMetric = metric
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedMetric.displayName)
                            .font(Theme.Typography.caption)
                        Image(systemName: "chevron.down")
                    }
                    .foregroundColor(Theme.Colors.textSecondary)
                }
            }
            
            // Interactive Chart
            performanceChart
                .frame(height: 200)
        }
        .padding()
        .liquidGlassCard()
    }
    
    @ViewBuilder
    private var performanceChart: some View {
        if #available(iOS 16.0, *) {
            Chart(viewModel.chartData) { dataPoint in
                LineMark(
                    x: .value("Date", dataPoint.date),
                    y: .value("Value", dataPoint.value)
                )
                .foregroundStyle(selectedMetric.color)
                .symbol(Circle())
                
                AreaMark(
                    x: .value("Date", dataPoint.date),
                    y: .value("Value", dataPoint.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            selectedMetric.color.opacity(0.3),
                            selectedMetric.color.opacity(0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 7)) { value in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month().day())
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisValueLabel()
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
            }
            .animation(.easeInOut, value: selectedMetric)
        } else {
            // Fallback for iOS 15
            VStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 60))
                    .foregroundColor(Theme.Colors.textSecondary)
                
                Text("Chart requires iOS 16+")
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
    }
    
    // MARK: - Performance Breakdown
    
    private var performanceBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance Breakdown")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ForEach(viewModel.performanceCategories, id: \.name) { category in
                PerformanceCategoryRow(category: category)
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Trends Section
    
    private var trendsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Key Insights")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ForEach(viewModel.insights, id: \.id) { insight in
                InsightCard(insight: insight)
            }
        }
    }
    
    // MARK: - Action Buttons
    
    private var actionButtonsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            ActionButton(
                title: "AI Insights",
                icon: "brain.head.profile",
                color: Theme.Colors.neonGreen
            ) {
                router.navigateToAIInsights(userId: userId)
            }
            
            ActionButton(
                title: "Goal Setting",
                icon: "target",
                color: Theme.Colors.neonBlue
            ) {
                router.navigate(to: .careerGoals(userId: userId))
            }
            
            ActionButton(
                title: "Skill Assessment",
                icon: "checklist",
                color: Theme.Colors.neonOrange
            ) {
                router.navigate(to: .skillAssessment(assessmentId: "new"))
            }
            
            ActionButton(
                title: "Export Report",
                icon: "square.and.arrow.up",
                color: Theme.Colors.neonYellow
            ) {
                router.navigate(to: .exportReport(reportId: "analytics", format: .pdf))
            }
        }
    }
    
    // MARK: - Background
    
    private var analyticsGradientBackground: some View {
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

enum TimeFrame: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case quarter = "Quarter"
    case year = "Year"
    
    var icon: String {
        switch self {
        case .week: return "calendar"
        case .month: return "calendar.circle"
        case .quarter: return "calendar.badge.clock"
        case .year: return "calendar.badge.plus"
        }
    }
}

enum AnalyticsMetric: String, CaseIterable {
    case performance = "Performance"
    case skills = "Skills"
    case goals = "Goals"
    case productivity = "Productivity"
    
    var displayName: String { rawValue }
    
    var color: Color {
        switch self {
        case .performance: return Theme.Colors.neonGreen
        case .skills: return Theme.Colors.neonBlue
        case .goals: return Theme.Colors.neonOrange
        case .productivity: return Theme.Colors.neonYellow
        }
    }
}

// MARK: - Component Views

private struct TimeFrameButton: View {
    let timeFrame: TimeFrame
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: timeFrame.icon)
                    .foregroundColor(isSelected ? .white : Theme.Colors.textPrimary)
                
                Text(timeFrame.rawValue)
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
                        .fill(Theme.Colors.neonBlue)
                        .neonGlow(color: Theme.Colors.neonBlue)
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Theme.Colors.glassPrimary)
                }
            }
        )
        .animation(.spring(), value: isSelected)
    }
}

private struct MetricCard: View {
    let title: String
    let value: String
    let change: Double
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: change >= 0 ? "arrow.up" : "arrow.down")
                        .font(.caption)
                    Text("\(abs(change), specifier: "%.1f")%")
                        .font(Theme.Typography.caption)
                }
                .foregroundColor(change >= 0 ? Theme.Colors.neonGreen : Theme.Colors.neonOrange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(Theme.Typography.title)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
        .padding()
        .liquidGlassCard()
        .neonGlow(color: color.opacity(0.2))
    }
}

private struct PerformanceCategoryRow: View {
    let category: PerformanceCategory
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(category.name)
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(category.score)%")
                    .font(Theme.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.Colors.glassPrimary)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [category.color, category.color.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(category.score) / 100, height: 8)
                        .animation(.easeInOut, value: category.score)
                }
            }
            .frame(height: 8)
        }
    }
}

private struct InsightCard: View {
    let insight: AnalyticsInsight
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: insight.icon)
                .foregroundColor(insight.color)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text(insight.description)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            Spacer()
        }
        .padding()
        .liquidGlassCard()
    }
}

private struct ActionButton: View {
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

#Preview {
    NavigationStack {
        AnalyticsView(userId: "sample_user")
            .environmentObject(AppRouter())
    }
}
