//
//  EmployeeProgressService.swift
//  StryVr
//
//  Created by Joe Dormond on 5/6/25.
//  📈 Service – Fetches employee timeline events from Firestore
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class EmployeeProgressService {
    static let shared = EmployeeProgressService()
    private let db = Firestore.firestore()

    private init() {}

    func fetchTimeline(for employeeId: String, completion: @escaping (Result<[EmployeeTimelineEvent], Error>) -> Void) {
        db.collection("employeeTimeline")
            .whereField("employeeId", isEqualTo: employeeId)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                let events = snapshot?.documents.compactMap {
                    try? $0.data(as: EmployeeTimelineEvent.self)
                } ?? []

                completion(.success(events))
            }
    }
}

