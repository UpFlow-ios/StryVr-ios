//
//  UserModel.swift
//  StryVr
//
//  Created by Joe Dormond on 3/11/25.
//
import Foundation

/// Represents a user in the StryVr app
struct UserModel: Identifiable, Codable {
    let id: String  // Unique user ID (from Firebase Authentication)
    var fullName: String
    var email: String
    var profileImageURL: String?
    var bio: String?
    var skills: [String] = []  // List of skills the user has
    var role: UserRole  // User's role in the app (mentor or mentee)
    var isVerified: Bool = false  // Verification status (default: false)
    var mentorDetails: MentorDetails?  // Only applies if user is a mentor
    let joinedDate: Date  // User account creation date

    /// Computed property to check if the user is a mentor
    var isMentor: Bool {
        role == .mentor
    }

    /// Computed property for formatted join date
    var formattedJoinDate: String {
        return UserModel.dateFormatter.string(from: joinedDate)
    }

    /// Static date formatter to avoid creating a new instance every time
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

/// Defines user roles within the StryVr platform
enum UserRole: String, Codable {
    case mentee = "Mentee"
    case mentor = "Mentor"
}

/// Additional details for users who are mentors
struct MentorDetails: Codable {
    var expertise: [String] = []  // Areas of expertise
    var experienceYears: Int = 0  // Number of years of experience
    var availability: String?  // Availability for mentorship
    var rating: Double = 0.0  // Average rating (out of 5)
    var sessionCount: Int = 0  // Number of mentorship sessions completed
}
