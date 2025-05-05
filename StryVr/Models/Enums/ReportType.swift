//
//  ReportType.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//

import Foundation

/// Enum classifying different types of user-submitted reports
enum ReportType: String, Codable, CaseIterable {
    /// Reports related to inappropriate content
    case inappropriateContent = "Inappropriate Content"
    /// Reports related to harassment
    case harassment = "Harassment"
    /// Reports related to fraudulent activities
    case fraud = "Fraud"
    /// Reports related to fake profiles
    case fakeProfile = "Fake Profile"
    /// Reports related to disputes over skill verification
    /// Other types of reports
    case other = "Other"

    /// Returns a user-friendly description of the report type
    var description: String {
        switch self {
        case .inappropriateContent: return "Content that is deemed inappropriate."
        case .harassment: return "Behavior that is considered harassing or abusive."
        case .fraud: return "Activities involving fraud or deception."
        case .fakeProfile: return "Profiles that are fake or impersonating someone."
        case .skillVerificationDispute: return "Disputes over skill verification claims."
        case .other: return "Other types of issues not listed."
        }
    }

    /// Validates if a given string matches a valid report type
    static func isValidType(_ type: String) -> Bool {
        return ReportType(rawValue: type) != nil
    }
}
