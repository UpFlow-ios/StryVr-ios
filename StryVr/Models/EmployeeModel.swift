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
    let role: String
    let department: String
    let email: String
    let joinDate: Date
    var skills: [SkillProgress]
    var feedbackEntries: [FeedbackEntry]
    var performanceRating: Double
    var goalsAchieved: Int
    var isActive: Bool

    init(
        id: String, name: String, role: String, department: String, email: String, joinDate: Date,
        skills: [SkillProgress] = [], feedbackEntries: [FeedbackEntry] = [],
        performanceRating: Double = 0.0, goalsAchieved: Int = 0, isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.role = role
        self.department = department
        self.email = email
        self.joinDate = joinDate
        self.skills = skills
        self.feedbackEntries = feedbackEntries
        self.performanceRating = performanceRating
        self.goalsAchieved = goalsAchieved
        self.isActive = isActive
    }
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
            joinDate: Date(),
            skills: [
                SkillProgress(skill: "SwiftUI", progress: 0.85),
                SkillProgress(skill: "Leadership", progress: 0.72),
                SkillProgress(skill: "Communication", progress: 0.68),
            ],
            feedbackEntries: [
                FeedbackEntry(
                    category: .collaboration,
                    comment: "Excellent team player, always willing to help others",
                    rating: 5,
                    date: Date()
                ),
                FeedbackEntry(
                    category: .clarity,
                    comment: "Clear communication in meetings and documentation",
                    rating: 4,
                    date: Date()
                ),
            ],
            performanceRating: 0.85,
            goalsAchieved: 8,
            isActive: true
        )
    }
#endif

extension EmployeeModel {
    static let mockData: [EmployeeModel] = [
        .init(id: "e1", name: "Tara", role: "iOS Engineer", department: "Mobile")
    ]
}
