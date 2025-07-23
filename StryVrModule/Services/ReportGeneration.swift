//
//  ReportGeneration.swift
//  StryVr
//
//  Created by Joe Dormond on 5/6/25.
//  📊 Report Generation Service – Fetches team learning reports for analytics
//

import Foundation

final class ReportGeneration {
    static let shared = ReportGeneration()

    private init() {}

    func fetchTeamReports(completion: @escaping (Result<[LearningReport], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1.0) {
            completion(.success(ReportGeneration.mockTeamReports))
        }
    }

    static let mockTeamReports: [LearningReport] = [
        LearningReport(
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
            summary: "Strong progress in SwiftUI and communication. Focus more on AI concepts.",
            overallScore: 0.77
        ),
        LearningReport(
            id: UUID().uuidString,
            userID: "user_002",
            createdAt: Date(),
            skills: [
                SkillPerformance(skillName: "Leadership", rating: 0.7),
                SkillPerformance(skillName: "Project Management", rating: 0.8),
                SkillPerformance(skillName: "Technical Skills", rating: 0.5),
            ],
            strengths: ["Leadership", "Project Management"],
            weaknesses: ["Technical Skills"],
            summary:
                "Excellent leadership and project management skills. Technical skills need improvement.",
            overallScore: 0.67
        ),
        LearningReport(
            id: UUID().uuidString,
            userID: "user_003",
            createdAt: Date(),
            skills: [
                SkillPerformance(skillName: "Design", rating: 0.9),
                SkillPerformance(skillName: "Creativity", rating: 0.8),
                SkillPerformance(skillName: "Analytics", rating: 0.4),
            ],
            strengths: ["Design", "Creativity"],
            weaknesses: ["Analytics"],
            summary:
                "Outstanding design and creativity skills. Analytics skills require development.",
            overallScore: 0.70
        ),
    ]
}
