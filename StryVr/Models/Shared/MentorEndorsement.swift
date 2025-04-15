//
//  MentorEndorsement.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//

import Foundation

/// Represents a mentor's endorsement during skill verification
struct MentorEndorsement: Codable, Hashable {
    /// Unique ID of the mentor providing the endorsement
    var mentorID: String
    /// Feedback provided by the mentor
    var feedback: String
    /// Rating given by the mentor (e.g., 0.0 to 5.0)
    var rating: Double

    /// Validates that the rating is within the range of 0.0 to 5.0
    var isValidRating: Bool {
        return (0.0...5.0).contains(rating)
    }

    /// Initializes a new `MentorEndorsement`
    init(
        mentorID: String,
        feedback: String,
        rating: Double
    ) {
        self.mentorID = mentorID
        self.feedback = feedback
        self.rating = rating
    }
}
