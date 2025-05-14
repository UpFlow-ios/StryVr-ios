//
//  UserModel.swift
//  StryVr
//
//  Created by Joe Dormond on [Date]
//
//  👤 User Data Model – Represents user profile details and metadata
//import Foundation

// MARK: - UserModel
/// Represents a user in the StryVr app
struct UserModel: Identifiable, Codable, Hashable {
    let id: String                                // Unique user ID (Firebase)
    var fullName: String                          // User's full name
    var email: String                             // User's email address
    var profileImageURL: String?                  // URL to user's profile image
    var bio: String?                              // User bio/intro
    var skills: [String]                          // Skill tags
    var isVerified: Bool                          // Verified status
    let joinedDate: Date                          // Date of account creation

    // MARK: - Computed Properties

    /// Nicely formatted join date (e.g. "Jan 5, 2025")
    var formattedJoinDate: String {
        return UserModel.dateFormatter.string(from: joinedDate)
    }

    /// Validates email format using regex
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    // MARK: - Default Empty User
    static let empty: UserModel = UserModel(
        id: UUID().uuidString,
        fullName: "",
        email: "",
        role: .admin,
        joinedDate: Date()
    )

    // MARK: - Static Date Formatter
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    // MARK: - Initializer
    init(
        id: String,
        fullName: String,
        email: String,
        profileImageURL: String? = nil,
        bio: String? = nil,
        skills: [String] = [],
        role: UserRole,
        isVerified: Bool = false,
        joinedDate: Date = Date()
    ) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.profileImageURL = profileImageURL
        self.bio = bio
        self.skills = skills
        self.role = role
        self.isVerified = isVerified
        self.joinedDate = joinedDate
    }
}
