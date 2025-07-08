//
//  LearningReport.swift
//  StryVr
//
//  Created by Joe Dormond on 6/5/25.
//  📊 Learning Report – Summarizes user skill growth, challenges, and performance insights
//

import Foundation

/// Represents a user's AI-generated learning report
struct LearningReport: Identifiable, Codable, Hashable {
    /// Unique ID for this report
    let id: String

    /// User identifier the report is for
    let userId: String

    /// Date the report was generated
    let timestamp: Date

    /// Skills analyzed with performance data
    let skills: [SkillPerformance]

    /// AI-detected strengths (e.g. top 3 skills)
    let strengths: [String]

    /// AI-detected areas of improvement
    let weaknesses: [String]

    /// Optional AI-generated summary text for the report
    let summary: String

    /// Progress score 0.0–1.0
    let overallScore: Double

    /// Top skills mentioned in the report
    let topSkills: [String]

    // MARK: - Formatter

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: timestamp)
    }

    // MARK: - Placeholder

    static let sample = LearningReport(
        id: UUID().uuidString,
        userId: "user_001",
        timestamp: Date(),
        skills: [
            SkillPerformance(skillName: "SwiftUI", rating: 0.9),
            SkillPerformance(skillName: "Communication", rating: 0.8),
            SkillPerformance(skillName: "AI Literacy", rating: 0.6),
        ],
        strengths: ["SwiftUI", "Communication"],
        weaknesses: ["AI Literacy"],
        summary: "You've made strong progress in SwiftUI and communication. Focus more on AI concepts to boost your profile.",
        overallScore: 0.77,
        topSkills: ["SwiftUI", "Communication"]
    )

    static var empty: LearningReport {
        LearningReport(
            id: UUID().uuidString,
            userId: "preview",
            timestamp: Date(),
            skills: [],
            strengths: [],
            weaknesses: [],
            summary: "This is a summary.",
            overallScore: 0.0,
            topSkills: ["Swift", "Firebase"]
        )
    }
}

/// Represents performance of a single skill
struct SkillPerformance: Codable, Hashable {
    let skillName: String
    let rating: Double  // 0.0 to 1.0
}
