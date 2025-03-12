//
//  AIProfileValidator.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import FirebaseFirestore
import os.log

/// AI-driven profile validation to detect fake accounts
final class AIProfileValidator {

    static let shared = AIProfileValidator()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AIProfileValidator")

    private init() {}

    /// Checks if a profile is potentially fake based on multiple factors
    /// - Parameters:
    ///   - userID: The ID of the user to validate.
    ///   - completion: A closure that returns a boolean indicating if the profile is valid.
    func validateProfile(userID: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(userID).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                logger.error("Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }

            let profileStrength = AIProfileValidator.analyzeProfile(data)
            completion(profileStrength >= 70) // Minimum threshold for a valid profile
        }
    }

    /// Analyzes a profile's data and assigns a score
    /// - Parameter data: The profile data to analyze.
    /// - Returns: An integer score representing the profile strength.
    private static func analyzeProfile(_ data: [String: Any]) -> Int {
        var score = 0

        // Check if profile has a verified email
        if let emailVerified = data["isVerified"] as? Bool, emailVerified {
            score += 30
        }

        // Check if profile has a bio, profile image, and skills
        if let bio = data["bio"] as? String, !bio.isEmpty { score += 20 }
        if let profileImage = data["profileImageURL"] as? String, !profileImage.isEmpty { score += 20 }
        if let skills = data["skills"] as? [String], !skills.isEmpty { score += 30 }

        return score
    }
}
