import SwiftUI
import Charts
import OSLog

struct AnalyticsView: View {
    @StateObject private var viewModel = AnalyticsViewModel()
    @Namespace private var glassNamespace
    private let logger = Logger(subsystem: "com.stryvr.analytics", category: "AnalyticsView")
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Analytics Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Track your performance and insights")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Performance Overview Card
                    PerformanceOverviewCard(viewModel: viewModel)
                    
                    // Skills Progress Chart
                    SkillsProgressChart(viewModel: viewModel)
                    
                    // Recent Activity
                    RecentActivityCard(viewModel: viewModel)
                }
                .padding(.vertical)
            }
            .navigationBarHidden(true)
            .onAppear {
                logger.info("Analytics view appeared")
                viewModel.loadAnalytics()
            }
        }
    }
}

struct PerformanceOverviewCard: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    @Namespace private var glassNamespace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance Overview")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 20) {
                MetricCard(
                    title: "Skills Completed",
                    value: "\(viewModel.skillsCompleted)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                MetricCard(
                    title: "Hours Learned",
                    value: "\(viewModel.learningHours, specifier: "%.1f")",
                    icon: "clock.fill",
                    color: .blue
                )
                
                MetricCard(
                    title: "Achievements",
                    value: "\(viewModel.achievements)",
                    icon: "star.fill",
                    color: .orange
                )
            }
        }
        .padding()
        .applyLiquidGlassCard()
        .padding(.horizontal)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @Namespace private var glassNamespace
    
    var body: some View {
        VStack(spacing: 8) {
            if #available(iOS 18.0, *) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .glassEffect(.regular.tint(color.opacity(0.3)), in: Circle())
                    .glassEffectID("metric-icon-\(title)", in: glassNamespace)
            } else {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .applyMetricCardStyle()
    }
}

struct SkillsProgressChart: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Skills Progress")
                .font(.headline)
                .fontWeight(.semibold)
            
            if viewModel.skillsData.isEmpty {
                Text("No skills data available")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                if #available(iOS 18.0, *) {
                    Chart(viewModel.skillsData) { skill in
                        BarMark(
                            x: .value("Skill", skill.name),
                            y: .value("Progress", skill.progress)
                        )
                        .foregroundStyle(Color.blue.gradient)
                    }
                    .frame(height: 200)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 8))
                } else {
                    Chart(viewModel.skillsData) { skill in
                        BarMark(
                            x: .value("Skill", skill.name),
                            y: .value("Progress", skill.progress)
                        )
                        .foregroundStyle(Color.blue.gradient)
                    }
                    .frame(height: 200)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                }
            }
        }
        .padding()
        .applyLiquidGlassCard()
        .padding(.horizontal)
    }
}

struct RecentActivityCard: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.headline)
                .fontWeight(.semibold)
            
            if viewModel.recentActivity.isEmpty {
                Text("No recent activity")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(viewModel.recentActivity, id: \.id) { activity in
                    HStack {
                        if #available(iOS 18.0, *) {
                            Image(systemName: activity.icon)
                                .foregroundColor(activity.color)
                                .frame(width: 24)
                                .glassEffect(.regular.tint(activity.color.opacity(0.3)), in: Circle())
                        } else {
                            Image(systemName: activity.icon)
                                .foregroundColor(activity.color)
                                .frame(width: 24)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(activity.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text(activity.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(activity.timeAgo)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .applyLiquidGlassCard()
        .padding(.horizontal)
    }
}

// MARK: - iOS 18 Liquid Glass Helper Extensions

extension View {
    /// Apply iOS 18 Liquid Glass card with fallback
    func applyLiquidGlassCard() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular, in: RoundedRectangle(cornerRadius: 12))
        } else {
            return self.background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
        }
    }
    
    /// Apply metric card style with iOS 18 Liquid Glass
    func applyMetricCardStyle() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(Color(.systemGray6).opacity(0.3)), in: RoundedRectangle(cornerRadius: 8))
        } else {
            return self.background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
}

#Preview {
    AnalyticsView()
}
