//
//  AnalyticsViewModel.swift
//  StryVr
//
//  Created by Joe Dormond on 8/1/25.
//  📊 View model for analytics dashboard and performance metrics
//

import Foundation
import SwiftUI

@MainActor
class AnalyticsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isLoading = false
    @Published var performanceScore: Int = 87
    @Published var performanceChange: Double = 5.2
    
    @Published var skillGrowth: Int = 12
    @Published var skillGrowthChange: Double = 3.1
    
    @Published var goalCompletion: Int = 73
    @Published var goalCompletionChange: Double = 8.4
    
    @Published var marketPosition: Int = 15
    @Published var marketPositionChange: Double = -2.1
    
    @Published var chartData: [ChartDataPoint] = []
    @Published var performanceCategories: [PerformanceCategory] = []
    @Published var insights: [AnalyticsInsight] = []
    
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private var currentTimeFrame: TimeFrame = .month
    private let analyticsService = AnalyticsService.shared
    
    // MARK: - Public Methods
    
    func loadAnalytics(for userId: String, timeFrame: TimeFrame) {
        isLoading = true
        currentTimeFrame = timeFrame
        errorMessage = nil
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.loadMockData(for: timeFrame)
            self.isLoading = false
        }
    }
    
    func refreshData() {
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadMockData(for: self.currentTimeFrame)
            self.isLoading = false
        }
    }
    
    func exportAnalytics() {
        // Add haptic feedback
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        
        // Implementation for exporting analytics data
        print("Exporting analytics data...")
    }
    
    // MARK: - Private Methods
    
    private func loadMockData(for timeFrame: TimeFrame) {
        generateChartData(for: timeFrame)
        loadPerformanceCategories()
        loadInsights()
        updateMetrics(for: timeFrame)
    }
    
    private func generateChartData(for timeFrame: TimeFrame) {
        let calendar = Calendar.current
        let endDate = Date()
        let dataPoints: Int
        let interval: Calendar.Component
        
        switch timeFrame {
        case .week:
            dataPoints = 7
            interval = .day
        case .month:
            dataPoints = 30
            interval = .day
        case .quarter:
            dataPoints = 12
            interval = .weekOfYear
        case .year:
            dataPoints = 12
            interval = .month
        }
        
        chartData = (0..<dataPoints).compactMap { index in
            guard let date = calendar.date(byAdding: interval, value: -index, to: endDate) else {
                return nil
            }
            
            // Generate realistic performance data with some variance
            let baseScore = 85
            let variance = Int.random(in: -15...20)
            let value = max(0, min(100, baseScore + variance))
            
            return ChartDataPoint(date: date, value: value)
        }.reversed()
    }
    
    private func loadPerformanceCategories() {
        performanceCategories = [
            PerformanceCategory(
                name: "Technical Skills",
                score: 92,
                color: Theme.Colors.neonBlue
            ),
            PerformanceCategory(
                name: "Communication",
                score: 78,
                color: Theme.Colors.neonGreen
            ),
            PerformanceCategory(
                name: "Leadership",
                score: 85,
                color: Theme.Colors.neonOrange
            ),
            PerformanceCategory(
                name: "Problem Solving",
                score: 89,
                color: Theme.Colors.neonYellow
            ),
            PerformanceCategory(
                name: "Team Collaboration",
                score: 91,
                color: Theme.Colors.neonPink
            ),
            PerformanceCategory(
                name: "Innovation",
                score: 76,
                color: Theme.Colors.glowPurple
            )
        ]
    }
    
    private func loadInsights() {
        insights = [
            AnalyticsInsight(
                id: "1",
                title: "Strong Performance Trend",
                description: "Your performance has improved by 12% over the last quarter",
                icon: "chart.line.uptrend.xyaxis",
                color: Theme.Colors.neonGreen,
                priority: .high
            ),
            AnalyticsInsight(
                id: "2",
                title: "Skill Development Opportunity",
                description: "Focus on system design skills to reach your next career milestone",
                icon: "brain.head.profile",
                color: Theme.Colors.neonBlue,
                priority: .medium
            ),
            AnalyticsInsight(
                id: "3",
                title: "Market Position",
                description: "You're in the top 15% of professionals in your field",
                icon: "chart.bar.fill",
                color: Theme.Colors.neonOrange,
                priority: .high
            ),
            AnalyticsInsight(
                id: "4",
                title: "Goal Achievement",
                description: "You've completed 73% of your quarterly goals - great progress!",
                icon: "target",
                color: Theme.Colors.neonYellow,
                priority: .medium
            )
        ]
    }
    
    private func updateMetrics(for timeFrame: TimeFrame) {
        // Adjust metrics based on time frame
        switch timeFrame {
        case .week:
            performanceChange = 2.1
            skillGrowthChange = 1.2
            goalCompletionChange = 5.3
            marketPositionChange = 0.8
        case .month:
            performanceChange = 5.2
            skillGrowthChange = 3.1
            goalCompletionChange = 8.4
            marketPositionChange = -2.1
        case .quarter:
            performanceChange = 12.8
            skillGrowthChange = 15.6
            goalCompletionChange = 23.1
            marketPositionChange = -5.2
        case .year:
            performanceChange = 34.2
            skillGrowthChange = 45.8
            goalCompletionChange = 67.3
            marketPositionChange = -12.4
        }
    }
}

// MARK: - Data Models

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Int
}

struct PerformanceCategory {
    let name: String
    let score: Int
    let color: Color
}

struct AnalyticsInsight: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let color: Color
    let priority: Priority
}

enum Priority {
    case high, medium, low
    
    var color: Color {
        switch self {
        case .high: return Theme.Colors.neonOrange
        case .medium: return Theme.Colors.neonYellow
        case .low: return Theme.Colors.textSecondary
        }
    }
}

// MARK: - Analytics Service (Mock)

class AnalyticsService {
    static let shared = AnalyticsService()
    private init() {}
    
    func fetchPerformanceData(for userId: String, timeFrame: TimeFrame) async throws -> [ChartDataPoint] {
        // Mock implementation - would connect to actual analytics API
        return []
    }
    
    func fetchInsights(for userId: String) async throws -> [AnalyticsInsight] {
        // Mock implementation
        return []
    }
    
    func exportAnalyticsData(for userId: String, format: ExportFormat) async throws -> URL {
        // Mock implementation
        return URL(fileURLWithPath: "/tmp/analytics.pdf")
    }
}