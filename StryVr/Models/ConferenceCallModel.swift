import Foundation

// MARK: - ConferenceCallModel
/// Represents a scheduled conference call within the StryVr platform
struct ConferenceCallModel: Identifiable, Codable {
    let id: String
    let hostID: String
    var title: String
    var description: String?
    var participants: [String]
    var scheduledDate: Date
    var durationMinutes: Int
    var callStatus: CallStatus
    var recordingURL: String?
    var engagementMetrics: CallEngagement

    /// Computed property for formatted scheduled date
    var formattedScheduledDate: String {
        return ConferenceCallModel.dateFormatter.string(from: scheduledDate)
    }

    /// Optimized static date formatter
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    /// Explicit initializer clearly defined
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
}

// MARK: - CallStatus
/// Enum defining the status of a conference call
enum CallStatus: String, Codable {
    case upcoming = "Upcoming"
    case live = "Live"
    case completed = "Completed"
    case canceled = "Canceled"
}

// MARK: - CallEngagement
/// Represents engagement metrics for a conference call
struct CallEngagement: Codable {
    var totalAttendees: Int
    var messagesSent: Int
    var reactions: Int

    /// Computed property calculating engagement score
    var engagementScore: Int {
        return (totalAttendees * 5) + (messagesSent * 2) + (reactions * 3)
    }

    /// Explicit initializer clearly defined
    init(totalAttendees: Int = 0, messagesSent: Int = 0, reactions: Int = 0) {
        self.totalAttendees = totalAttendees
        self.messagesSent = messagesSent
        self.reactions = reactions
    }
}
