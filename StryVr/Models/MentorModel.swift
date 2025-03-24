import Foundation

/// Represents a mentor profile within the StryVr app
struct MentorModel: Identifiable, Codable {
    let id: String  // Unique mentor ID (same as User ID)
    var fullName: String
    var profileImageURL: String?
    var bio: String?
    var expertise: [String] = []  // Areas of expertise
    var experienceYears: Int = 0
    var availability: String?  // Mentor's available time slots
    var rating: Double = 0.0  // Average mentor rating (out of 5)
    var totalSessions: Int = 0  // Total mentorship sessions completed
    var menteesCount: Int = 0  // Number of mentees they’ve helped
    var verified: Bool = false  // Whether the mentor is officially verified
    let joinedDate: Date  // Mentor's registration date

    /// Computed property to format join date
    var formattedJoinDate: String {
        return MentorModel.dateFormatter.string(from: joinedDate)
    }

    /// Static date formatter to avoid creating a new instance every time
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    /// Computed property for mentor's average rating percentage
    var ratingPercentage: Int {
        return Int((rating / 5.0) * 100)
    }
}

/// Represents a mentorship session with details about mentor-mentee interactions
struct MentorshipSession: Codable, Identifiable {
    let id: String  // Unique session ID
    var mentorID: String  // Mentor's ID
    var menteeID: String  // Mentee's ID
    var sessionDate: Date
    var sessionDuration: Int  // Duration in minutes
    var feedback: String?
    var rating: Double?  // Rating given by mentee (optional)
}
