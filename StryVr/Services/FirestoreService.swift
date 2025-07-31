//
//  FirestoreService.swift
//  StryVr
//
//  Created by Joe Dormond on 2/24/25
//
//  📡 FirestoreService – Centralized Firestore access layer for user data, skills, and history
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import OSLog

class FirestoreService {
    static let shared = FirestoreService()
    private let firestore = Firestore.firestore()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "FirestoreService")
    private init() {}

    func fetchUserData(userID: String, completion: @escaping (Result<UserData, Error>) -> Void) {
        guard Auth.auth().currentUser != nil else {
            logger.error("⛔ No authenticated user session")
            completion(.failure(FirestoreServiceError.invalidInput))
            return
        }
        guard !userID.isEmpty else {
            completion(.failure(FirestoreServiceError.invalidInput))
            return
        }
        firestore.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                self.logger.error("❌ Firestore fetch error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let document = document, document.exists,
                let data = try? document.data(as: UserData.self)
            else {
                self.logger.warning("⚠️ Document missing or malformed")
                completion(.failure(FirestoreServiceError.invalidInput))
                return
            }

            self.logger.info("✅ User data retrieved")
            completion(.success(data))
        }
    }

    func updateUserData(
        userID: String, fields: [String: Any], completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard Auth.auth().currentUser != nil else {
            logger.error("⛔ No authenticated user session")
            completion(.failure(FirestoreServiceError.invalidInput))
            return
        }
        guard !userID.isEmpty else {
            completion(.failure(FirestoreServiceError.invalidInput))
            return
        }
        firestore.collection("users").document(userID).updateData(fields) { error in
            if let error = error {
                self.logger.error("❌ Failed to update user data: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                self.logger.info("✅ User data updated successfully")
                completion(.success(()))
            }
        }
    }

    func fetchSkillProgress(completion: @escaping (Result<[SkillProgress], Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            logger.error("⛔ No authenticated user session")
            completion(.failure(FirestoreServiceError.invalidInput))
            return
        }

        firestore.collection("users").document(userID).collection("skills").getDocuments {
            snapshot, error in
            if let error = error {
                self.logger.error("❌ Failed to fetch skill progress: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let documents = snapshot?.documents else {
                self.logger.warning("⚠️ No skill documents found")
                completion(.success([]))
                return
            }

            let skills = documents.compactMap { document -> SkillProgress? in
                try? document.data(as: SkillProgress.self)
            }

            self.logger.info("✅ Retrieved \(skills.count) skill progress records")
            completion(.success(skills))
        }
    }
}

enum FirestoreServiceError: LocalizedError {
    case invalidInput

    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Invalid input provided."
        }
    }
}
