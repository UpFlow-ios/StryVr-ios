import Foundation

struct Mentor: Identifiable, Codable {
    var id: String
    var name: String
    var expertise: String
    var availableDates: [String] // Example: ["2024-03-10", "2024-03-15"]
    var profileImageURL: String
}

