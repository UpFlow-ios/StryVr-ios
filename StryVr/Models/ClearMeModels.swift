//
//  ClearMeModels.swift
//  StryVr
//
//  🔐 ClearMe API Data Models
//  Based on official ClearMe API documentation
//

import Foundation

// MARK: - ClearMe API Request Models

/// Request model for creating a verification session
struct ClearMeCreateSessionRequest: Codable {
    let projectId: String
    let redirectUrl: String?
    let phone: String?
    let email: String?
    let locale: String?
    let customFields: [String: String]?
    let clearMemberId: String?
    
    enum CodingKeys: String, CodingKey {
        case projectId = "project_id"
        case redirectUrl = "redirect_url"
        case phone
        case email
        case locale
        case customFields = "custom_fields"
        case clearMemberId = "clear_member_id"
    }
}

// MARK: - ClearMe API Response Models

/// Main verification session response
struct ClearMeVerificationSession: Codable {
    let id: String
    let objectName: String
    let authenticated: Bool
    let authenticationMethods: [String]
    let activatedAuthenticationMethods: [String]
    let checks: [ClearMeCheck]
    let completedAt: Int?
    let createdAt: Int
    let email: String?
    let expiresAt: Int
    let fieldsToCollect: [String]
    let ip: [String]
    let phone: String?
    let redirectUrl: String?
    let status: ClearMeSessionStatus
    let token: String
    let updatedAt: Int
    let userAgent: [String]
    let userCreated: Bool
    let userId: String?
    let traits: ClearMeTraits?
    let projectId: String
    let userProfileInformation: ClearMeUserProfileInformation?
    let customFields: [String: String]
    let userProfileMatchStatus: String?
    let idvStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case objectName = "object_name"
        case authenticated
        case authenticationMethods = "authentication_methods"
        case activatedAuthenticationMethods = "activated_authentication_methods"
        case checks
        case completedAt = "completed_at"
        case createdAt = "created_at"
        case email
        case expiresAt = "expires_at"
        case fieldsToCollect = "fields_to_collect"
        case ip
        case phone
        case redirectUrl = "redirect_url"
        case status
        case token
        case updatedAt = "updated_at"
        case userAgent = "user_agent"
        case userCreated = "user_created"
        case userId = "user_id"
        case traits
        case projectId = "project_id"
        case userProfileInformation = "user_profile_information"
        case customFields = "custom_fields"
        case userProfileMatchStatus = "user_profile_match_status"
        case idvStatus = "idv_status"
    }
}

/// Verification session status enum
enum ClearMeSessionStatus: String, Codable {
    case success = "success"
    case fail = "fail"
    case awaitingUserInput = "awaiting_user_input"
    case processingData = "processing_data"
    case expired = "expired"
    case awaitingManualReview = "awaiting_manual_review"
    case manualSuccess = "manual_success"
    case manualFail = "manual_fail"
    case canceled = "canceled"
}

/// Individual check within a verification session
struct ClearMeCheck: Codable {
    let name: String
    let value: ClearMeCheckValue?
    let status: ClearMeCheckStatus
    let additionalDetails: ClearMeAdditionalDetails?
    let params: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case value
        case status
        case additionalDetails = "additional_details"
        case params
    }
}

/// Check value can be various types
enum ClearMeCheckValue: Codable {
    case boolean(Bool)
    case integer(Int)
    case number(Double)
    case string(String)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self = .null
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .boolean(boolValue)
        } else if let intValue = try? container.decode(Int.self) {
            self = .integer(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .number(doubleValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode ClearMeCheckValue")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .boolean(let value):
            try container.encode(value)
        case .integer(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

/// Check status enum
enum ClearMeCheckStatus: String, Codable {
    case completed = "completed"
    case skipped = "skipped"
    case error = "error"
}

/// Additional details for checks
struct ClearMeAdditionalDetails: Codable {
    let watchlistHits: ClearMeWatchlistHits?
    let params: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case watchlistHits = "watchlist_hits"
        case params
    }
}

/// Watchlist hits information
struct ClearMeWatchlistHits: Codable {
    let hits: [ClearMeWatchlistHit]
    let updatedAt: Int
    
    enum CodingKeys: String, CodingKey {
        case hits
        case updatedAt = "updated_at"
    }
}

/// Individual watchlist hit
struct ClearMeWatchlistHit: Codable {
    let entityType: String
    let details: ClearMeHitDetails
    let sourceLists: [ClearMeSourceList]
    let hitTypes: [String]
    
    enum CodingKeys: String, CodingKey {
        case entityType = "entity_type"
        case details
        case sourceLists = "source_lists"
        case hitTypes = "hit_types"
    }
}

/// Details of a watchlist hit
struct ClearMeHitDetails: Codable {
    let name: [String]?
    let alias: [String]?
    let country: [String]?
    let address: [ClearMeAddress]?
    let dateOfBirth: [ClearMeDate]?
    let dateOfDeath: [ClearMeDate]?
    let placeOfBirth: [String]?
    let gender: [String]?
    let nationality: [String]?
    let position: [String]?
    let passportNumber: [String]?
    let idNumber: [String]?
    let notes: [String]?
    let createdAt: [ClearMeDate]?
    let modifiedAt: [ClearMeDate]?
    let sourceUrls: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case alias
        case country
        case address
        case dateOfBirth = "date_of_birth"
        case dateOfDeath = "date_of_death"
        case placeOfBirth = "place_of_birth"
        case gender
        case nationality
        case position
        case passportNumber = "passport_number"
        case idNumber = "id_number"
        case notes
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case sourceUrls = "source_urls"
    }
}

/// Source list information
struct ClearMeSourceList: Codable {
    let name: String
    let summary: String
    let url: String
}

/// User traits information
struct ClearMeTraits: Codable {
    let address: ClearMeAddress?
    let dob: ClearMeDate?
    let email: String?
    let firstName: String?
    let lastName: String?
    let middleName: String?
    let secondFamilyName: String?
    let fullLastName: String?
    let phone: String?
    let ssn4: String?
    let ssn9: String?
    let identificationNumber: String?
    let identificationType: String?
    let document: ClearMeDocument?
    let documentFront: String?
    let documentBack: String?
    let faceScanPreview: String?
    let healthInsurance: ClearMeHealthInsurance?
    
    enum CodingKeys: String, CodingKey {
        case address
        case dob
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case middleName = "middle_name"
        case secondFamilyName = "second_family_name"
        case fullLastName = "full_last_name"
        case phone
        case ssn4
        case ssn9
        case identificationNumber = "identification_number"
        case identificationType = "identification_type"
        case document
        case documentFront = "document_front"
        case documentBack = "document_back"
        case faceScanPreview = "face_scan_preview"
        case healthInsurance = "health_insurance"
    }
}

/// Address information
struct ClearMeAddress: Codable {
    let line1: String?
    let line2: String?
    let city: String?
    let state: String?
    let postalCode: String?
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case line1
        case line2
        case city
        case state
        case postalCode = "postal_code"
        case country
    }
}

/// Date information
struct ClearMeDate: Codable {
    let day: Int
    let month: Int
    let year: Int
}

/// Document information
struct ClearMeDocument: Codable {
    let nationality: String?
    let documentType: String?
    let issuingCountry: String?
    let issuingSubdivision: String?
    let documentNumber: String?
    let dateOfExpiry: ClearMeDate?
    let gender: String?
    let address: ClearMeAddress?
    let dateOfBirth: ClearMeDate?
    let firstName: String?
    let lastName: String?
    let middleName: String?
    
    enum CodingKeys: String, CodingKey {
        case nationality
        case documentType = "document_type"
        case issuingCountry = "issuing_country"
        case issuingSubdivision = "issuing_subdivision"
        case documentNumber = "document_number"
        case dateOfExpiry = "date_of_expiry"
        case gender
        case address
        case dateOfBirth = "date_of_birth"
        case firstName = "first_name"
        case lastName = "last_name"
        case middleName = "middle_name"
    }
}

/// Health insurance information
struct ClearMeHealthInsurance: Codable {
    let payerId: String?
    let payerName: String?
    let planStatus: String?
    let planName: String?
    let planType: String?
    let groupName: String?
    let groupId: String?
    let insuranceType: String?
    let insuranceMemberId: String?
    
    enum CodingKeys: String, CodingKey {
        case payerId = "payer_id"
        case payerName = "payer_name"
        case planStatus = "plan_status"
        case planName = "plan_name"
        case planType = "plan_type"
        case groupName = "group_name"
        case groupId = "group_id"
        case insuranceType = "insurance_type"
        case insuranceMemberId = "insurance_member_id"
    }
}

/// User profile information
struct ClearMeUserProfileInformation: Codable {
    let name: ClearMeName?
    let dob: String?
    let phone: String?
    let address: ClearMeAddress?
    let email: String?
}

/// Name information
struct ClearMeName: Codable {
    let firstName: String?
    let lastName: String?
    let middleName: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case middleName = "middle_name"
    }
}

// MARK: - ClearMe Error Models

/// ClearMe API error response
struct ClearMeError: Codable {
    let error: ClearMeErrorDetails
}

/// Error details
struct ClearMeErrorDetails: Codable {
    let type: String
    let message: String
    let code: String?
} 