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
    let id = UUID()
    /// Name of the skill
    var skill: String
    /// Progress level (0.0 = no progress, 1.0 = fully mastered)
    var progress: Double

    // MARK: - Computed Properties

    /// Converts progress to a readable string
    var progressLabel: String {
        switch progress {
        case 0.8...1.0: return "Excellent"
        case 0.6..<0.8: return "Good"
        case 0.4..<0.6: return "Average"
        case 0.2..<0.4: return "Below Average"
        default: return "Needs Improvement"
        }
    }

    // MARK: - Validation

    /// Validates that the progress is within the valid range
    var isValid: Bool {
        (0.0...1.0).contains(progress)
    }
}
