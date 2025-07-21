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

enum FeedbackCategory: String, Codable, CaseIterable, Identifiable {
    case attitude
    case communication
    case professionalism
    case punctuality
    case teamwork
    case clarity
    case collaboration
    case responsiveness

    var id: String { rawValue }

    static var displayNameMap: [FeedbackCategory: String] = [
        .attitude: "Attitude",
        .communication: "Communication",
        .professionalism: "Professionalism",
        .punctuality: "Punctuality",
        .teamwork: "Teamwork",
        .clarity: "Clarity",
        .collaboration: "Collaboration",
        .responsiveness: "Responsiveness",
    ]

    var displayName: String {
        return FeedbackCategory.displayNameMap[self] ?? rawValue.capitalized
    }
}
