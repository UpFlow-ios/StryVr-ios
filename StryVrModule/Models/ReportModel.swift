//
//  ReportModel.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//
//  📝 Report Model – Handles user-submitted reports including status, evidence, and metadata
//
import Foundation

/// Represents a report submitted within the StryVr app
struct ReportModel: Identifiable, Codable, Hashable {
    let id: String                      // Unique report ID
    let reporterID: String              // ID of the user submitting the report
    let reportedUserID: String?         // ID of the user being reported (optional)
    let reportType: ReportType          // Type of the report
    let description: String             // Description of the report
    let evidenceURLs: [String]?         // Optional URLs for evidence
    let status: ReportStatus            // Current status of the report
    let timestamp: Date                 // Timestamp of when the report was submitted

    // MARK: - Computed Properties

    /// Formatted readable timestamp
    var formattedTimestamp: String {
        ReportModel.dateFormatter.string(from: timestamp)
    }

    /// Checks if evidence URLs are provided
    var hasEvidence: Bool {
        guard let evidenceURLs = evidenceURLs else { return false }
        return !evidenceURLs.isEmpty
    // MARK: - Static Date Formatter

    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Validation

    /// Validates that the description is not empty
    func isValidDescription() -> Bool {
        return !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Init

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

    // MARK: - Default

    static let empty = ReportModel(
        id: UUID().uuidString,
        reporterID: "",
        reportType: .other,
        description: "",
        status: .pending
    )
}
