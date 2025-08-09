//
//  SkillService.swift
//  StryVr
//
//  Created by Joe Dormond on 6/5/25.
//  🔌 Skill Service Implementation – Backend service for skill management
//

import Combine
import Foundation
import OSLog

/// Implementation of SkillServiceProtocol for skill management
final class SkillService: SkillServiceProtocol, @unchecked Sendable {
    static let shared = SkillService()

    // MARK: - Concurrency Safety
    @MainActor
    static func getShared() -> SkillService {
        return shared
    }

    private let logger = Logger(subsystem: "com.stryvr.app", category: "SkillService")

    private init() {}

    // MARK: - Protocol Implementation

    func fetchSkills(
        for userID: String, completion: @escaping (Result<[SkillMatrixEntry], Error>) -> Void
    ) {
        // Placeholder implementation - would fetch from Firestore
        let mockSkills = [
            SkillMatrixEntry(
                id: "1",
                skillName: "SwiftUI",
                rating: 0.8,
                category: .technical,
                reviewerID: nil,
                lastUpdated: Date(),
                level: 4
            ),
            SkillMatrixEntry(
                id: "2",
                skillName: "Communication",
                rating: 0.7,
                category: .softSkill,
                reviewerID: nil,
                lastUpdated: Date(),
                level: 3
            ),
            SkillMatrixEntry(
                id: "3",
                skillName: "Project Management",
                rating: 0.6,
                category: .leadership,
                reviewerID: nil,
                lastUpdated: Date(),
                level: 3
            )
        ]

        DispatchQueue.main.async {
            completion(.success(mockSkills))
        }
    }

    func updateSkillRating(
        userID: String,
        skillID: String,
        newRating: Double,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Placeholder implementation
        DispatchQueue.main.async {
            completion(.success(()))
        }
    }

    func addSkill(
        userID: String, skill: SkillMatrixEntry, completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Placeholder implementation
        DispatchQueue.main.async {
            completion(.success(()))
        }
    }

    func deleteSkill(
        userID: String, skillID: String, completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Placeholder implementation
        DispatchQueue.main.async {
            completion(.success(()))
        }
    }

    // MARK: - Combine-based API for HomeViewModel

    func fetchSkills() -> AnyPublisher<[Skill], Error> {
        // Convert the protocol method to Combine publisher
        return Future<[Skill], Error> { promise in
            self.fetchSkills(for: "currentUser") { result in
                switch result {
                case .success(let entries):
                    let skills = entries.map { entry in
                        Skill(
                            id: entry.id,
                            name: entry.skillName,
                            proficiencyLevel: entry.rating,
                            lastPracticed: entry.lastUpdated
                        )
                    }
                    promise(.success(skills))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
