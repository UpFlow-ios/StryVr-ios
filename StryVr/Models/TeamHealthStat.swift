//
//  TeamHealthStat.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25.
//  📊 Team Health Model – Represents employee wellness, productivity, and sentiment
//

import Foundation

struct TeamHealthStat: Identifiable, Codable {
    let id: String
    let employeeName: String
    let productivityScore: Double  // 0–100
    let wellnessScore: Double  // 0–100
    let checkInMood: String  // "😊", "😐", "😞"
    let lastActiveDate: Date
    let week: String  // Week identifier
    let overallHealthScore: Double  // 0–100
    let categories: [HealthCategory]  // Health categories

    var isRecentlyActive: Bool {
        Calendar.current.isDateInToday(lastActiveDate)
    }

    static let preview = TeamHealthStat(
        id: UUID().uuidString,
        employeeName: "Taylor Evans",
        productivityScore: 88.0,
        wellnessScore: 91.0,
        checkInMood: "😊",
        lastActiveDate: Date(),
        week: "Week 1",
        overallHealthScore: 89.5,
        categories: [
            HealthCategory(name: "Productivity", score: 88.0),
            HealthCategory(name: "Wellness", score: 91.0),
            HealthCategory(name: "Collaboration", score: 85.0)
        ]
    )
}

struct HealthCategory: Identifiable, Codable {
    let id = UUID()
    let name: String
    let score: Double  // 0–100
}
