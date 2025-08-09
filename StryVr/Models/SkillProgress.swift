//
//  SkillProgress.swift
//  StryVr
//
//  Created for StryVr iOS app.
//  Defines the SkillProgress model used throughout the app for tracking skill development.
//

import Foundation

struct SkillProgress: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let skillId: String
    let skillName: String
    let currentLevel: Int
    let maxLevel: Int
    let progressPercentage: Double
    let experiencePoints: Int
    let lastUpdated: Date
    let isCompleted: Bool

    init(
        id: String = UUID().uuidString,
        skillId: String,
        skillName: String,
        currentLevel: Int = 1,
        maxLevel: Int = 5,
        progressPercentage: Double = 0.0,
        experiencePoints: Int = 0,
        lastUpdated: Date = Date(),
        isCompleted: Bool = false
    ) {
        self.id = id
        self.skillId = skillId
        self.skillName = skillName
        self.currentLevel = currentLevel
        self.maxLevel = maxLevel
        self.progressPercentage = progressPercentage
        self.experiencePoints = experiencePoints
        self.lastUpdated = lastUpdated
        self.isCompleted = isCompleted
    }
}

extension SkillProgress {
    var levelDisplay: String {
        return "Level \(currentLevel)/\(maxLevel)"
    }

    var progressDisplay: String {
        return "\(Int(progressPercentage * 100))%"
    }

    var isMaxLevel: Bool {
        return currentLevel >= maxLevel
    }
}
