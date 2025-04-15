//
//  AIRecommendationService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/11/25.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import os.log

/// AI-powered recommendation service for mentors and skills
final class AIRecommendationService {
    static let shared = AIRecommendationService()
    private let db: Firestore
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "AIRecommendationService")

    private init(db: Firestore = Firestore.firestore()) {
        self.db = db
    }

    // MARK: - Mentor Recommendations

    /// Fetches top-rated mentors for the user
    func fetchMentorRecommendations(for userID: String, completion: @escaping ([MentorModel]) -> Void) {
        guard !userID.isEmpty else {
            logger.error("❌ Invalid user ID")
            completion([])
            return
        }

        db.collection("mentors")
            .order(by: "rating", descending: true)
            .limit(to: 5)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.logger.error("❌ Failed to fetch mentors: \(error.localizedDescription)")
                    completion([])
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.logger.error("⚠️ No mentor documents found")
                    completion([])
                    return
                }

                let mentors = documents.compactMap { doc in
                    try? doc.data(as: MentorModel.self)
                }

                self.logger.info("✅ Loaded \(mentors.count) mentor recommendations")
                completion(mentors)
            }
    }

    /// Uses current skills to suggest related skills
    // MARK: - Skill Recommendations

    func fetchSkillRecommendations(for userID: String, completion: @escaping ([String]) -> Void) {
        guard !userID.isEmpty else {
            logger.error("❌ Invalid user ID")
            completion([])
            return
        }

        db.collection("users")
            .document(userID)
            .getDocument { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.logger.error("❌ Skill fetch error: \(error.localizedDescription)")
                    completion([])
                    return
                }

                guard let data = snapshot?.data() else {
                    self.logger.error("⚠️ No skill data found")
                    completion([])
                    return
                }

                let currentSkills = data["skills"] as? [String] ?? []
                let suggestions = Self.generateSkillSuggestions(from: currentSkills)
                self.logger.info("✅ Suggested \(suggestions.count) skills")
                completion(suggestions)
            }
    }

    // MARK: - Static AI Skill Logic

    /// Placeholder AI suggestion logic (replace with real AI engine later)
    private static func generateSkillSuggestions(from skills: [String]) -> [String] {
        let skillMap: [String: [String]] = [
            "Swift": ["SwiftUI", "Combine", "Core Data"],
            "Firebase": ["Firestore", "Cloud Functions"],
            "UI/UX Design": ["Figma", "Sketch", "User Testing"]
        ]

        var recommended: [String] = []

        for skill in skills {
            if let related = skillMap[skill] {
                recommended.append(contentsOf: related)
            }
        }

        return Array(Set(recommended))
    }
}
