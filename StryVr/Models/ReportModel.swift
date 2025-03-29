import Foundation

// MARK: - ReportModel
/// Represents a report submitted within the StryVr app
struct ReportModel: Identifiable, Codable {
    let id: String
    let reporterID: String
    let reportedUserID: String?
    let reportType: ReportType
    let description: String
    let evidenceURLs: [String]?
    let status: ReportStatus
    let timestamp: Date

    /// Computed property for formatted timestamp
    var formattedTimestamp: String {
        return ReportModel.dateFormatter.string(from: timestamp)
    }

    /// Static date formatter for efficiency
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    /// Explicit initializer with clear defaults
    init(
        id: String,
        reporterID: String,
        reportedUserID: String? = nil,
        reportType: ReportType,
        description: String,
        evidenceURLs: [String]? = nil,
        status: ReportStatus = .pending,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.reporterID = reporterID
        self.reportedUserID = reportedUserID
        self.reportType = reportType
        self.description = description
        self.evidenceURLs = evidenceURLs
        self.status = status
        self.timestamp = timestamp
    }
}

// MARK: - ReportType
/// Enum classifying different types of reports
enum ReportType: String, Codable {
    case inappropriateContent = "Inappropriate Content"
    case harassment = "Harassment"
    case fraud = "Fraud"
    case fakeProfile = "Fake Profile"
    case skillVerificationDispute = "Skill Verification Dispute"
    case other = "Other"
}

// MARK: - ReportStatus
/// Enum tracking the report's current resolution status
enum ReportStatus: String, Codable {
    case pending = "Pending"
    case underReview = "Under Review"
    case resolved = "Resolved"
    case dismissed = "Dismissed"
}
