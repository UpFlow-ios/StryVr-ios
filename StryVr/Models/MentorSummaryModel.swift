import Foundation

/// Lightweight summary of a mentor (used in feed, previews, cards)
struct MentorSummaryModel: Identifiable, Codable, Hashable {
    /// Unique identifier for the mentor
    let id: String
    /// Name of the mentor
    let name: String
    /// Short biography of the mentor
    let bio: String
    /// List of skills the mentor possesses
    let skills: [String]
    /// Average rating of the mentor (0.0 to 5.0)
    let rating: Double
    /// Number of reviews the mentor has received
    let reviewsCount: Int
    /// URL of the mentor's profile image (optional)
    let profileImageURL: String?

    // MARK: - Computed Properties

    /// Checks if the mentor has a profile image
    var hasProfileImage: Bool {
        profileImageURL != nil
    }

    /// Validates that the rating and reviews count are within valid ranges
    var isValid: Bool {
        (0.0...5.0).contains(rating) && reviewsCount >= 0
    }

    // MARK: - Initializer
    init(
        id: String,
        name: String,
        bio: String,
        skills: [String],
        rating: Double,
        reviewsCount: Int,
        profileImageURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.bio = bio
        self.skills = skills
        self.rating = rating
        self.reviewsCount = reviewsCount
        self.profileImageURL = profileImageURL
    }

    // MARK: - Placeholder
    static let empty = MentorSummaryModel(
        id: UUID().uuidString,
        name: "",
        bio: "",
        skills: [],
        rating: 0.0,
        reviewsCount: 0,
        profileImageURL: nil
    )
}
