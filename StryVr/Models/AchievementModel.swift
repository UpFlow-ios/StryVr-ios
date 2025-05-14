//
//  AchievementModel.swift
//  StryVr
//
//  🏅 User Achievement Model – Tracks earned badges and celebration metadata
//

import Foundation

/// Represents an earned achievement or badge
typealias AchievementID = String

struct AchievementModel: Identifiable, Codable, Equatable {
    let id: AchievementID
    var title: String
    var description: String
    var iconName: String   // SF Symbol or custom icon name
    var dateEarned: Date
    var isNew: Bool

    // Optional metadata for animations or confetti
    var shouldTriggerConfetti: Bool {
        return isNew
    }

    // MARK: - Preview Sample
    static var mock: AchievementModel {
        AchievementModel(
            id: UUID().uuidString,
            title: "Streak Master",
            description: "Completed 7-day learning streak!",
            iconName: "flame.fill",
            dateEarned: Date(),
            isNew: true
        )
    }
    
    static var samples: [AchievementModel] {
        [
            AchievementModel(
                id: UUID().uuidString,
                title: "Streak Master",
                description: "Completed 7-day learning streak!",
                iconName: "flame.fill",
                dateEarned: Date(),
                isNew: true
            ),
            AchievementModel(
                id: UUID().uuidString,
                title: "Skill Pro",
                description: "Verified 5 new skills",
                iconName: "checkmark.seal.fill",
                dateEarned: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                isNew: false
            ),
            AchievementModel(
                id: UUID().uuidString,
                title: "Team Contributor",
                description: "Completed 3 team challenges",
                iconName: "person.3.fill",
                dateEarned: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
                isNew: false
            )
        ]
    }
}
