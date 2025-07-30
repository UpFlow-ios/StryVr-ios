import Foundation
import SwiftUI
import OSLog

@MainActor
class AnalyticsViewModel: ObservableObject {
    private let logger = Logger(subsystem: "com.stryvr.analytics", category: "AnalyticsViewModel")
    
    @Published var skillsCompleted: Int = 0
    @Published var learningHours: Double = 0.0
    @Published var achievements: Int = 0
    @Published var skillsData: [SkillData] = []
    @Published var recentActivity: [ActivityItem] = []
    @Published var isLoading: Bool = false
    
    func loadAnalytics() {
        logger.info("Loading analytics data")
        isLoading = true
        
        // Simulate loading data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadMockData()
            self.isLoading = false
            self.logger.info("Analytics data loaded successfully")
        }
    }
    
    private func loadMockData() {
        // Mock data for demonstration
        skillsCompleted = 12
        learningHours = 24.5
        achievements = 8
        
        skillsData = [
            SkillData(name: "Communication", progress: 85),
            SkillData(name: "Leadership", progress: 72),
            SkillData(name: "Problem Solving", progress: 90),
            SkillData(name: "Teamwork", progress: 78),
            SkillData(name: "Time Management", progress: 65)
        ]
        
        recentActivity = [
            ActivityItem(
                id: UUID(),
                title: "Completed Communication Challenge",
                description: "Earned 50 points for improving presentation skills",
                icon: "checkmark.circle.fill",
                color: .green,
                timeAgo: "2 hours ago"
            ),
            ActivityItem(
                id: UUID(),
                title: "New Achievement Unlocked",
                description: "Team Player badge for collaborative work",
                icon: "star.fill",
                color: .orange,
                timeAgo: "1 day ago"
            ),
            ActivityItem(
                id: UUID(),
                title: "Skill Assessment Completed",
                description: "Leadership skills evaluated and updated",
                icon: "chart.bar.fill",
                color: .blue,
                timeAgo: "3 days ago"
            )
        ]
    }
}

struct SkillData: Identifiable {
    let id = UUID()
    let name: String
    let progress: Double
}

struct ActivityItem: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let icon: String
    let color: Color
    let timeAgo: String
} 