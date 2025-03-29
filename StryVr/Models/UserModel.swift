import Foundation

// MARK: - UserModel
/// Represents a user in the StryVr app
struct UserModel: Identifiable, Codable {
    let id: String  // Unique user ID (from Firebase Authentication)
    var fullName: String
    var email: String
    var profileImageURL: String?
    var bio: String?
    var skills: [String]
    var role: UserRole
    var isVerified: Bool
    var mentorDetails: MentorDetails?
    let joinedDate: Date

    // Computed property to check if user is mentor
    var isMentor: Bool {
        return role == .mentor
    }

    // Computed property for formatted join date
    var formattedJoinDate: String {
        return UserModel.dateFormatter.string(from: joinedDate)
    }

    // Static DateFormatter (optimized)
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    // Default initializer for clarity (recommended)
    init(
        id: String,
        fullName: String,
        email: String,
        profileImageURL: String? = nil,
        bio: String? = nil,
        skills: [String] = [],
        role: UserRole,
        isVerified: Bool = false,
        mentorDetails: MentorDetails? = nil,
        joinedDate: Date = Date()
    ) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.profileImageURL = profileImageURL
        self.bio = bio
        self.skills = skills
        self.role = role
        self.isVerified = isVerified
        self.mentorDetails = mentorDetails
        self.joinedDate = joinedDate
    }
}

// MARK: - UserRole
/// Defines user roles within StryVr
enum UserRole: String, Codable {
    case mentee = "Mentee"
    case mentor = "Mentor"
}

// MARK: - MentorDetails
/// Additional mentor-specific information
struct MentorDetails: Codable {
    var expertise: [String]
    var experienceYears: Int
    var availability: String?
    var rating: Double
    var sessionCount: Int

    // Default initializer for clarity
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
