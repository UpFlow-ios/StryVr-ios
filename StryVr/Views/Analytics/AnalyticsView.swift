import SwiftUI
import Charts
import OSLog

struct AnalyticsView: View {
    @StateObject private var viewModel = AnalyticsViewModel()
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
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
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
        .background(Color(.systemGray6))
        .cornerRadius(8)
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
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
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
                        Image(systemName: activity.icon)
                            .foregroundColor(activity.color)
                            .frame(width: 24)
                        
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
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

#Preview {
    AnalyticsView()
} 