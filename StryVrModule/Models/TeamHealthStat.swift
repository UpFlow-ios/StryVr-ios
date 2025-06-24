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
    let productivityScore: Double // 0–100
    let wellnessScore: Double // 0–100
    let checkInMood: String // "😊", "😐", "😞"
    let lastActiveDate: Date

    var isRecentlyActive: Bool {
        Calendar.current.isDateInToday(lastActiveDate)
    }

    static let preview = TeamHealthStat(
        id: UUID().uuidString,
        employeeName: "Taylor Evans",
        productivityScore: 88.0,
        wellnessScore: 91.0,
        checkInMood: "😊",
        lastActiveDate: Date()
    )
}
