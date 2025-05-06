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
}
