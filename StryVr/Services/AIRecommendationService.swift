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
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "AIRecommendationService")

    private init(db: Firestore = Firestore.firestore()) {
        self.db = db
    }

    // MARK: - Public Method for Skill Recommendations

    func fetchSkillRecommendations(for userID: String, completion: @escaping ([String]) -> Void) {
        guard !userID.isEmpty else {
            logger.error("❌ Invalid user ID provided.")
            completion([])
            return
        }

        db.collection("users")
            .document(userID)
            .getDocument { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.logger.error("❌ Error fetching user skills: \(error.localizedDescription)")
                    completion([])
                    return
                }

                guard let data = snapshot?.data(),
                      let currentSkills = data["skills"] as? [String]
                else {
                    self.logger.error("⚠️ No skills found for user.")
                    completion([])
                    return
                }

                self.requestAISuggestions(currentSkills: currentSkills, completion: completion)
            }
    }

    // MARK: - Private AI Request Method

    private func requestAISuggestions(currentSkills: [String], completion: @escaping ([String]) -> Void) {
        guard let apiKey = SecureStorageManager.shared.load(key: "huggingFaceAPIKey") else {
            logger.error("❌ Missing API Key for Hugging Face.")
            completion([])
            return
        }

        let headers = ["Authorization": "Bearer \(apiKey)"]
        let body = ["inputs": "Given skills: \(currentSkills.joined(separator: ", ")). Suggest related professional skills."]

        APIService.shared.postJSON(
            to: "https://api-inference.huggingface.co/models/gpt2",
            body: body,
            headers: headers,
            as: [AISuggestionResponse].self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(suggestions):
                    let skillRecommendations = suggestions.flatMap { $0.generatedSkills() }
                    self.logger.info("✅ AI recommended \(skillRecommendations.count) skills successfully.")
                    completion(skillRecommendations)
                case let .failure(error):
                    self.logger.error("❌ AI API call failed: \(error.localizedDescription)")
                    completion([])
                }
            }
        }
    }
}
