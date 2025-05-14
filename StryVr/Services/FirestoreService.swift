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
import os.log

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "FirestoreService")
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
        // ... rest of fetchUserData implementation
    }

    func updateUserData(userID: String, fields: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        guard Auth.auth().currentUser != nil else {
            logger.error("⛔ No authenticated user session")
            completion(.failure(FirestoreServiceError.invalidInput))
            return
        }
        guard !userID.isEmpty else {
            completion(.failure(FirestoreServiceError.invalidInput))
            return
        }
        // ... rest of updateUserData implementation
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
