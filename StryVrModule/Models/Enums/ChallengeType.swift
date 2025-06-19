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

    /// Provides a mock challenge type for preview/testing
    static var mock: ChallengeType {
        .solo
    }

    /// Returns an SF Symbol name representing the challenge type
    var iconName: String {
        switch self {
        case .solo: return "person.fill"
        case .group: return "person.3.fill"
        case .timed: return "clock.fill"
        case .open: return "square.and.pencil"
        case .peerReview: return "person.crop.circle.badge.checkmark"
        }
    }

    /// Returns a color token for UI usage
    var colorCode: String {
        switch self {
        case .solo: return "blue"
        case .group: return "green"
        case .timed: return "orange"
        case .open: return "indigo"
        case .peerReview: return "purple"
        }
    }
}
