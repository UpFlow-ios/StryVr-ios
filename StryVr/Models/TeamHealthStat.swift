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
    let productivityScore: Double   // 0–100
    let wellnessScore: Double       // 0–100
    let checkInMood: String         // "😊", "😐", "😞"
    let lastActiveDate: Date

    var isRecentlyActive: Bool {
        Calendar.current.isDateInToday(lastActiveDate)
    }
}

