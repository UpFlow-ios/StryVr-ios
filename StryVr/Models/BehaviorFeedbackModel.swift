//
//  BehaviorFeedbackModel.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25.
//  🧠 Behavior Feedback Model – Structured insights into employee behavior
//

import Foundation

struct BehaviorFeedback: Identifiable, Codable {
    let id: String
    let employeeId: String
    let reviewerId: String?
    let category: FeedbackCategory
    let rating: Int
    let comment: String?
    let timestamp: Date
    let isAnonymous: Bool

    init(
        id: String = UUID().uuidString,
        employeeId: String,
        reviewerId: String? = nil,
        category: FeedbackCategory,
        rating: Int,
        comment: String? = nil,
        timestamp: Date = Date(),
        isAnonymous: Bool = false
    ) {
        self.id = id
        self.employeeId = employeeId
        self.reviewerId = reviewerId
        self.category = category
        self.rating = rating
        self.comment = comment
        self.timestamp = timestamp
        self.isAnonymous = isAnonymous
    }
}

enum FeedbackCategory: String, Codable, CaseIterable, Identifiable {
    case communication
    case teamwork
    case punctuality
    case attitude
    case professionalism

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .communication: return "Communication"
        case .teamwork: return "Teamwork"
        case .punctuality: return "Punctuality"
        case .attitude: return "Attitude"
        case .professionalism: return "Professionalism"
        }
    }
}

