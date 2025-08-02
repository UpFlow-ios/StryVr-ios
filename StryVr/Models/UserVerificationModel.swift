//
//  UserVerificationModel.swift
//  StryVr
//
//  🔐 User Verification Model – Comprehensive identity and company verification system
//  Integrates with ClearMe and other verification services for transparency and trust
//

import Foundation

struct UserVerificationModel: Identifiable, Codable {
    let id: String
    let userID: String
    var verificationType: VerificationType
    var verificationMethod: VerificationMethod
    var status: VerificationStatus
    var verificationProvider: VerificationProvider
    var verificationData: VerificationData
    let requestDate: Date
    var completionDate: Date?
    var expirationDate: Date?
    var verificationScore: Double?
    var notes: String?
    
    // MARK: - Computed Properties
    
    var isVerified: Bool {
        return status == .approved && (expirationDate == nil || expirationDate! > Date())
    }
    
    var isExpired: Bool {
        guard let expirationDate = expirationDate else { return false }
        return expirationDate < Date()
    }
    
    var daysUntilExpiration: Int? {
        guard let expirationDate = expirationDate else { return nil }
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: Date(), to: expirationDate).day
    }
    
    // MARK: - Validation
    
    func isValid() -> Bool {
        guard !userID.isEmpty else { return false }
        guard verificationData.isValid() else { return false }
        return true
    }
}

// MARK: - Verification Types

enum VerificationType: String, Codable, CaseIterable {
    case identity = "Identity Verification"
    case company = "Company Verification"
    case employment = "Employment Verification"
    case skills = "Skills Verification"
    case education = "Education Verification"
    case background = "Background Check"
    
    var description: String {
        switch self {
        case .identity: return "Verify user's real identity using biometric and document verification"
        case .company: return "Verify company exists and user has legitimate association"
        case .employment: return "Verify employment history and performance metrics"
        case .skills: return "Verify professional skills and competencies"
        case .education: return "Verify educational credentials and certifications"
        case .background: return "Comprehensive background and reference check"
        }
    }
    
    var iconName: String {
        switch self {
        case .identity: return "person.crop.circle.badge.checkmark"
        case .company: return "building.2.crop.circle"
        case .employment: return "briefcase.circle"
        case .skills: return "brain.head.profile"
        case .education: return "graduationcap.circle"
        case .background: return "shield.checkered"
        }
    }
    
    var colorCode: String {
        switch self {
        case .identity: return "blue"
        case .company: return "green"
        case .employment: return "orange"
        case .skills: return "purple"
        case .education: return "teal"
        case .background: return "red"
        }
    }
}

// MARK: - Verification Methods

enum VerificationMethod: String, Codable, CaseIterable {
    case clearMe = "ClearMe Biometric"
    case documentUpload = "Document Upload"
    case videoCall = "Video Call Verification"
    case phoneCall = "Phone Call Verification"
    case emailVerification = "Email Verification"
    case socialMedia = "Social Media Verification"
    case thirdPartyAPI = "Third-Party API"
    case manualReview = "Manual Review"
    
    var description: String {
        switch self {
        case .clearMe: return "Biometric identity verification through ClearMe"
        case .documentUpload: return "Upload and verification of official documents"
        case .videoCall: return "Live video call with verification specialist"
        case .phoneCall: return "Phone call verification with company/employer"
        case .emailVerification: return "Email-based verification process"
        case .socialMedia: return "Social media profile verification"
        case .thirdPartyAPI: return "Automated verification through third-party APIs"
        case .manualReview: return "Manual review by verification team"
        }
    }
    
    var iconName: String {
        switch self {
        case .clearMe: return "faceid"
        case .documentUpload: return "doc.text"
        case .videoCall: return "video.circle"
        case .phoneCall: return "phone.circle"
        case .emailVerification: return "envelope.circle"
        case .socialMedia: return "person.2.circle"
        case .thirdPartyAPI: return "network"
        case .manualReview: return "person.crop.rectangle"
        }
    }
    
    var isAutomated: Bool {
        switch self {
        case .clearMe, .thirdPartyAPI, .emailVerification: return true
        case .documentUpload, .videoCall, .phoneCall, .socialMedia, .manualReview: return false
        }
    }
}

// MARK: - Verification Providers

enum VerificationProvider: String, Codable, CaseIterable {
    case clearMe = "ClearMe"
    case stryVr = "StryVr Internal"
    case equifax = "Equifax"
    case experian = "Experian"
    case transunion = "TransUnion"
    case hireright = "HireRight"
    case sterling = "Sterling"
    case checkr = "Checkr"
    case custom = "Custom Provider"
    
    var description: String {
        switch self {
        case .clearMe: return "ClearMe biometric identity verification"
        case .stryVr: return "StryVr internal verification system"
        case .equifax: return "Equifax background check services"
        case .experian: return "Experian employment verification"
        case .transunion: return "TransUnion background screening"
        case .hireright: return "HireRight comprehensive screening"
        case .sterling: return "Sterling background check services"
        case .checkr: return "Checkr background screening"
        case .custom: return "Custom verification provider"
        }
    }
    
    var logoURL: String? {
        switch self {
        case .clearMe: return "https://clearme.com/logo.png"
        case .stryVr: return nil // Use app icon
        case .equifax: return "https://equifax.com/logo.png"
        case .experian: return "https://experian.com/logo.png"
        case .transunion: return "https://transunion.com/logo.png"
        case .hireright: return "https://hireright.com/logo.png"
        case .sterling: return "https://sterling.com/logo.png"
        case .checkr: return "https://checkr.com/logo.png"
        case .custom: return nil
        }
    }
    
    var isTrusted: Bool {
        switch self {
        case .clearMe, .equifax, .experian, .transunion, .hireright, .sterling, .checkr: return true
        case .stryVr, .custom: return false
        }
    }
}

// MARK: - Verification Data

struct VerificationData: Codable {
    var identityData: IdentityVerificationData?
    var companyData: CompanyVerificationData?
    var employmentData: EmploymentVerificationData?
    var skillsData: SkillsVerificationData?
    var educationData: EducationVerificationData?
    var backgroundData: BackgroundCheckData?
    
    // ClearMe specific data
    var clearMeData: ClearMeVerificationData?
    
    // Generic verification data
    var documentURLs: [String]?
    var verificationNotes: String?
    var verificationScore: Double?
    var metadata: [String: String]?
    
    func isValid() -> Bool {
        // At least one verification data type must be present
        return identityData != nil || companyData != nil || employmentData != nil || 
               skillsData != nil || educationData != nil || backgroundData != nil ||
               clearMeData != nil
    }
}

// MARK: - Identity Verification Data

struct IdentityVerificationData: Codable {
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var governmentID: String? // Encrypted
    var passportNumber: String? // Encrypted
    var address: String? // Encrypted
    var phoneNumber: String? // Encrypted
    var emailAddress: String? // Encrypted
    
    var isComplete: Bool {
        return !firstName.isEmpty && !lastName.isEmpty && dateOfBirth < Date()
    }
}

// MARK: - Company Verification Data

struct CompanyVerificationData: Codable {
    var companyName: String
    var companyWebsite: String?
    var companyEmail: String?
    var companyPhone: String?
    var employeeID: String?
    var position: String?
    var startDate: Date?
    var endDate: Date?
    var verificationContact: String?
    var verificationMethod: String?
    
    var isComplete: Bool {
        return !companyName.isEmpty
    }
}

// MARK: - Employment Verification Data

struct EmploymentVerificationData: Codable {
    var companyName: String
    var position: String
    var startDate: Date
    var endDate: Date?
    var supervisorName: String?
    var supervisorEmail: String?
    var supervisorPhone: String?
    var performanceRating: Double?
    var responsibilities: [String]?
    var achievements: [String]?
    var salary: Double?
    var verificationStatus: String?
    
    var isComplete: Bool {
        return !companyName.isEmpty && !position.isEmpty
    }
}

// MARK: - Skills Verification Data

struct SkillsVerificationData: Codable {
    var skillName: String
    var skillLevel: String
    var certificationURL: String?
    var projectURL: String?
    var assessmentScore: Double?
    var verifiedBy: String?
    var verificationDate: Date?
    
    var isComplete: Bool {
        return !skillName.isEmpty && !skillLevel.isEmpty
    }
}

// MARK: - Education Verification Data

struct EducationVerificationData: Codable {
    var institutionName: String
    var degree: String
    var fieldOfStudy: String
    var graduationDate: Date?
    var gpa: Double?
    var transcriptURL: String?
    var diplomaURL: String?
    var verificationStatus: String?
    
    var isComplete: Bool {
        return !institutionName.isEmpty && !degree.isEmpty && !fieldOfStudy.isEmpty
    }
}

// MARK: - Background Check Data

struct BackgroundCheckData: Codable {
    var checkType: String
    var checkDate: Date
    var results: String
    var reportURL: String?
    var findings: [String]?
    var recommendations: [String]?
    
    var isComplete: Bool {
        return !checkType.isEmpty && !results.isEmpty
    }
}

// MARK: - ClearMe Verification Data

struct ClearMeVerificationData: Codable {
    var clearMeID: String
    var verificationToken: String
    var biometricData: String? // Encrypted
    var verificationLevel: ClearMeVerificationLevel
    var verificationDate: Date
    var expirationDate: Date?
    var verificationScore: Double?
    
    var isActive: Bool {
        guard let expirationDate = expirationDate else { return true }
        return expirationDate > Date()
    }
}

enum ClearMeVerificationLevel: String, Codable, CaseIterable {
    case basic = "Basic"
    case standard = "Standard"
    case premium = "Premium"
    case enterprise = "Enterprise"
    
    var description: String {
        switch self {
        case .basic: return "Basic identity verification"
        case .standard: return "Standard verification with document check"
        case .premium: return "Premium verification with background check"
        case .enterprise: return "Enterprise-level comprehensive verification"
        }
    }
    
    var verificationScore: Double {
        switch self {
        case .basic: return 0.7
        case .standard: return 0.85
        case .premium: return 0.95
        case .enterprise: return 0.99
        }
    }
}

// MARK: - Verification Status

enum VerificationStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case inProgress = "In Progress"
    case underReview = "Under Review"
    case approved = "Approved"
    case rejected = "Rejected"
    case expired = "Expired"
    case cancelled = "Cancelled"
    
    var description: String {
        switch self {
        case .pending: return "Verification request submitted and awaiting processing"
        case .inProgress: return "Verification is currently being processed"
        case .underReview: return "Verification is under manual review"
        case .approved: return "Verification has been approved"
        case .rejected: return "Verification has been rejected"
        case .expired: return "Verification has expired and needs renewal"
        case .cancelled: return "Verification request was cancelled"
        }
    }
    
    var iconName: String {
        switch self {
        case .pending: return "clock"
        case .inProgress: return "arrow.clockwise"
        case .underReview: return "doc.text.magnifyingglass"
        case .approved: return "checkmark.seal.fill"
        case .rejected: return "xmark.seal.fill"
        case .expired: return "exclamationmark.triangle"
        case .cancelled: return "xmark.circle"
        }
    }
    
    var colorCode: String {
        switch self {
        case .pending: return "gray"
        case .inProgress: return "blue"
        case .underReview: return "orange"
        case .approved: return "green"
        case .rejected: return "red"
        case .expired: return "yellow"
        case .cancelled: return "gray"
        }
    }
} 