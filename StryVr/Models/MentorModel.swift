import Foundation

// MARK: - MentorModel
/// Represents a mentor profile within the StryVr app
struct MentorModel: Identifiable, Codable {
    let id: String
    var fullName: String
    var profileImageURL: String?
    var bio: String?
    var expertise: [String]
    var experienceYears: Int
    var availability: String?
    var rating: Double
    var totalSessions: Int
    var menteesCount: Int
    var verified: Bool
    let joinedDate: Date

    /// Computed property to format join date
    var formattedJoinDate: String {
        return MentorModel.dateFormatter.string(from: joinedDate)
    }

    /// Static date formatter for efficiency
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    /// Computed property for mentor's average rating percentage
    var ratingPercentage: Int {
        return Int((rating / 5.0) * 100)
    }

    /// Default initializer with clear defaults
    init(
        id: String,
        fullName: String,
        profileImageURL: String? = nil,
        bio: String? = nil,
        expertise: [String] = [],
        experienceYears: Int = 0,
        availability: String? = nil,
        rating: Double = 0.0,
        totalSessions: Int = 0,
        menteesCount: Int = 0,
        verified: Bool = false,
        joinedDate: Date = Date()
    ) {
        self.id = id
        self.fullName = fullName
        self.profileImageURL = profileImageURL
        self.bio = bio
        self.expertise = expertise
        self.experienceYears = experienceYears
        self.availability = availability
        self.rating = rating
        self.totalSessions = totalSessions
        self.menteesCount = menteesCount
        self.verified = verified
        self.joinedDate = joinedDate
    }
}

// MARK: - MentorshipSession
/// Represents a mentorship session with details about mentor-mentee interactions
struct MentorshipSession: Identifiable, Codable {
    let id: String
    var mentorID: String
    var menteeID: String
    var sessionDate: Date
    var sessionDuration: Int  // Duration in minutes
    var feedback: String?
    var rating: Double?

    /// Default initializer clearly defined
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
