//
//  SkillVerificationModel.swift
//  StryVr
//
//  Created by Joe Dormond on 3/11/25.
//
import Foundation

/// Represents a skill verification request in the StryVr app
struct SkillVerificationModel: Identifiable, Codable {
    let id: String  // Unique verification request ID
    let userID: String  // User requesting verification
    var skillName: String  // Skill being verified
    var verificationMethod: VerificationMethod  // How the skill is verified
    var status: VerificationStatus  // Current status of the verification
    var submittedEvidenceURLs: [String]?  // Optional links to proof (projects, certificates, etc.)
    var mentorEndorsement: MentorEndorsement?  // If verified by a mentor
    let requestDate: Date  // Date of verification request
    var completionDate: Date?  // Date when verification was completed

    /// Computed property to format request date
    var formattedRequestDate: String {
        return SkillVerificationModel.dateFormatter.string(from: requestDate)
    }

    /// Computed property to format completion date
    var formattedCompletionDate: String? {
        guard let date = completionDate else { return nil }
        return SkillVerificationModel.dateFormatter.string(from: date)
    }

    /// Static date formatter to avoid creating a new instance every time
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

/// Enum defining different skill verification methods
enum VerificationMethod: String, Codable {
    /// Verification by mentor endorsement
    case mentorEndorsement = "Mentor Endorsement"
    /// Verification by project submission
    case projectSubmission = "Project Submission"
    /// Verification by certification upload
    case certificationUpload = "Certification Upload"
    /// Verification by assessment test
    case assessmentTest = "Assessment Test"
}

/// Enum for tracking skill verification request status
enum VerificationStatus: String, Codable {
    /// Verification is pending
    case pending = "Pending"
    /// Verification is under review
    case underReview = "Under Review"
    /// Verification is approved
    case approved = "Approved"
    /// Verification is rejected
    case rejected = "Rejected"
}

/// Represents a mentor's endorsement for skill verification
struct MentorEndorsement: Codable {
    var mentorID: String  // Mentor who endorsed the skill
    var feedback: String  // Mentor's comments
    var rating: Double  // Rating (out of 5)
}
