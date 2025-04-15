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
                self.logger.error("❌ Failed to update user data: \(error.localizedDescription)")
            if let error = error {
                completion(.failure(error))
            } else {
                self.logger.info("✅ User data updated")
                completion(.success(()))
            }
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
