//
//  ReportStatus.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//

import Foundation

/// Enum tracking the report’s current review status
enum ReportStatus: String, Codable, CaseIterable {
    /// The report is pending and has not been reviewed yet
    case pending = "Pending"
    /// The report is currently under review
    case underReview = "Under Review"
    /// The report has been resolved
    case resolved = "Resolved"
    /// The report has been dismissed
    case dismissed = "Dismissed"

    /// Returns a user-friendly description of the status
    var description: String {
        switch self {
        case .pending: return "The report is awaiting review."
        case .underReview: return "The report is currently being reviewed."
        case .resolved: return "The report has been resolved."
        case .dismissed: return "The report has been dismissed."
        }
    }

    /// Validates if a given string matches a valid status
    static func isValidStatus(_ status: String) -> Bool {
        return ReportStatus(rawValue: status) != nil
    }
}
