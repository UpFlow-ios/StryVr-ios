//
//  UserData.swift
//  StryVr
//
//  Created by Joe Dormond on 6/5/25.
//  👤 User Profile Data – Centralized user model used for reports, personalization, and analytics
//

import Foundation

/// Represents user-level data for reports and analytics
struct UserData: Identifiable, Codable, Hashable {
    let id: String
    let fullName: String
    let email: String
    let role: String // e.g., "employee", "manager"
    let profileImageURL: String?
    let department: String?
    let jobTitle: String?
    
    // Recent performance summary
    let lastReport: LearningReport?
    let progressScore: Double // 0.0 to 1.0
    
    // Optional description or user bio
    let bio: String?

    // MARK: - Safe Defaults
    static let empty = UserData(
        id: UUID().uuidString,
        fullName: "N/A",
        email: "noemail@stryvr.app",
        role: "employee",
        profileImageURL: nil,
        department: nil,
        jobTitle: nil,
        lastReport: nil,
        progressScore: 0.0,
        bio: nil
    )
}


