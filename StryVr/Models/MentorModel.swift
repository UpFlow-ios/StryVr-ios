import Foundation

// MARK: - MentorModel
/// Represents a mentor profile within the StryVr app
struct MentorModel: Identifiable, Codable, Hashable {
    let id: String  // Unique mentor ID
    var fullName: String  // Mentor's full name
    var profileImageURL: String?  // URL to the mentor's profile image
    var bio: String?  // Mentor's biography
    var expertise: [String]  // Areas of expertise
    var experienceYears: Int  // Years of experience
    var availability: String?  // Availability details
    var rating: Double  // Mentor's rating (0.0–5.0)
    var totalSessions: Int  // Total number of sessions conducted
    var menteesCount: Int  // Number of mentees mentored
    var verified: Bool  // Indicates if the mentor is verified
    let joinedDate: Date  // Date the mentor joined the platform

    // MARK: - Computed Properties

    /// Format the mentor's join date
    var formattedJoinDate: String {
        return MentorModel.dateFormatter.string(from: joinedDate)
    }

    /// Get the rating percentage (0–100%)
    var ratingPercentage: Int {
        return Int((rating / 5.0) * 100)
    }

    // MARK: - Formatter
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    // MARK: - Validation
    /// Validates the mentor's rating to ensure it is within the valid range
    func isValidRating() -> Bool {
        return rating >= 0.0 && rating <= 5.0
    }

    // MARK: - Default Empty Instance
    static let empty: MentorModel = MentorModel(
        id: UUID().uuidString,
        fullName: "",
        profileImageURL: nil,
        bio: "",
        expertise: [],
        experienceYears: 0,
        availability: nil,
        rating: 0.0,
        totalSessions: 0,
        menteesCount: 0,
        verified: false,
        joinedDate: Date()
    )

    // MARK: - Initializer
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
