//
//  AIRecommendationService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/11/25
//
//  🤖 AI Recommendation Service – Enhanced with Hugging Face integration
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import OSLog

final class AIRecommendationService {
    static let shared = AIRecommendationService()
    private let db: Firestore
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "AIRecommendationService"
    )

    private init() {
        self.db = Firestore.firestore()
    }

    // MARK: - Public Methods

    func getSkillRecommendations(
        for currentSkills: [String], completion: @escaping ([String]) -> Void
    ) {
        requestAISuggestions(currentSkills: currentSkills, completion: completion)
    }

    func saveSkillRecommendation(_ skill: String, for userId: String) {
        let recommendation =
            [
                "skill": skill,
                "userId": userId,
                "timestamp": FieldValue.serverTimestamp(),
                "source": "ai_recommendation",
            ] as [String: Any]

        db.collection("skill_recommendations").addDocument(data: recommendation) {
            [weak self] error in
            if let error = error {
                self?.logger.error(
                    "❌ Failed to save skill recommendation: \(error.localizedDescription)")
            } else {
                self?.logger.info("✅ Skill recommendation saved successfully")
            }
        }
    }

    func getPersonalizedRecommendations(
        for userId: String, completion: @escaping ([String]) -> Void
    ) {
        db.collection("skill_recommendations")
            .whereField("userId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .limit(to: 10)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    self?.logger.error(
                        "❌ Failed to fetch recommendations: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let recommendations =
                    snapshot?.documents.compactMap { doc -> String? in
                        return doc.data()["skill"] as? String
                    } ?? []

                self?.logger.info("📊 Fetched \(recommendations.count) personalized recommendations")
                completion(recommendations)
            }
    }

    // MARK: - Private AI Request Method

    private func requestAISuggestions(
        currentSkills: [String], completion: @escaping ([String]) -> Void
    ) {
        do {
            let apiKey = try SecureStorageManager.shared.load(key: "huggingFaceAPIKey")
            guard !apiKey.isEmpty else {
                logger.error("❌ Missing API Key for Hugging Face.")
                completion([])
                return
            }

            let headers = ["Authorization": "Bearer \(apiKey)"]
            let body = [
                "inputs":
                    "Given skills: \(currentSkills.joined(separator: ", ")). Suggest related professional skills."
            ]

            APIService.shared.postJSON(
                to: "https://api-inference.huggingface.co/models/gpt2",
                body: body,
                headers: headers,
                as: [AISuggestionResponse].self
            ) { [weak self] result in
                switch result {
                case .success(let responses):
                    let suggestions = responses.compactMap { $0.generated_text }
                    self?.logger.info("🤖 AI generated \(suggestions.count) skill suggestions")
                    completion(suggestions)
                case .failure(let error):
                    self?.logger.error("❌ AI request failed: \(error.localizedDescription)")
                    completion([])
                }
            }
        } catch {
            logger.error("❌ Failed to load API key: \(error.localizedDescription)")
            completion([])
        }
    }
}
