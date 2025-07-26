//
//  ChallengeModel.swift
//  StryVr
//
//  Created for StryVr iOS app.
//  Defines the ChallengeModel used for gamified learning challenges.
//

import Foundation

struct ChallengeModel: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let type: ChallengeType
    let difficulty: Int  // 1-5 scale
    let points: Int
    let deadline: Date?
    let isCompleted: Bool
    let progress: Double  // 0.0 to 1.0
    let createdAt: Date
    let completedAt: Date?

    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        type: ChallengeType = .skill,
        difficulty: Int = 1,
        points: Int = 10,
        deadline: Date? = nil,
        isCompleted: Bool = false,
        progress: Double = 0.0,
        createdAt: Date = Date(),
        completedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.difficulty = max(1, min(5, difficulty))
        self.points = points
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.progress = max(0.0, min(1.0, progress))
        self.createdAt = createdAt
        self.completedAt = completedAt
    }
}

extension ChallengeModel {
    var isOverdue: Bool {
        guard let deadline = deadline else { return false }
        return !isCompleted && Date() > deadline
    }

    var progressPercentage: String {
        return "\(Int(progress * 100))%"
    }

    var difficultyStars: String {
        return String(repeating: "⭐", count: difficulty)
    }

    var timeRemaining: TimeInterval? {
        guard let deadline = deadline, !isCompleted else { return nil }
        return deadline.timeIntervalSince(Date())
    }

    var timeRemainingText: String? {
        guard let remaining = timeRemaining, remaining > 0 else { return nil }

        let days = Int(remaining) / 86400
        let hours = Int(remaining) % 86400 / 3600

        if days > 0 {
            return "\(days)d \(hours)h remaining"
        } else {
            return "\(hours)h remaining"
        }
    }
}
