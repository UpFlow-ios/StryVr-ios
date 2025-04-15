import Foundation

/// Represents a skill-building challenge within StryVr
struct ChallengeModel: Identifiable, Codable, Hashable {
    /// Unique identifier for the challenge
    let id: String
    /// Title of the challenge
    let title: String
    /// Description of the challenge
    let description: String
    /// Type of the challenge (e.g., solo or group)
    let type: ChallengeType
    /// Start date of the challenge
    let startDate: Date
    /// End date of the challenge
    let endDate: Date
    /// List of participant IDs
    let participants: [String]
    /// Whether the challenge is currently active
    let isActive: Bool

    // MARK: - Computed Properties

    /// Formatted start date
    var formattedStartDate: String {
        ChallengeModel.dateFormatter.string(from: startDate)
    }

    /// Formatted end date
    var formattedEndDate: String {
        ChallengeModel.dateFormatter.string(from: endDate)
    }

    /// Percentage complete relative to the current date
    var progressPercentage: Double {
        let now = Date()
        guard now >= startDate else { return 0.0 }
        let total = endDate.timeIntervalSince(startDate)
        let elapsed = now.timeIntervalSince(startDate)
        return min(1.0, max(0.0, elapsed / total))
    }

    /// Checks if the challenge is currently ongoing
    var isOngoing: Bool {
        let now = Date()
        return now >= startDate && now <= endDate
    }

    // MARK: - Static Formatter

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    // MARK: - Validation

    /// Validates that the start date is before the end date
    var isValid: Bool {
        startDate < endDate
    }

    // MARK: - Init

    init(
        id: String,
        title: String,
        description: String,
        type: ChallengeType,
        startDate: Date,
        endDate: Date,
        participants: [String] = [],
        isActive: Bool = true
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
        self.participants = participants
        self.isActive = isActive
    }

    // MARK: - Placeholder

    static let empty = ChallengeModel(
        id: UUID().uuidString,
        title: "",
        description: "",
        type: .solo,
        startDate: Date(),
    )
}
        endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())!
