//
//  ConferenceCallModel.swift
//  StryVr
//
//  Created by Joe Dormond on 3/11/25.
//
import Foundation

/// Represents a scheduled conference call within the StryVr platform
struct ConferenceCallModel: Identifiable, Codable {
    let id: String  // Unique conference call ID
    let hostID: String  // ID of the mentor or organizer hosting the call
    var title: String  // Title or topic of the call
    var description: String?  // Optional description of the session
    var participants: [String]  // List of user IDs participating in the call
    var scheduledDate: Date  // Date and time of the scheduled call
    var durationMinutes: Int  // Expected duration of the call
    var callStatus: CallStatus  // Status of the call (upcoming, live, completed)
    var recordingURL: String?  // Optional URL to a recorded session
    var engagementMetrics: CallEngagement  // Engagement data for analytics

    /// Computed property to format scheduled date
    var formattedScheduledDate: String {
        return ConferenceCallModel.dateFormatter.string(from: scheduledDate)
    }

    /// Static date formatter to avoid creating a new instance every time
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

/// Enum for defining the status of a conference call
enum CallStatus: String, Codable {
    /// Call is upcoming
    case upcoming = "Upcoming"
    /// Call is live
    case live = "Live"
    /// Call is completed
    case completed = "Completed"
    /// Call is canceled
    case canceled = "Canceled"
}

/// Represents engagement metrics for a conference call
struct CallEngagement: Codable {
    var totalAttendees: Int = 0
    var messagesSent: Int = 0
    var reactions: Int = 0

    /// Computed property to calculate engagement score
    var engagementScore: Int {
        return (totalAttendees * 5) + (messagesSent * 2) + (reactions * 3)
    }
}
