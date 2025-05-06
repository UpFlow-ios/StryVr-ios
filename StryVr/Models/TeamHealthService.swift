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

    // Placeholder for backend integration
    func fetchTeamHealthStats(completion: @escaping (Result<[TeamHealthStat], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1.0) {
            let mockStats: [TeamHealthStat] = [
                TeamHealthStat(id: "1", employeeName: "Elena Maxwell", productivityScore: 89.5, wellnessScore: 94.0, checkInMood: "😊", lastActiveDate: Date()),
                TeamHealthStat(id: "2", employeeName: "Marcus Li", productivityScore: 72.0, wellnessScore: 68.0, checkInMood: "😐", lastActiveDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
                TeamHealthStat(id: "3", employeeName: "Kara Smith", productivityScore: 58.0, wellnessScore: 50.0, checkInMood: "😞", lastActiveDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)
            ]
            completion(.success(mockStats))
        }
    }
}

