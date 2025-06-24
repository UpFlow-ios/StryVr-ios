//
//  BehaviorFeedbackService.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25
//
//  ☁️ Behavior Feedback Service – Submits and retrieves employee behavior feedback using Firestore
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class BehaviorFeedbackService {
    static let shared = BehaviorFeedbackService()
    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Submit Feedback

    func submitFeedback(_ feedback: BehaviorFeedback, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let docRef = db.collection("behaviorFeedback").document(feedback.id)
            try docRef.setData(from: feedback) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Fetch Feedback for Employee

    func fetchFeedback(for employeeId: String, completion: @escaping (Result<[BehaviorFeedback], Error>) -> Void) {
        db.collection("behaviorFeedback")
            .whereField("employeeId", isEqualTo: employeeId)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                let feedbacks = documents.compactMap { doc -> BehaviorFeedback? in
                    try? doc.data(as: BehaviorFeedback.self)
                }
                completion(.success(feedbacks))
            }
    }
}
