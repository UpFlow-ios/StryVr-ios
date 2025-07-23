//
//  SkillMatrixService.swift
//  StryVr
//
//  Created by Joe Dormond on 5/6/25.
//  🧠 Skill Matrix Service – Fetches team skill matrix data for analytics
//

import Foundation

final class SkillMatrixService {
    static let shared = SkillMatrixService()

    private init() {}

    func fetchMatrix(completion: @escaping (Result<[SkillMatrixEntry], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1.0) {
            completion(.success(SkillMatrixService.mockMatrixData))
        }
    }

    static let mockMatrixData: [SkillMatrixEntry] = [
        SkillMatrixEntry(
            id: "1",
            skillName: "SwiftUI",
            rating: 0.85,
            category: .technical,
            reviewerID: nil,
            lastUpdated: Date(),
            level: 4
        ),
        SkillMatrixEntry(
            id: "2",
            skillName: "Communication",
            rating: 0.72,
            category: .softSkill,
            reviewerID: nil,
            lastUpdated: Date(),
            level: 3
        ),
        SkillMatrixEntry(
            id: "3",
            skillName: "Project Management",
            rating: 0.68,
            category: .leadership,
            reviewerID: nil,
            lastUpdated: Date(),
            level: 3
        ),
        SkillMatrixEntry(
            id: "4",
            skillName: "Problem Solving",
            rating: 0.91,
            category: .technical,
            reviewerID: nil,
            lastUpdated: Date(),
            level: 5
        ),
        SkillMatrixEntry(
            id: "5",
            skillName: "Team Collaboration",
            rating: 0.79,
            category: .softSkill,
            reviewerID: nil,
            lastUpdated: Date(),
            level: 4
        ),
    ]
}
