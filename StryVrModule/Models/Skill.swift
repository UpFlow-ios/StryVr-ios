//
//  Skill.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25
//
//  🧠 Skill Model – Tracks user skills, proficiency, activity, and validation
//

import Foundation

/// Represents a user’s skill inside StryVr
struct Skill: Identifiable, Codable, Hashable {
    /// Unique identifier for the skill
    let id: String
    /// Name of the skill
    let name: String
    /// Proficiency level of the skill (0.0 = none, 1.0 = expert)
    let proficiencyLevel: Double
    /// Date when the skill was last practiced (optional)
    let lastPracticed: Date?

    // MARK: - Computed Properties

    /// Converts proficiency to a readable string
    var proficiencyLabel: String {
        switch proficiencyLevel {
        case 0.8 ... 1.0: return "Expert"
        case 0.6 ..< 0.8: return "Advanced"
        case 0.4 ..< 0.6: return "Intermediate"
        case 0.2 ..< 0.4: return "Beginner"
        default: return "New"
        }
    }

    /// Last practiced date for UI
    var formattedLastPracticed: String? {
        guard let lastPracticed = lastPracticed else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: lastPracticed)
    }

    /// Determines if the skill was practiced recently
    func isRecent(within days: Int = 7) -> Bool {
        guard let lastDate = lastPracticed else { return false }
        guard let pastDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) else {
            return false
        }
        return Calendar.current.isDateInToday(lastDate) || lastDate >= pastDate
    }

    /// Checks if the skill is at an expert level
    var isExpert: Bool {
        proficiencyLevel >= 0.8
    }

    // MARK: - Validation

    /// Validates that the proficiency level is within the valid range
    var isValid: Bool {
        (0.0 ... 1.0).contains(proficiencyLevel)
    }

    // MARK: - Placeholder

    /// A placeholder skill
    static let empty = Skill(
        id: UUID().uuidString,
        name: "",
        proficiencyLevel: 0.0,
        lastPracticed: nil
    )
}
