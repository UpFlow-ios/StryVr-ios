//
//  MentorMatchingService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import os.log

/// AI-driven mentor-mentee matching service
final class MentorMatchingService {

    static let shared = MentorMatchingService()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "MentorMatchingService")

    private init() {}

    // MARK: - Public Match Entry Point
    /// Finds the best mentor for a given user
    func findMentor(for userID: String, completion: @escaping (MentorModel?) -> Void) {
        guard !userID.isEmpty else {
            logger.error("❌ Invalid userID provided")
            completion(nil)
            return
        }

        db.collection("users").document(userID).getDocument { snapshot, error in
            guard let userData = snapshot?.data(), error == nil else {
                self.logger.error("❌ Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            let userSkills = userData["skills"] as? [String] ?? []
            let learningGoals = userData["learningGoals"] as? [String] ?? []

            self.findMatchingMentor(for: userSkills, learningGoals: learningGoals, completion: completion)
        }
    }

    // MARK: - Search Top Rated Mentors
    /// Searches for the best matching mentor based on skills and learning goals
    private func findMatchingMentor(for skills: [String], learningGoals: [String], completion: @escaping (MentorModel?) -> Void) {
        db.collection("mentors")
            .order(by: "rating", descending: true)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    self.logger.error("❌ Error fetching mentors: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }

                let mentors = documents.compactMap { doc in
                    try? doc.data(as: MentorModel.self)
                }

                let bestMatch = self.findBestMatch(from: mentors, skills: skills, learningGoals: learningGoals)
                self.logger.info("✅ Best mentor matched: \(bestMatch?.fullName ?? "None")")
                completion(bestMatch)
            }
    }

    // MARK: - Match Ranking Logic
    /// Finds the best mentor match based on ranking logic
    private func findBestMatch(from mentors: [MentorModel], skills: [String], learningGoals: [String]) -> MentorModel? {
        var bestScore = 0.0
        var bestMentor: MentorModel?

        for mentor in mentors {
            let expertiseMatch = mentor.expertise.filter { skills.contains($0) || learningGoals.contains($0) }
            let matchCount = expertiseMatch.count
            let skillScore = Double(matchCount)
            let ratingScore = mentor.rating / 5.0
            let totalScore = skillScore + ratingScore

            if totalScore > bestScore {
                bestScore = totalScore
                bestMentor = mentor
            }
        }

        return bestMentor
    }
}
