import Foundation

/// Represents a skill verification request in the StryVr app
struct SkillVerificationModel: Identifiable, Codable, Hashable {
    let id: String                      // Unique ID for the skill verification request
    let userID: String                  // ID of the user requesting verification
    var skillName: String               // Name of the skill being verified
    var verificationMethod: VerificationMethod // Method used for verification
    var status: VerificationStatus      // Current status of the verification request
    var submittedEvidenceURLs: [String]? // Optional URLs for submitted evidence
    var mentorEndorsement: MentorEndorsement? // Optional mentor endorsement details
    let requestDate: Date               // Date when the request was submitted
    var completionDate: Date?           // Optional date when the request was completed

    // MARK: - Computed Properties

    /// Formatted readable request date
    var formattedRequestDate: String {
        SkillVerificationModel.dateFormatter.string(from: requestDate)
    }

    /// Formatted readable completion date
    var formattedCompletionDate: String? {
        guard let date = completionDate else { return nil }
        return SkillVerificationModel.dateFormatter.string(from: date)
    }

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
        mentorEndorsement: MentorEndorsement? = nil,
        requestDate: Date = Date(),
        completionDate: Date? = nil
    ) {
        self.id = id
        self.userID = userID
        self.skillName = skillName
        self.verificationMethod = verificationMethod
        self.status = status
        self.submittedEvidenceURLs = submittedEvidenceURLs
        self.mentorEndorsement = mentorEndorsement
        self.requestDate = requestDate
        self.completionDate = completionDate
    }

    // MARK: - Placeholder

    static let empty = SkillVerificationModel(
        id: UUID().uuidString,
        userID: "",
        skillName: "",
        verificationMethod: .projectSubmission
    )
}
