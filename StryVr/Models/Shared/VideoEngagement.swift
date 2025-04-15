//
//  VideoEngagement.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//

import Foundation

/// Tracks engagement metrics for a video post
struct VideoEngagement: Codable, Hashable {
    /// Number of likes on the video
    var likes: Int
    /// Number of comments on the video
    var comments: Int
    /// Number of shares of the video
    var shares: Int
    /// Number of views of the video
    var views: Int

    /// Calculates the engagement score based on weighted metrics
    var engagementScore: Int {
        (likes * 2) + (comments * 3) + (shares * 5) + views
    }

    /// Ensures all engagement metrics are non-negative
    var isValid: Bool {
        likes >= 0 && comments >= 0 && shares >= 0 && views >= 0
    }

    /// Resets all engagement metrics to zero
    mutating func resetMetrics() {
        likes = 0
        comments = 0
        shares = 0
        views = 0
    }

    /// Initializes a new `VideoEngagement` instance
    init(likes: Int = 0, comments: Int = 0, shares: Int = 0, views: Int = 0) {
        self.likes = likes
        self.comments = comments
        self.shares = shares
        self.views = views
    }
}
