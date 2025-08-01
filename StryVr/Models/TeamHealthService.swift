//
//  TeamHealthService.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25.
//  🛠️ Team Health Service – Fetches employee wellness & performance stats
//

import Foundation

final class TeamHealthService {
    static let shared = TeamHealthService()

    func fetchTeamHealthStats(completion: @escaping (Result<[TeamHealthStat], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1.0) {
            completion(.success(TeamHealthService.mockData))
        }
    }

    func fetchWeeklyStats(completion: @escaping (Result<[TeamHealthStat], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1.0) {
            completion(.success(TeamHealthService.mockData))
        }
    }

    static let mockData: [TeamHealthStat] = [
        TeamHealthStat(
            id: "1",
            employeeName: "Elena Maxwell",
            productivityScore: 89.5,
            wellnessScore: 94.0,
            checkInMood: "😊",
            lastActiveDate: Date(),
            week: "Week 1",
            overallHealthScore: 91.75,
            categories: [
                HealthCategory(name: "Productivity", score: 89.5),
                HealthCategory(name: "Wellness", score: 94.0),
                HealthCategory(name: "Collaboration", score: 92.0)
            ]),
        TeamHealthStat(
            id: "2",
            employeeName: "Marcus Li",
            productivityScore: 72.0,
            wellnessScore: 68.0,
            checkInMood: "😐",
            lastActiveDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            week: "Week 1",
            overallHealthScore: 70.0,
            categories: [
                HealthCategory(name: "Productivity", score: 72.0),
                HealthCategory(name: "Wellness", score: 68.0),
                HealthCategory(name: "Collaboration", score: 70.0)
            ]),
        TeamHealthStat(
            id: "3",
            employeeName: "Kara Smith",
            productivityScore: 58.0,
            wellnessScore: 50.0,
            checkInMood: "😞",
            lastActiveDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            week: "Week 1",
            overallHealthScore: 54.0,
            categories: [
                HealthCategory(name: "Productivity", score: 58.0),
                HealthCategory(name: "Wellness", score: 50.0),
                HealthCategory(name: "Collaboration", score: 54.0)
            ])
    ]
}
