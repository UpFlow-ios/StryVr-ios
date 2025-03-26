//
//  MentorReport.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25.
//

import Foundation

struct MentorReport: Identifiable, Codable {
    let id: String
    let mentorId: String
    let menteeFeedback: [String]
    let rating: Double
    let sessionCount: Int
    let summary: String
    let reportDate: Date
}
