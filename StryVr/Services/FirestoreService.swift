//
//  FirestoreService.swift
//  StryVr
//
//  Created by Joe Dormond on 2/24/25.
//

import Foundation
import FirebaseFirestore
import os.log

/// General Firestore fetch/update service
final class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "FirestoreService")

    private init() {}

    // MARK: - Fetch User Document
    /// Fetches user data from Firestore
    func fetchUserData(userID: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard !userID.isEmpty else {
            logger.error("❌ Invalid userID provided")
            completion(.failure(FirestoreServiceError.invalidInput))
            return
        }

        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                self.logger.error("❌ Firestore fetch error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let document = document, document.exists, let data = document.data() else {
                self.logger.warning("⚠️ User document does not exist. Returning default guest profile.")
                completion(.success(["name": "Guest", "email": "unknown"]))
                return
            }

            self.logger.info("✅ User data retrieved")
            completion(.success(data))
        }
    }

    // MARK: - Update User Document
    /// Updates user data in Firestore
    func updateUserData(userID: String, fields: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        guard !userID.isEmpty, !fields.isEmpty else {
            logger.error("❌ Invalid input for updating user data")
            completion(.failure(FirestoreServiceError.invalidInput))
            return
        }

        db.collection("users").document(userID).updateData(fields) { error in
            if let error = error {
                self.logger.error("❌ Failed to update user data: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                self.logger.info("✅ User data updated")
                completion(.success(()))
            }
        }
    }

    // MARK: - Fetch User Work History
    func fetchWorkHistory(for userID: String, completion: @escaping ([CompanyExperience]) -> Void) {
        let ref = db.collection("users").document(userID).collection("experiences")
        ref.getDocuments { snapshot, error in
            if let error = error {
                self.logger.error("❌ Failed to fetch work history: \(error.localizedDescription)")
                completion([])
                return
            }

            let history = snapshot?.documents.compactMap { doc -> CompanyExperience? in
                let data = doc.data()
                return CompanyExperience(
                    companyName: data["companyName"] as? String ?? "",
                    logoURL: data["logoURL"] as? String ?? "",
                    isVerified: data["isVerified"] as? Bool ?? false,
                    jobTitle: data["jobTitle"] as? String ?? "",
                    startDate: data["startDate"] as? String ?? "",
                    endDate: data["endDate"] as? String ?? "",
                    performanceNotes: data["performanceNotes"] as? String ?? ""
                )
            } ?? []

            self.logger.info("✅ Work history retrieved: \(history.count) entries")
            completion(history)
        }
    }

    // MARK: - Fetch Top Skills
    func fetchTopSkills(for userID: String, completion: @escaping ([SkillChartData]) -> Void) {
        let ref = db.collection("users").document(userID)
        ref.getDocument { snapshot, error in
            if let error = error {
                self.logger.error("❌ Failed to fetch top skills: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let data = snapshot?.data(), let skillsRaw = data["skills"] as? [[String: Any]] else {
                self.logger.warning("⚠️ No skills found in user document")
                completion([])
                return
            }

            let skills = skillsRaw.compactMap { item -> SkillChartData? in
                guard let name = item["name"] as? String,
                      let percent = item["percent"] as? Double else { return nil }
                return SkillChartData(skillName: name, percentage: percent)
            }

            self.logger.info("✅ Top skills retrieved: \(skills.count) entries")
            completion(skills)
        }
    }
}

// MARK: - Custom Error Type
enum FirestoreServiceError: LocalizedError {
    case invalidInput

    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Invalid input provided."
        }
    }
}
