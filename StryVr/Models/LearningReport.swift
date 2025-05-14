//
//  LearningReport.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25
//
//  📊 Learning Report – Tracks user progress, skill improvements, and report summaries
//

import Foundation

/// Represents a generated learning progress report for a user
struct LearningReport: Identifiable, Codable, Hashable {
    /// Unique identifier for the report
    let id: String
    /// Identifier for the user associated with the report
    let userId: String
    /// Date when the report was generated
    let generatedOn: Date
    /// List of skill improvements included in the report
    let skillImprovements: [SkillProgress]
    let summary: String

    /// Summary of the learning progress
    // MARK: - Computed Properties

    /// Formatted date for display
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: generatedOn)
    }

    /// Number of skill improvements in the report
    var improvementCount: Int {
        skillImprovements.count
    }

    /// Checks if there are any skill improvements
    var hasImprovements: Bool {
        !skillImprovements.isEmpty
    }

    // MARK: - Validation

    /// Validates that the summary is not empty
    var isValid: Bool {
        !summary.isEmpty
    }

    // MARK: - Placeholder

    /// A placeholder learning report
    static let empty = LearningReport(
        id: UUID().uuidString,
        userId: "",
        generatedOn: Date(),
        skillImprovements: [],
        summary: ""
    )
}
