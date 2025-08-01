//
//  EmployeeProgressService.swift
//  StryVr
//
//  Created by Joe Dormond on 5/6/25
//
//  📈 Employee Progress Service – Fetches timeline events from Firestore for analytics
//

import Foundation

#if canImport(FirebaseFirestore)
    import FirebaseFirestore
    import FirebaseFirestoreSwift
#endif

final class EmployeeProgressService {
    static let shared = EmployeeProgressService()
    private let firestore = Firestore.firestore()

    private init() {}

    func fetchTimeline(
        for employeeId: String,
        completion: @escaping (Result<[EmployeeTimelineEvent], Error>) -> Void
    ) {
        firestore.collection("employeeTimeline")
            .whereField("employeeId", isEqualTo: employeeId)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                let events =
                    snapshot?.documents.compactMap {
                        try? $0.data(as: EmployeeTimelineEvent.self)
                    } ?? []

                completion(.success(events))
            }
    }
}
