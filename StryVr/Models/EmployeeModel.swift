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
}

/// Feedback associated with an employee's behavior or performance.
struct FeedbackEntry: Codable, Hashable {
    let category: FeedbackCategory
    let comment: String
    let rating: Int  // 1 to 5
    let date: Date
}

extension EmployeeModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, name, email, role, skills, feedback, timeline, avatarURL, isActive, joinDate,
            department, position, reportsTo, badges, achievements, team, phoneNumber, linkedIn, bio,
            location, isMentor, isVerified, isAdmin, isEnterprise, isPro, isOnboarded,
            isProfileComplete, isVisible, isAvailable, isRemote, isManager, isExecutive,
            isContractor, isFullTime, isPartTime, isIntern, isAlumni, isPending, isSuspended,
            isDeleted, performanceRating, goalsAchieved
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        role = try container.decodeIfPresent(String.self, forKey: .role)
        skills = try container.decodeIfPresent([SkillProgress].self, forKey: .skills) ?? []
        feedbackEntries =
            try container.decodeIfPresent([FeedbackEntry].self, forKey: .feedback) ?? []
        performanceRating =
            try container.decodeIfPresent(Double.self, forKey: .performanceRating) ?? 0.0
        goalsAchieved = try container.decodeIfPresent(Int.self, forKey: .goalsAchieved) ?? 0
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? true
        joinDate = try container.decodeIfPresent(Date.self, forKey: .joinDate)
        department = try container.decodeIfPresent(String.self, forKey: .department)
        // The following properties are not directly mapped from the original EmployeeModel struct
        // and are not included in the new_code, so they will be defaulted or handled elsewhere.
        // position = try container.decodeIfPresent(String.self, forKey: .position)
        // reportsTo = try container.decodeIfPresent(String.self, forKey: .reportsTo)
        // badges = try container.decodeIfPresent([String].self, forKey: .badges) ?? []
        // achievements = try container.decodeIfPresent([String].self, forKey: .achievements) ?? []
        // team = try container.decodeIfPresent([String].self, forKey: .team) ?? []
        // phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        // linkedIn = try container.decodeIfPresent(String.self, forKey: .linkedIn)
        // bio = try container.decodeIfPresent(String.self, forKey: .bio)
        // location = try container.decodeIfPresent(String.self, forKey: .location)
        // isMentor = try container.decodeIfPresent(Bool.self, forKey: .isMentor) ?? false
        // isVerified = try container.decodeIfPresent(Bool.self, forKey: .isVerified) ?? false
        // isAdmin = try container.decodeIfPresent(Bool.self, forKey: .isAdmin) ?? false
        // isEnterprise = try container.decodeIfPresent(Bool.self, forKey: .isEnterprise) ?? false
        // isPro = try container.decodeIfPresent(Bool.self, forKey: .isPro) ?? false
        // isOnboarded = try container.decodeIfPresent(Bool.self, forKey: .isOnboarded) ?? false
        // isProfileComplete = try container.decodeIfPresent(Bool.self, forKey: .isProfileComplete) ?? false
        // isVisible = try container.decodeIfPresent(Bool.self, forKey: .isVisible) ?? true
        // isAvailable = try container.decodeIfPresent(Bool.self, forKey: .isAvailable) ?? true
        // isRemote = try container.decodeIfPresent(Bool.self, forKey: .isRemote) ?? false
        // isManager = try container.decodeIfPresent(Bool.self, forKey: .isManager) ?? false
        // isExecutive = try container.decodeIfPresent(Bool.self, forKey: .isExecutive) ?? false
        // isContractor = try container.decodeIfPresent(Bool.self, forKey: .isContractor) ?? false
        // isFullTime = try container.decodeIfPresent(Bool.self, forKey: .isFullTime) ?? false
        // isPartTime = try container.decodeIfPresent(Bool.self, forKey: .isPartTime) ?? false
        // isIntern = try container.decodeIfPresent(Bool.self, forKey: .isIntern) ?? false
        // isAlumni = try container.decodeIfPresent(Bool.self, forKey: .isAlumni) ?? false
        // isPending = try container.decodeIfPresent(Bool.self, forKey: .isPending) ?? false
        // isSuspended = try container.decodeIfPresent(Bool.self, forKey: .isSuspended) ?? false
        // isDeleted = try container.decodeIfPresent(Bool.self, forKey: .isDeleted) ?? false
    }
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
                SkillProgress(skill: "SwiftUI", progress: 0.88),
                SkillProgress(skill: "Teamwork", progress: 0.92),
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

extension EmployeeModel {
    static let mockData: [EmployeeModel] = [
        .init(id: "e1", name: "Tara", role: "iOS Engineer", department: "Mobile")
    ]
}
