import Foundation

// MARK: - SkillVerificationModel
/// Represents a skill verification request in the StryVr app
struct SkillVerificationModel: Identifiable, Codable {
    let id: String
    let userID: String
    var skillName: String
    var verificationMethod: VerificationMethod
    var status: VerificationStatus
    var submittedEvidenceURLs: [String]?
    var mentorEndorsement: MentorEndorsement?
    let requestDate: Date
    var completionDate: Date?

    /// Computed property for formatted request date
    var formattedRequestDate: String {
        return SkillVerificationModel.dateFormatter.string(from: requestDate)
    }

    /// Computed property for formatted completion date
    var formattedCompletionDate: String? {
        guard let date = completionDate else { return nil }
        return SkillVerificationModel.dateFormatter.string(from: date)
    }

    /// Optimized static date formatter
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    /// Explicit initializer with clear default values
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
}

// MARK: - VerificationMethod
/// Enum defining different skill verification methods
enum VerificationMethod: String, Codable {
    case mentorEndorsement = "Mentor Endorsement"
    case projectSubmission = "Project Submission"
    case certificationUpload = "Certification Upload"
    case assessmentTest = "Assessment Test"
}

// MARK: - VerificationStatus
/// Enum tracking skill verification request status
enum VerificationStatus: String, Codable {
    case pending = "Pending"
    case underReview = "Under Review"
    case approved = "Approved"
    case rejected = "Rejected"
}

// MARK: - MentorEndorsement
/// Represents a mentor's endorsement for skill verification
struct MentorEndorsement: Codable {
    var mentorID: String
    var feedback: String
    var rating: Double

    /// Explicit initializer clearly defined
    init(
        mentorID: String,
        feedback: String,
        rating: Double
    ) {
        self.mentorID = mentorID
        self.feedback = feedback
        self.rating = rating
    }
}
