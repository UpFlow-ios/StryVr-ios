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

    // MARK: - Preview

    static let preview = BehaviorFeedback(
        employeeId: "employee123",
        reviewerId: "reviewer456",
        category: .communication,
        rating: 4,
        comment: "Excellent communication skills.",
        isAnonymous: true
    )
}
