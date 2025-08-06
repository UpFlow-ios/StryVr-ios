//
//  AIInsightsViewModel.swift
//  StryVr
//
//  Created by Joe Dormond on 8/1/25.
//  🧠 View model for AI insights and recommendations
//

import Foundation
import Combine

@MainActor
class AIInsightsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isLoading = false
    @Published var growthOpportunities: [GrowthOpportunity] = []
    @Published var skillGaps: [SkillGap] = []
    @Published var learningRecommendations: [LearningRecommendation] = []
    @Published var marketTrends: [MarketTrend] = []
    @Published var recentActivities: [AIActivity] = []
    @Published var errorMessage: String?
    
    // Salary Data
    @Published var currentSalary: Int = 115000
    @Published var marketAverage: Int = 125000
    @Published var topPercentile: Int = 165000
    @Published var potentialSalaryIncrease: Int = 15000
    @Published var salaryRecommendations: [String] = []
    @Published var negotiationTips: [String] = []
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let aiService = AIService.shared
    
    // MARK: - Public Methods
    
    func loadInsights(for userId: String) {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call with realistic data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadMockData()
            self.isLoading = false
        }
    }
    
    func refreshInsights() {
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.loadMockData()
            self.isLoading = false
        }
    }
    
    // MARK: - Private Methods
    
    private func loadMockData() {
        loadGrowthOpportunities()
        loadSkillGaps()
        loadLearningRecommendations()
        loadMarketTrends()
        loadSalaryData()
        loadRecentActivities()
    }
    
    private func loadGrowthOpportunities() {
        growthOpportunities = [
            GrowthOpportunity(
                id: "1",
                title: "Lead iOS Team",
                description: "Based on your technical skills and leadership potential",
                impact: "High Impact",
                timeline: "6-12 months",
                probability: 0.85
            ),
            GrowthOpportunity(
                id: "2",
                title: "Technical Architect Role",
                description: "Your system design skills are trending upward",
                impact: "Medium Impact",
                timeline: "12-18 months",
                probability: 0.72
            ),
            GrowthOpportunity(
                id: "3",
                title: "Product Manager Transition",
                description: "Your user-focused approach shows PM potential",
                impact: "High Impact",
                timeline: "18-24 months",
                probability: 0.64
            )
        ]
    }
    
    private func loadSkillGaps() {
        skillGaps = [
            SkillGap(skill: "System Design", currentLevel: 70, targetLevel: 90, gapLevel: 22),
            SkillGap(skill: "Team Leadership", currentLevel: 60, targetLevel: 85, gapLevel: 29),
            SkillGap(skill: "Machine Learning", currentLevel: 40, targetLevel: 75, gapLevel: 47),
            SkillGap(skill: "Cloud Architecture", currentLevel: 55, targetLevel: 80, gapLevel: 31)
        ]
    }
    
    private func loadLearningRecommendations() {
        learningRecommendations = [
            LearningRecommendation(
                id: "1",
                title: "iOS System Design Mastery",
                description: "Deep dive into scalable iOS architecture patterns",
                duration: "6 weeks",
                difficulty: "Advanced",
                provider: "Apple Developer",
                rating: 4.8
            ),
            LearningRecommendation(
                id: "2",
                title: "Technical Leadership for Engineers",
                description: "Transition from individual contributor to tech lead",
                duration: "4 weeks",
                difficulty: "Intermediate",
                provider: "LinkedIn Learning",
                rating: 4.6
            ),
            LearningRecommendation(
                id: "3",
                title: "Core ML for iOS Developers",
                description: "Integrate machine learning into your iOS apps",
                duration: "8 weeks",
                difficulty: "Intermediate",
                provider: "Ray Wenderlich",
                rating: 4.7
            )
        ]
    }
    
    private func loadMarketTrends() {
        marketTrends = [
            MarketTrend(name: "SwiftUI Adoption", changePercentage: 45, trend: .rising),
            MarketTrend(name: "AI/ML Integration", changePercentage: 38, trend: .rising),
            MarketTrend(name: "Cross-Platform Skills", changePercentage: 22, trend: .rising),
            MarketTrend(name: "UIKit Demand", changePercentage: -15, trend: .declining),
            MarketTrend(name: "Combine Framework", changePercentage: 28, trend: .rising)
        ]
    }
    
    private func loadSalaryData() {
        salaryRecommendations = [
            "Obtain AWS or Azure cloud certifications (+$8K)",
            "Lead a cross-functional project (+$5K)",
            "Contribute to open source projects (+$3K)",
            "Mentor junior developers (+$4K)",
            "Speak at tech conferences (+$6K)"
        ]
        
        negotiationTips = [
            "Highlight your recent AI/ML project contributions",
            "Reference the 12% market increase for senior iOS roles",
            "Emphasize your leadership in the new authentication system",
            "Mention your strong App Store review ratings",
            "Discuss your role in improving team velocity by 23%"
        ]
    }
    
    private func loadRecentActivities() {
        recentActivities = [
            AIActivity(
                id: "1",
                title: "Career path analysis updated",
                description: "New leadership opportunities detected",
                timestamp: "2 hours ago",
                icon: "arrow.up.right.circle.fill",
                color: .blue
            ),
            AIActivity(
                id: "2",
                title: "Skill gap analysis completed",
                description: "4 key areas identified for growth",
                timestamp: "5 hours ago",
                icon: "brain.head.profile.fill",
                color: .green
            ),
            AIActivity(
                id: "3",
                title: "Market trends updated",
                description: "SwiftUI demand increased 15% this quarter",
                timestamp: "1 day ago",
                icon: "chart.line.uptrend.xyaxis",
                color: .orange
            ),
            AIActivity(
                id: "4",
                title: "Salary benchmark refreshed",
                description: "Market data updated for your role",
                timestamp: "2 days ago",
                icon: "dollarsign.circle.fill",
                color: .yellow
            )
        ]
    }
}

// MARK: - Data Models

struct GrowthOpportunity: Identifiable {
    let id: String
    let title: String
    let description: String
    let impact: String
    let timeline: String
    let probability: Double
}

struct SkillGap {
    let skill: String
    let currentLevel: Int
    let targetLevel: Int
    let gapLevel: Int
}

struct LearningRecommendation: Identifiable {
    let id: String
    let title: String
    let description: String
    let duration: String
    let difficulty: String
    let provider: String
    let rating: Double
}

struct MarketTrend {
    let name: String
    let changePercentage: Int
    let trend: TrendDirection
}

enum TrendDirection {
    case rising, declining, stable
}

struct AIActivity: Identifiable {
    let id: String
    let title: String
    let description: String
    let timestamp: String
    let icon: String
    let color: Color
}

struct AIRecommendation: Identifiable {
    let id: String
    let title: String
    let description: String
    let type: RecommendationType
    let priority: Priority
    let actionRequired: Bool
}

enum RecommendationType {
    case skill, career, salary, learning
}

enum Priority {
    case high, medium, low
}

// MARK: - AI Service (Mock)

class AIService {
    static let shared = AIService()
    private init() {}
    
    // This would connect to your actual AI service/API
    func generateInsights(for userId: String) async throws -> [AIRecommendation] {
        // Mock implementation
        return []
    }
    
    func analyzeCareerPath(for userId: String) async throws -> CareerPathPrediction {
        // Mock implementation
        return CareerPathPrediction(
            currentRole: "Senior iOS Developer",
            nextRole: "Lead iOS Developer",
            timeframe: "6-12 months",
            probability: 0.85,
            requiredSkills: ["System Design", "Team Leadership"]
        )
    }
}

struct CareerPathPrediction {
    let currentRole: String
    let nextRole: String
    let timeframe: String
    let probability: Double
    let requiredSkills: [String]
}