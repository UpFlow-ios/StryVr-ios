//
//  MentorReport.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25.
//

import Foundation

/// Represents a performance report for a mentor based on mentee feedback
struct MentorReport: Identifiable, Codable, Hashable {
    /// Unique identifier for the report
    let id: String
    /// Identifier for the mentor associated with the report
    let mentorId: String
    /// List of feedback from mentees
    let menteeFeedback: [String]
    /// Average rating for the mentor (0.0 – 5.0)
    let rating: Double
    /// Number of sessions conducted by the mentor
    let sessionCount: Int
    /// Summary of the mentor's performance
    let summary: String
    /// Date when the report was generated
    let reportDate: Date

    // MARK: - Computed

    /// Formatted report date for display
    var formattedReportDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: reportDate)
    }

    /// Checks if the mentor is highly rated
    var isHighRated: Bool {
        rating >= 4.5 && sessionCount >= 10
    }

    /// Checks if the report contains any feedback
    var hasFeedback: Bool {
        !menteeFeedback.isEmpty
    }

    // MARK: - Validation

    /// Validates that the rating and session count are within valid ranges
    var isValid: Bool {
        (0.0...5.0).contains(rating) && sessionCount >= 0
    }

    // MARK: - Placeholder

    /// A placeholder mentor report
    static let empty = MentorReport(
        id: UUID().uuidString,
        mentorId: "",
        menteeFeedback: [],
        rating: 0.0,
        sessionCount: 0,
        summary: "",
        reportDate: Date()
    )
}
