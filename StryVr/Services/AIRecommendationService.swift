//
//  AIRecommendationService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/11/25.
//
import Foundation
import FirebaseFirestore
import os.log

/// AI-powered recommendation service for StryVr
final class AIRecommendationService {
    static let shared = AIRecommendationService()
    private let db: Firestore
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AIRecommendationService")
    
    private init(db: Firestore = Firestore.firestore()) {
        self.db = db
    }

    /// Fetches personalized mentor recommendations for a user
    /// - Parameters:
    ///   - userID: The ID of the user to fetch recommendations for
    ///   - completion: Completion handler with an array of MentorModel
    func fetchMentorRecommendations(for userID: String, completion: @escaping ([MentorModel]) -> Void) {
        db.collection("mentors")
            .order(by: "rating", descending: true)
            .limit(to: 5)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    self.logger.error("Error fetching mentors: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.logger.error("No documents found")
                    completion([])
                    return
                }
                
                let mentors = documents.compactMap { doc -> MentorModel? in
                    try? doc.data(as: MentorModel.self)
                }
                
                completion(mentors)
            }
    }

    /// Fetches skill recommendations based on user progress
    /// - Parameters:
    ///   - userID: The ID of the user to fetch recommendations for
    ///   - completion: Completion handler with an array of recommended skills
    func fetchSkillRecommendations(for userID: String, completion: @escaping ([String]) -> Void) {
        db.collection("users").document(userID).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                self.logger.error("Error fetching user data: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let data = snapshot?.data() else {
                self.logger.error("No data found for user \(userID)")
                completion([])
                return
            }

            let userSkills = data["skills"] as? [String] ?? []
            let recommendedSkills = AIRecommendationService.generateSkillSuggestions(from: userSkills)
            completion(recommendedSkills)
        }
    }
    
    /// AI-based logic to suggest skills based on current skills
    /// - Parameter skills: An array of current skills
    /// - Returns: An array of recommended skills
    private static func generateSkillSuggestions(from skills: [String]) -> [String] {
        let skillMappings: [String: [String]] = [
            "Swift": ["SwiftUI", "Combine", "Core Data"],
            "Firebase": ["Firestore", "Cloud Functions"],
            "UI/UX Design": ["Figma", "Sketch", "User Testing"]
        ]
        
        var suggestions: [String] = []
        for skill in skills {
            if let relatedSkills = skillMappings[skill] {
                suggestions.append(contentsOf: relatedSkills)
            }
        }
        return Array(Set(suggestions)) // Remove duplicates
    }
}
