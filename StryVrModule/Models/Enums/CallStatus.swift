//
//  CallStatus.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//

import Foundation

/// Defines the status of a video conference session
enum CallStatus: String, Codable, CaseIterable {
    /// The session is scheduled but not yet started
    case upcoming = "Upcoming"
    /// The session is currently live
    case live = "Live"
    /// The session has been completed
    case completed = "Completed"
    /// The session has been canceled
    case canceled = "Canceled"

    /// Returns a user-friendly description of the status
    var description: String {
        switch self {
        case .upcoming: return "The session is scheduled and will start soon."
        case .live: return "The session is currently in progress."
        case .completed: return "The session has ended."
        case .canceled: return "The session was canceled."
        }
    }

    /// Validates if a given string matches a valid status
    static func isValidStatus(_ status: String) -> Bool {
        return CallStatus(rawValue: status) != nil
    }

    /// Provides a mock value for SwiftUI previews or testing
    static var mock: CallStatus {
        .live
    }

    /// Returns an associated color code name (for UI themes)
    var colorCode: String {
        switch self {
        case .upcoming: return "gray"
        case .live: return "red"
        case .completed: return "green"
        case .canceled: return "secondary"
        }
    }

    /// Returns an SF Symbol name based on status
    var iconName: String {
        switch self {
        case .upcoming: return "clock"
        case .live: return "dot.radiowaves.left.and.right"
        case .completed: return "checkmark.circle"
        case .canceled: return "xmark.circle"
        }
    }
}
