import Foundation

// MARK: - UserModel
/// Represents a user in the StryVr app
struct UserModel: Identifiable, Codable, Hashable {
    let id: String  // Unique user ID (Firebase)
    var fullName: String  // User's full name
    var email: String  // User's email address
    var profileImageURL: String?  // URL to the user's profile image
    var bio: String?  // User's biography
    var skills: [String]  // List of skills the user possesses
    var role: UserRole  // User's role (e.g., mentee, mentor)
    var isVerified: Bool  // Indicates if the user is verified
    var mentorDetails: MentorDetails?  // Additional details for mentors
    let joinedDate: Date  // Date the user joined the platform

    // MARK: - Computed Properties
    /// Checks if the user is a mentor
    var isMentor: Bool {
        return role == .mentor
    }

    /// Formats the join date for display
    var formattedJoinDate: String {
        return UserModel.dateFormatter.string(from: joinedDate)
    }

    // MARK: - Static Formatter
    /// Date formatter for formatting join dates
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    // MARK: - Default Initializer
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

    // MARK: - Validation
    /// Validates the user's email address
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    // MARK: - Default Mock User
    /// Provides a default empty user
    static let empty: UserModel = UserModel(
        id: UUID().uuidString,
        fullName: "",
        email: "",
        role: .mentee,
        joinedDate: Date()
    )
}

// MARK: - UserRole
/// Defines user roles within StryVr
enum UserRole: String, Codable {
    case mentee = "Mentee"
    case mentor = "Mentor"
    // Future proofing:
    case admin = "Admin"  // Placeholder for potential admin role
}

// MARK: - MentorDetails
/// Additional mentor-specific info
struct MentorDetails: Codable, Hashable {
    var expertise: [String]  // Areas of expertise
    var experienceYears: Int  // Years of experience
    var availability: String?  // Availability details
    var rating: Double  // Mentor's rating
    var sessionCount: Int  // Number of sessions conducted

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
