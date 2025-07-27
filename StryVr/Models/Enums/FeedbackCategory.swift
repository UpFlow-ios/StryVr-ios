//
//  FeedbackCategory.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25.
//  🏷️ Shared Feedback Category Enum – Used across both StryVr and StryVrModule
//

import Foundation

/// Categories for employee behavior feedback
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
