//
//  VerificationMethod.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//

import Foundation

/// Types of verification users can submit
enum VerificationMethod: String, Codable, CaseIterable {
    /// Verification through mentor endorsement
    case mentorEndorsement = "Mentor Endorsement"
    /// Verification through project submission
    case projectSubmission = "Project Submission"
    /// Verification through certification upload
    case certificationUpload = "Certification Upload"
    /// Verification through an assessment test
    case assessmentTest = "Assessment Test"

    /// Returns a user-friendly description of the verification method
    var description: String {
        switch self {
        case .mentorEndorsement: return "Endorsement provided by a mentor."
        case .projectSubmission: return "Submission of a project for verification."
        case .certificationUpload: return "Upload of a certification document."
        case .assessmentTest: return "Completion of an assessment test."
        }
    }

    /// Validates if a given string matches a valid verification method
    static func isValidMethod(_ method: String) -> Bool {
        return VerificationMethod(rawValue: method) != nil
    }
}
