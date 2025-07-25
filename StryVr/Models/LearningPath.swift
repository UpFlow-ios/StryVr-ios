//
//  LearningPath.swift
//  StryVr
//
//  Created for StryVr iOS app.
//  Defines the LearningPath model for structured learning journeys.
//

import Foundation

struct LearningPath: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let category: String
    let difficulty: LearningDifficulty
    let estimatedDuration: TimeInterval
    let skills: [String]
    let modules: [LearningModule]
    let isCompleted: Bool
    let progressPercentage: Double
    let createdAt: Date
    let updatedAt: Date

    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        category: String,
        difficulty: LearningDifficulty = .beginner,
        estimatedDuration: TimeInterval = 3600,  // 1 hour default
        skills: [String] = [],
        modules: [LearningModule] = [],
        isCompleted: Bool = false,
        progressPercentage: Double = 0.0,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.difficulty = difficulty
        self.estimatedDuration = estimatedDuration
        self.skills = skills
        self.modules = modules
        self.isCompleted = isCompleted
        self.progressPercentage = progressPercentage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum LearningDifficulty: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"

    var color: String {
        switch self {
        case .beginner: return "green"
        case .intermediate: return "blue"
        case .advanced: return "orange"
        case .expert: return "red"
        }
    }
}

struct LearningModule: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let duration: TimeInterval
    let isCompleted: Bool
    let order: Int

    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        duration: TimeInterval = 1800,  // 30 minutes default
        isCompleted: Bool = false,
        order: Int = 0
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.duration = duration
        self.isCompleted = isCompleted
        self.order = order
    }
}
