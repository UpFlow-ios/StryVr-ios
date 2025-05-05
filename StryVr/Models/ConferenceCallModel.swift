import Foundation

// MARK: - ConferenceCallModel
/// Represents a scheduled conference call within the StryVr platform
struct ConferenceCallModel: Identifiable, Codable, Hashable {
    let id: String                      // Unique call ID
    var title: String                   // Conference title
    var description: String?            // Optional session description
    var participants: [String]          // User IDs of attendees
    var scheduledDate: Date             // Scheduled time/date
    var durationMinutes: Int            // Duration in minutes
    var callStatus: CallStatus          // Enum status
    var recordingURL: String?           // Optional recorded video link
    var engagementMetrics: CallEngagement // Viewer activity stats

    // MARK: - Computed Properties

    /// Formatted readable scheduled date
    var formattedScheduledDate: String {
        ConferenceCallModel.dateFormatter.string(from: scheduledDate)
    }

    /// Number of participants in the call
    var participantCount: Int {
        participants.count
    }

    // MARK: - Static Formatter

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Validation

    /// Validates the duration to ensure it is positive
    func isValidDuration() -> Bool {
        return durationMinutes > 0
    }

    // MARK: - Initializer

    init(
        id: String,
        hostID: String,
        title: String,
        description: String? = nil,
        participants: [String] = [],
        scheduledDate: Date,
        durationMinutes: Int,
        callStatus: CallStatus = .upcoming,
        recordingURL: String? = nil,
        engagementMetrics: CallEngagement = CallEngagement()
    ) {
        self.id = id
        self.hostID = hostID
        self.title = title
        self.description = description
        self.participants = participants
        self.scheduledDate = scheduledDate
        self.durationMinutes = durationMinutes
        self.callStatus = callStatus
        self.recordingURL = recordingURL
        self.engagementMetrics = engagementMetrics
    }

    // MARK: - Empty Placeholder for Preview
    static let empty = ConferenceCallModel(
        id: UUID().uuidString,
        hostID: "unknown",
        title: "Untitled Conference",
        scheduledDate: Date(),
        durationMinutes: 60
    )
}
