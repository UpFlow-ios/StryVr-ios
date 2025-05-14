//
//  VerificationMethod.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//

import Foundation

/// Types of verification users can submit
enum VerificationMethod: String, Codable, CaseIterable {
    /// Verification through project submission
    case projectSubmission = "Project Submission"
    /// Verification through certification upload
    case certificationUpload = "Certification Upload"
    /// Verification through an assessment test
    case assessmentTest = "Assessment Test"

    /// Returns a user-friendly description of the verification method
    var description: String {
        switch self {
        case .projectSubmission: return "Submission of a project for verification."
        case .certificationUpload: return "Upload of a certification document."
        case .assessmentTest: return "Completion of an assessment test."
        }
    }

    /// Mock value for previews or test use
    static var mock: VerificationMethod {
        .projectSubmission
    }

    /// SF Symbol name associated with the verification method
    var iconName: String {
        switch self {
        case .projectSubmission: return "doc.text"
        case .certificationUpload: return "doc.plaintext"
        case .assessmentTest: return "checkmark.seal"
        }
    }

    /// Returns a UI color string based on method
    var colorCode: String {
        switch self {
        case .projectSubmission: return "blue"
        case .certificationUpload: return "teal"
        case .assessmentTest: return "green"
        }
    }

    /// Validates if a given string matches a valid verification method
    static func isValidMethod(_ method: String) -> Bool {
        return VerificationMethod(rawValue: method) != nil
    }
}
