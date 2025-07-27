//
//  SkillProgress.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25
//
//  📈 Skill Progress Model – Tracks user's progress and proficiency level per skill
//

import Foundation

/// Represents progress made on a specific skill
struct SkillProgress: Identifiable, Codable, Hashable {
    /// Unique identifier for the skill progress
    let id: String
    /// Skill identifier
    let skillId: String
    /// Name of the skill
    let skillName: String
    /// Current level of the skill
    let currentLevel: Int
    /// Maximum level for the skill
    let maxLevel: Int
    /// Progress percentage (0.0 = no progress, 1.0 = fully mastered)
    let progressPercentage: Double
    /// Experience points earned
    let experiencePoints: Int
    /// Last updated timestamp
    let lastUpdated: Date
    /// Whether the skill is completed
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

    // MARK: - Computed Properties

    /// Converts progress to a readable string
    var progressLabel: String {
        switch progressPercentage {
        case 0.8...1.0: return "Excellent"
        case 0.6..<0.8: return "Good"
        case 0.4..<0.6: return "Average"
        case 0.2..<0.4: return "Below Average"
        default: return "Needs Improvement"
        }
    }

    /// Level display string
    var levelDisplay: String {
        return "Level \(currentLevel)/\(maxLevel)"
    }

    /// Progress display string
    var progressDisplay: String {
        return "\(Int(progressPercentage * 100))%"
    }

    /// Whether the skill is at max level
    var isMaxLevel: Bool {
        return currentLevel >= maxLevel
    }

    // MARK: - Validation

    /// Validates that the progress is within the valid range
    var isValid: Bool {
        (0.0...1.0).contains(progressPercentage)
    }
}
