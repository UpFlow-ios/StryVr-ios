//
//  CallEngagement.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//

import Foundation

/// Tracks engagement metrics during a StryVr conference call
struct CallEngagement: Codable, Hashable {
    var totalAttendees: Int // Total number of attendees
    var messagesSent: Int // Total number of messages sent
    var reactions: Int // Total number of reactions

    // MARK: - Computed Properties

    /// Computes a raw engagement score used in analytics
    var engagementScore: Int {
        (totalAttendees * 5) + (messagesSent * 2) + (reactions * 3)
    }

    /// Calculates the average reactions per attendee
    var averageReactionsPerAttendee: Double {
        guard totalAttendees > 0 else { return 0.0 }
        return Double(reactions) / Double(totalAttendees)
    }

    // MARK: - Validation

    /// Validates that all engagement metrics are non-negative
    func isValidMetrics() -> Bool {
        return totalAttendees >= 0 && messagesSent >= 0 && reactions >= 0
    }

    // MARK: - Initializer

    init(
        totalAttendees: Int = 0,
        messagesSent: Int = 0,
        reactions: Int = 0
    ) {
        self.totalAttendees = totalAttendees
        self.messagesSent = messagesSent
        self.reactions = reactions
    }

    // MARK: - Preview Sample

    static let preview = CallEngagement(
        totalAttendees: 12,
        messagesSent: 30,
        reactions: 22
    )

    // MARK: - Debug Description

    var description: String {
        "📊 CallEngagement — Attendees: \(totalAttendees), Messages: \(messagesSent), Reactions: \(reactions), Score: \(engagementScore)"
    }
}
