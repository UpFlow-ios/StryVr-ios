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
    let id: String = UUID().uuidString

    /// User identifier the report is for
    let userID: String

    /// Date the report was generated
    let createdAt: Date

    /// Skills analyzed with performance data
    let skills: [SkillPerformance]

    /// AI-detected strengths (e.g. top 3 skills)
    let strengths: [String]

    /// AI-detected areas of improvement
    let weaknesses: [String]

    /// Optional AI-generated summary text for the report
    let summary: String?

    /// Progress score 0.0–1.0
    let overallScore: Double

    // MARK: - Formatter

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdAt)
    }

    // MARK: - Placeholder

    static let sample = LearningReport(
        id: UUID().uuidString,
        userID: "user_001",
        createdAt: Date(),
        skills: [
            SkillPerformance(skillName: "SwiftUI", rating: 0.9),
            SkillPerformance(skillName: "Communication", rating: 0.8),
            SkillPerformance(skillName: "AI Literacy", rating: 0.6),
        ],
        strengths: ["SwiftUI", "Communication"],
        weaknesses: ["AI Literacy"],
        summary:
            "You've made strong progress in SwiftUI and communication. Focus more on AI concepts to boost your profile.",
        overallScore: 0.77
    )

    static var empty: LearningReport {
        LearningReport(
            id: "default", userID: "0", createdAt: Date(), skills: [], strengths: [],
            weaknesses: [], summary: "", overallScore: 0.0)
    }
}

/// Represents performance of a single skill
struct SkillPerformance: Codable, Hashable {
    let skillName: String
    let rating: Double  // 0.0 to 1.0
}
