//
//  FirestoreService.swift
//  StryVr
//
//  Created by Joe Dormond on 2/24/25.
//
import FirebaseFirestore
import Combine
import CocoaLumberjackSwift

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    func fetchUserData(userID: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                DDLogError("Firestore Fetch Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let document = document, document.exists, let data = document.data() {
                DDLogInfo("User data retrieved successfully")
                completion(.success(data))
            } else {
                DDLogWarn("User document does not exist, returning empty data")
                completion(.success(["name": "Guest", "email": "unknown"]))
            }
        }
    }
}

