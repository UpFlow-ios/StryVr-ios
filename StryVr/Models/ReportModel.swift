//
//  ReportModel.swift
//  StryVr
//
//  Created by Joe Dormond on 3/11/25.
//
import Foundation

/// Represents a report submitted within the StryVr app
struct ReportModel: Identifiable, Codable {
    let id: String  // Unique report ID
    let reporterID: String  // User who submitted the report
    let reportedUserID: String?  // User being reported (if applicable)
    let reportType: ReportType  // Type of report
    let description: String  // Detailed report description
    let evidenceURLs: [String]?  // Optional links to evidence (images, videos, etc.)
    let status: ReportStatus  // Current status of the report
    let timestamp: Date  // Date when the report was submitted

    /// Computed property to format report timestamp
    var formattedTimestamp: String {
        return ReportModel.dateFormatter.string(from: timestamp)
    }

    /// Static date formatter to avoid creating a new instance every time
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

/// Enum to classify different types of reports
enum ReportType: String, Codable {
    /// Report for inappropriate content
    case inappropriateContent = "Inappropriate Content"
    /// Report for harassment
    case harassment = "Harassment"
    /// Report for fraud
    case fraud = "Fraud"
    /// Report for fake profile
    case fakeProfile = "Fake Profile"
    /// Report for skill verification dispute
    case skillVerificationDispute = "Skill Verification Dispute"
    /// Report for other reasons
    case other = "Other"
}

/// Enum to track the report’s current resolution status
enum ReportStatus: String, Codable {
    /// Report is pending
    case pending = "Pending"
    /// Report is under review
    case underReview = "Under Review"
    /// Report is resolved
    case resolved = "Resolved"
    /// Report is dismissed
    case dismissed = "Dismissed"
}
