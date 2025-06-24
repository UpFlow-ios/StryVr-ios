//
//  SkillVerificationModel.swift
//  StryVr
//
//  Created by Joe Dormond on [Date]
//
//  🧪 Skill Verification Model – Tracks verification requests, methods, and status
//

import Foundation

struct SkillVerificationModel: Identifiable, Codable {
    let id: String // Unique ID for the skill verification request
    let userID: String // ID of the user requesting verification
    var skillName: String // Name of the skill being verified
    var verificationMethod: VerificationMethod // Method used for verification
    var status: VerificationStatus // Current status of the verification request
    var submittedEvidenceURLs: [String]? // Optional URLs for submitted evidence
    let requestDate: Date // Date when the request was submitted
    var completionDate: Date? // Optional date when the request was completed

    // MARK: - Computed Properties

    /// Checks if evidence URLs are provided
    var hasEvidence: Bool {
        guard let urls = submittedEvidenceURLs else { return false }
        return !urls.isEmpty
    }

    // MARK: - Date Formatter

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    // MARK: - Validation

    /// Validates that the skill name is not empty and evidence URLs (if provided) are valid
    func isValid() -> Bool {
        guard !skillName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        if let urls = submittedEvidenceURLs {
            return urls.allSatisfy { URL(string: $0) != nil }
        }
        return true
    }

    // MARK: - Init

    init(
        id: String,
        userID: String,
        skillName: String,
        verificationMethod: VerificationMethod,
        status: VerificationStatus = .pending,
        submittedEvidenceURLs: [String]? = nil,
        requestDate: Date = Date(),
        completionDate: Date? = nil
    ) {
        self.id = id
        self.userID = userID
        self.skillName = skillName
        self.verificationMethod = verificationMethod
        self.status = status
        self.submittedEvidenceURLs = submittedEvidenceURLs
        self.requestDate = requestDate
        self.completionDate = completionDate
    }
}
