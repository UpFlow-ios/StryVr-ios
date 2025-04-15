//
//  VerificationStatus.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//

import Foundation

/// Status tracking for skill verification flow
enum VerificationStatus: String, Codable, CaseIterable {
    /// The verification request is pending and has not been reviewed yet
    case pending = "Pending"
    /// The verification request is currently under review
    case underReview = "Under Review"
    /// The verification request has been approved
    case approved = "Approved"
    /// The verification request has been rejected
    case rejected = "Rejected"

    /// Returns a user-friendly description of the verification status
    var description: String {
        switch self {
        case .pending: return "The verification request is awaiting review."
        case .underReview: return "The verification request is currently being reviewed."
        case .approved: return "The verification request has been approved."
        case .rejected: return "The verification request has been rejected."
        }
    }

    /// Validates if a given string matches a valid verification status
    static func isValidStatus(_ status: String) -> Bool {
        return VerificationStatus(rawValue: status) != nil
    }
}
