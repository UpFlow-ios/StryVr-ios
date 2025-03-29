import Foundation

// MARK: - Mentor
/// Represents a mentor within the StryVr platform
struct Mentor: Identifiable, Codable {
    let id: String
    let name: String
    let bio: String
    let skills: [String]
    let rating: Double
    let reviewsCount: Int
    let profileImageURL: String?

    /// Explicit initializer clearly defined
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
}
