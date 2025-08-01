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
        ),
        LearningReport(
            id: UUID().uuidString,
            employeeId: "emp_002",
            employeeName: "Jane Smith",
            reportDate: Date(),
            period: .monthly,
            skillsCompleted: 3,
            totalSkills: 6,
            learningHours: 18.0,
            certificationsEarned: 1,
            performanceScore: 75.0,
            recommendations: ["Enhance leadership skills", "Focus on project management"],
            nextSteps: ["Take leadership courses", "Lead small projects"]
        ),
        LearningReport(
            id: UUID().uuidString,
            employeeId: "emp_003",
            employeeName: "Mike Johnson",
            reportDate: Date(),
            period: .monthly,
            skillsCompleted: 7,
            totalSkills: 10,
            learningHours: 32.0,
            certificationsEarned: 3,
            performanceScore: 92.0,
            recommendations: ["Mentor junior developers", "Share knowledge with team"],
            nextSteps: ["Become a mentor", "Create knowledge sharing sessions"]
        )
    ]
}
