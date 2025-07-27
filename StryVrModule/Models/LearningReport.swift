//
//  LearningReport.swift
//  StryVr
//
//  Created by Joe Dormond on 6/5/25.
//  📊 Learning Report – Summarizes user skill growth, challenges, and performance insights
//

import Foundation

/// Represents a user's learning report for enterprise analytics and reporting
struct LearningReport: Identifiable, Codable, Hashable {
    let id: String
    let employeeId: String
    let employeeName: String
    let reportDate: Date
    let period: ReportPeriod
    let skillsCompleted: Int
    let totalSkills: Int
    let learningHours: Double
    let certificationsEarned: Int
    let performanceScore: Double
    let recommendations: [String]
    let nextSteps: [String]

    init(
        id: String = UUID().uuidString,
        employeeId: String,
        employeeName: String,
        reportDate: Date = Date(),
        period: ReportPeriod = .monthly,
        skillsCompleted: Int = 0,
        totalSkills: Int = 0,
        learningHours: Double = 0.0,
        certificationsEarned: Int = 0,
        performanceScore: Double = 0.0,
        recommendations: [String] = [],
        nextSteps: [String] = []
    ) {
        self.id = id
        self.employeeId = employeeId
        self.employeeName = employeeName
        self.reportDate = reportDate
        self.period = period
        self.skillsCompleted = skillsCompleted
        self.totalSkills = totalSkills
        self.learningHours = learningHours
        self.certificationsEarned = certificationsEarned
        self.performanceScore = performanceScore
        self.recommendations = recommendations
        self.nextSteps = nextSteps
    }
}

enum ReportPeriod: String, Codable, CaseIterable {
    case weekly = "Weekly"
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case yearly = "Yearly"
}

extension LearningReport {
    var completionRate: Double {
        guard totalSkills > 0 else { return 0.0 }
        return Double(skillsCompleted) / Double(totalSkills)
    }

    var completionPercentage: String {
        return "\(Int(completionRate * 100))%"
    }

    var performanceGrade: String {
        switch performanceScore {
        case 90...100: return "A+"
        case 80..<90: return "A"
        case 70..<80: return "B"
        case 60..<70: return "C"
        case 50..<60: return "D"
        default: return "F"
        }
    }

    // MARK: - Formatter

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: reportDate)
    }

    // MARK: - Placeholder

    static let sample = LearningReport(
        id: UUID().uuidString,
        employeeId: "emp_001",
        employeeName: "John Doe",
        reportDate: Date(),
        period: .monthly,
        skillsCompleted: 5,
        totalSkills: 8,
        learningHours: 24.5,
        certificationsEarned: 2,
        performanceScore: 85.0,
        recommendations: ["Focus on advanced SwiftUI", "Improve team collaboration"],
        nextSteps: ["Complete advanced courses", "Join team projects"]
    )
}
