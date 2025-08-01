//
//  SkillMatrixEntry.swift
//  StryVr
//
//  Created by Joe Dormond on 6/5/25.
//  🧠 Skill Matrix Entry – Tracks individual skill ratings for performance dashboards
//

import Foundation

/// Represents an entry in an employee's skill matrix
struct SkillMatrixEntry: Identifiable, Codable, Hashable {
    /// Unique ID for the skill entry
    let id: String
    /// Name of the skill (e.g., Communication, SwiftUI)
    let skillName: String
    /// Numeric rating from 0.0 (no skill) to 1.0 (expert)
    let rating: Double
    /// Category the skill belongs to (e.g., Technical, Leadership)
    let category: SkillCategory
    /// Optional reviewer ID (peer, manager, or AI)
    let reviewerID: String?
    /// Date the rating was last updated
    let lastUpdated: Date
    /// Level of the skill
    let level: Int

    // MARK: - Computed Properties

    /// Color zone for rating visualization (low, medium, high)
    var performanceZone: PerformanceZone {
        switch rating {
        case 0.8...1.0: return .high
        case 0.5..<0.8: return .medium
        default: return .low
        }
    }

    /// Formatted display date
    var formattedDate: String {
        Self.dateFormatter.string(from: lastUpdated)
    }

    /// Is the rating above 70%?
    var isStrongSkill: Bool {
        rating >= 0.7
    }

    /// Average score for chart display (same as rating for individual entries)
    var averageScore: Double {
        return rating
    }

    // MARK: - Placeholder

    static let empty = SkillMatrixEntry(
        id: "",
        skillName: "",
        rating: 0.0,
        category: .technical,
        reviewerID: nil,
        lastUpdated: Date(),
        level: 0
    )

    // MARK: - Private Static Date Formatter

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

// MARK: - Enum: Skill Category

enum SkillCategory: String, Codable, CaseIterable {
    case technical
    case softSkill
    case leadership
    case workplace
    case innovation
    case compliance
    case custom
}

// MARK: - Enum: Performance Zone

enum PerformanceZone: String, Codable {
    case low
    case medium
    case high
}

extension SkillMatrixEntry {
    static let mockEntries: [SkillMatrixEntry] = [
        .init(
            id: "s1",
            skillName: "SwiftUI",
            rating: 1.0,
            category: .technical,
            reviewerID: nil,
            lastUpdated: Date(),
            level: 5
        ),
        .init(
            id: "s2",
            skillName: "Firebase",
            rating: 0.8,
            category: .technical,
            reviewerID: nil,
            lastUpdated: Date(),
            level: 4
        )
    ]
}
