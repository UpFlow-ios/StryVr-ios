//
//  LeaderboardUser.swift
//  StryVr
//
//  Created by Joe Dormond on 6/5/25.
//  🏆 Leaderboard User Model – Tracks Skill Points, Rank, and Engagement
//

import Foundation
import SwiftUI

/// Represents a user on the StryVr leaderboard with performance metrics
struct LeaderboardUser: Identifiable, Codable, Hashable {
    let id: String // Firebase UID or internal user ID
    let name: String
    let profileImageURL: String?
    let totalPoints: Int
    let rank: Int
    let skills: [String]
    let lastActive: Date

    // Optional metrics for engagement and credibility
    var isVerified: Bool = false
    var completedChallenges: Int = 0
    var feedbackScore: Double = 0.0

    // MARK: - UI Helpers
    var initials: String {
        let components = name.components(separatedBy: " ")
        return components.compactMap { $0.first }.prefix(2).map(String.init).joined().uppercased()
    }

    var profileImage: Image {
        if let urlString = profileImageURL, let url = URL(string: urlString) {
            return Image(uiImage: UIImage(data: try! Data(contentsOf: url)) ?? UIImage())
        } else {
            return Image(systemName: "person.crop.circle.fill")
        }
    }
}

#if DEBUG
extension LeaderboardUser {
    static let mock: LeaderboardUser = LeaderboardUser(
        id: "mock123",
        name: "Ava Patel",
        profileImageURL: nil,
        totalPoints: 1500,
        rank: 3,
        skills: ["Swift", "Leadership"],
        lastActive: Date(),
        isVerified: true,
        completedChallenges: 12,
        feedbackScore: 4.8
    )
}
#endif

