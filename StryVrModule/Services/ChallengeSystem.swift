//
//  ChallengeSystem.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25
//
//  🏆 Challenge System – Manages learning challenges, competitions, and streak tracking
//

import Foundation

#if canImport(FirebaseFirestore)
    import FirebaseFirestore
    import FirebaseFirestoreSwift
#endif
#if canImport(os)
    import OSLog
#endif

/// Manages learning challenges, competitions, and streak tracking
final class ChallengeSystem {
    static let shared = ChallengeSystem()
    private let firestore = Firestore.firestore()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "ChallengeSystem")

    private init() {}

    // MARK: - Create Challenge

    /// Creates a new learning challenge
    func createChallenge(
        title: String, description: String, reward: String, durationDays: Int,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        guard !title.isEmpty, !description.isEmpty, !reward.isEmpty else {
            logger.error("❌ Invalid input for creating challenge")
            completion(false, ChallengeError.invalidInput)
            return
        }

        let challengeID = UUID().uuidString
        let endDate =
            Calendar.current.date(byAdding: .day, value: durationDays, to: Date()) ?? Date()

        let challengeData: [String: Any] = [
            "title": title,
            "description": description,
            "reward": reward,
            "startDate": Date(),
            "endDate": endDate,
            "participants": [],
            "completedUsers": [],
        ]

        firestore.collection("challenges").document(challengeID).setData(challengeData) { error in
            if let error = error {
                self.logger.error("❌ Error creating challenge: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("🏁 Challenge created: \(title)")
                completion(true, nil)
            }
        }
    }

    // MARK: - Join Challenge

    /// Allows a user to join a challenge
    func joinChallenge(
        challengeID: String, userID: String, completion: @escaping (Bool, Error?) -> Void
    ) {
        guard !challengeID.isEmpty, !userID.isEmpty else {
            logger.error("❌ Invalid input for joining challenge")
            completion(false, ChallengeError.invalidInput)
            return
        }

        let ref = firestore.collection("challenges").document(challengeID)

        ref.updateData([
            "participants": FieldValue.arrayUnion([userID])
        ]) { error in
            if let error = error {
                self.logger.error("❌ Failed to join challenge: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("✅ User joined challenge \(challengeID)")
                completion(true, nil)
            }
        }
    }

    // MARK: - Complete Challenge

    /// Marks a challenge as completed for a user
    func completeChallenge(
        challengeID: String, userID: String, completion: @escaping (Bool, Error?) -> Void
    ) {
        guard !challengeID.isEmpty, !userID.isEmpty else {
            logger.error("❌ Invalid input for completing challenge")
            completion(false, ChallengeError.invalidInput)
            return
        }

        let ref = firestore.collection("challenges").document(challengeID)

        ref.updateData([
            "completedUsers": FieldValue.arrayUnion([userID])
        ]) { error in
            if let error = error {
                self.logger.error("❌ Failed to complete challenge: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("✅ User completed challenge \(challengeID)")
                completion(true, nil)
            }
        }
    }

    // MARK: - Fetch Active Challenges

    /// Fetches all active challenges
    func fetchActiveChallenges(completion: @escaping ([ChallengeModel]) -> Void) {
        firestore.collection("challenges")
            .whereField("endDate", isGreaterThan: Date())
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.logger.error("❌ Failed to fetch challenges: \(error.localizedDescription)")
                    completion([])
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.logger.warning("⚠️ No active challenges found")
                    completion([])
                    return
                }

                let challenges: [ChallengeModel] = documents.compactMap { doc in
                    try? doc.data(as: ChallengeModel.self)
                }

                self.logger.info("📥 Fetched \(challenges.count) active challenges")
                completion(challenges)
            }
    }
}

// MARK: - Custom Error Type

enum ChallengeError: LocalizedError {
    case invalidInput

    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Invalid input provided."
        }
    }
}
