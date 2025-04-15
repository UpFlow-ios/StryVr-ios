//
//  MentorDetails.swift
//  StryVr
//
//  Created by Joe Dormond on 4/14/25.
//

import Foundation

/// Additional mentor-specific info used in UserModel and MentorModel
struct MentorDetails: Codable, Hashable {
    var expertise: [String]          // Topics they mentor in
    var experienceYears: Int         // Total years of experience
    var availability: String?        // Optional text schedule
    var rating: Double               // Out of 5.0
    var sessionCount: Int            // Total sessions completed

    // MARK: - Computed Properties
    /// Calculates the average sessions per year
    var averageSessionsPerYear: Double {
        guard experienceYears > 0 else { return 0.0 }
        return Double(sessionCount) / Double(experienceYears)
    }

    // MARK: - Validation
    /// Validates the mentor's rating to ensure it is within the valid range
    func isValidRating() -> Bool {
        return rating >= 0.0 && rating <= 5.0
    }

    // MARK: - Initializer
    init(
        expertise: [String] = [],
        experienceYears: Int = 0,
        availability: String? = nil,
        rating: Double = 0.0,
        sessionCount: Int = 0
    ) {
        self.expertise = expertise
        self.experienceYears = experienceYears
        self.availability = availability
        self.rating = rating
        self.sessionCount = sessionCount
    }
}
