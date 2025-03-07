import Foundation

/// Model representing a mentor.
struct MentorModel: Identifiable, Codable {
    var id: String
    var name: String
    var expertise: String
    var rating: Double
    var reviews: Int
    var isVerified: Bool
    var profileImageURL: String
    var availability: [String] // Example: ["Monday 3 PM", "Thursday 5 PM"]

    /// Formatted rating string with a star symbol.
    var formattedRating: String {
        return String(format: "%.1f ⭐️", rating)
    }

    /// Coding keys to map the JSON keys to the properties.
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case expertise
        case rating
        case reviews
        case isVerified
        case profileImageURL
        case availability
    }
}
