//
//  EmployeeModel.swift
//  StryVr
//
//  Created by Joe Dormond on 6/5/25.
//  👨‍💼 Complete Employee Data Model for Insights & Dashboards
//

import Foundation

/// Represents an employee within the StryVr organization insights system.
struct EmployeeModel: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let email: String
    let role: String
    let department: String
    let joinDate: Date
    var skills: [SkillProgress]
    var feedbackEntries: [FeedbackEntry]
    var performanceRating: Double
    var goalsAchieved: Int
    var isActive: Bool
}

/// Feedback associated with an employee's behavior or performance.
struct FeedbackEntry: Codable, Hashable {
    let category: FeedbackCategory
    let comment: String
    let rating: Int  // 1 to 5
    let date: Date
}

#if DEBUG
    extension EmployeeModel {
        static let mock: EmployeeModel = .init(
            id: "emp001",
            name: "Jordan Rivera",
            email: "jordan.rivera@stryvr.com",
            role: "iOS Engineer",
            department: "Product Development",
            joinDate: Date(timeIntervalSince1970: 1_672_531_200),
            skills: [
                SkillProgress(
                    skillId: "swiftui", skillName: "SwiftUI", currentLevel: 4,
                    progressPercentage: 0.85),
                SkillProgress(
                    skillId: "leadership", skillName: "Leadership", currentLevel: 3,
                    progressPercentage: 0.72),
                SkillProgress(
                    skillId: "communication", skillName: "Communication", currentLevel: 3,
                    progressPercentage: 0.68),
            ],
            feedbackEntries: [
                FeedbackEntry(
                    category: .collaboration, comment: "Always helpful in team tasks.", rating: 5,
                    date: .now),
                FeedbackEntry(
                    category: .clarity, comment: "Could communicate more clearly during standups.",
                    rating: 3, date: .now),
            ],
            performanceRating: 4.6,
            goalsAchieved: 12,
            isActive: true
        )
    }
#endif
