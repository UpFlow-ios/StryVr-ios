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
    let id: String
    let name: String
    let score: Int
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
    static let mock: LeaderboardUser = .init(
        id: "mock123",
        name: "Ava Patel",
        score: 1500,
        profileImageURL: nil,
        totalPoints: 1500,
        rank: 3,
        skills: ["Swift", "Leadership"],
        lastActive: Date(),
        isVerified: true,
        completedChallenges: 12,
        feedbackScore: 4.8
    )

    static let mockLeaderboardUsers: [LeaderboardUser] = [
        .init(
            id: "1",
            name: "Alex Johnson",
            score: 920,
            profileImageURL: nil,
            totalPoints: 1200,
            rank: 1,
            skills: ["SwiftUI", "Firebase"],
            lastActive: Date(),
            isVerified: true,
            completedChallenges: 8,
            feedbackScore: 4.5
        ),
        .init(
            id: "2",
            name: "Jamie Rivera",
            score: 850,
            profileImageURL: nil,
            totalPoints: 1080,
            rank: 2,
            skills: ["iOS", "Communication"],
            lastActive: Date(),
            isVerified: false,
            completedChallenges: 6,
            feedbackScore: 4.2
        ),
        .init(
            id: "3",
            name: "Luna Chen",
            score: 790,
            profileImageURL: nil,
            totalPoints: 990,
            rank: 3,
            skills: ["UI Design", "Swift"],
            lastActive: Date(),
            isVerified: true,
            completedChallenges: 7,
            feedbackScore: 4.6
        )
    ]
}
#endif
