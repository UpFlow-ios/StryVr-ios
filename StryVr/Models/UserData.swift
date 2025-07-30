//
//  UserData.swift
//  StryVr
//
//  Created by Joe Dormond on 6/5/25.
//  👤 User Profile Data – Centralized user model used for reports, personalization, and analytics
//

import Foundation

/// Represents user-level data for reports and analytics
struct UserData: Identifiable, Codable, Hashable, Equatable {
    let id: String
    let fullName: String
    let email: String
    let role: String  // e.g., "employee", "manager"
    let profileImageURL: String?
    let department: String?
    let jobTitle: String?

    // Recent performance summary
    let lastReport: LearningReport?
    let progressScore: Double  // 0.0 to 1.0

    // Optional description or user bio
    let bio: String?

    // MARK: - Safe Defaults

    static let empty = UserData(
        id: UUID().uuidString,
        fullName: "N/A",
        email: "noemail@stryvr.app",
        role: "employee",
        profileImageURL: nil as String?,
        department: nil as String?,
        jobTitle: nil as String?,
        lastReport: nil as LearningReport?,
        progressScore: 0.0,
        bio: nil as String?
    )

    static func == (lhs: UserData, rhs: UserData) -> Bool {
        lhs.id == rhs.id &&
        lhs.fullName == rhs.fullName &&
        lhs.email == rhs.email &&
        lhs.role == rhs.role &&
        lhs.profileImageURL == rhs.profileImageURL &&
        lhs.department == rhs.department &&
        lhs.jobTitle == rhs.jobTitle &&
        lhs.lastReport == rhs.lastReport &&
        lhs.progressScore == rhs.progressScore &&
        lhs.bio == rhs.bio
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(fullName)
        hasher.combine(email)
        hasher.combine(role)
        hasher.combine(profileImageURL)
        hasher.combine(department)
        hasher.combine(jobTitle)
        hasher.combine(lastReport)
        hasher.combine(progressScore)
        hasher.combine(bio)
    }
}
