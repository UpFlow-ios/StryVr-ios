//
//  ChallengeType.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//

import Foundation

/// Types of challenges inside StryVr
enum ChallengeType: String, Codable, CaseIterable {
    /// A solo challenge
    case solo = "Solo"
    /// A group-based challenge
    case group = "Group"
    /// A time-limited challenge
    case timed = "Timed"
    /// An open-ended challenge
    case open = "Open"
    /// A challenge that involves peer review
    case peerReview = "Peer Review"

    /// Returns a user-friendly description of the challenge type
    var description: String {
        switch self {
        case .solo: return "A challenge designed for individual participants."
        case .group: return "A challenge designed for group collaboration."
        case .timed: return "A challenge with a strict time limit."
        case .open: return "An open-ended challenge with no specific constraints."
        case .peerReview: return "A challenge that involves peer evaluation."
        }
    }

    /// Validates if a given string matches a valid challenge type
    static func isValidType(_ type: String) -> Bool {
        return ChallengeType(rawValue: type) != nil
    }
}
