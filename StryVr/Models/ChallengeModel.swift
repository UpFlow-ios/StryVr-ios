import Foundation

// MARK: - ChallengeModel
/// Represents a challenge within the StryVr platform
struct ChallengeModel: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let startDate: Date
    let endDate: Date
    let participants: [String]
    let isActive: Bool

    /// Explicit initializer clearly defined
    init(
        id: String,
        title: String,
        description: String,
        startDate: Date,
        endDate: Date,
        participants: [String] = [],
        isActive: Bool = true
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.participants = participants
        self.isActive = isActive
    }
}
