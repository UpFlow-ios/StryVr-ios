//
//  MentorshipSession.swift
//  StryVr
//
//  Created by Joe Dormond on 4/14/25.
//

import Foundation

// MARK: - MentorshipSession
/// Represents a mentorship session between a mentor and mentee
struct MentorshipSession: Identifiable, Codable, Hashable {
    let id: String  // Unique session ID
    var mentorID: String  // ID of the mentor
    var menteeID: String  // ID of the mentee
    var sessionDate: Date  // Date of the session
    var sessionDuration: Int  // Duration in minutes
    var feedback: String?  // Feedback provided for the session
    var rating: Double?  // Rating for the session (0.0–5.0)

    // MARK: - Computed Properties
    /// Formats the session date for display
    var formattedSessionDate: String {
        return MentorshipSession.dateFormatter.string(from: sessionDate)
    }

    // MARK: - Formatter
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Validation
    /// Validates the session's rating to ensure it is within the valid range
    func isValidRating() -> Bool {
        guard let rating = rating else { return true }  // No rating is valid
        return rating >= 0.0 && rating <= 5.0
    }

    // MARK: - Initializer
    init(
        id: String,
        mentorID: String,
        menteeID: String,
        sessionDate: Date,
        sessionDuration: Int,
        feedback: String? = nil,
        rating: Double? = nil
    ) {
        self.id = id
        self.mentorID = mentorID
        self.menteeID = menteeID
        self.sessionDate = sessionDate
        self.sessionDuration = sessionDuration
        self.feedback = feedback
        self.rating = rating
    }
}
