//
//  VideoPostModel.swift
//  StryVr
//
//  Created by Joe Dormond on 3/11/25.
//
import Foundation

/// Represents a video post within the StryVr platform
struct VideoPostModel: Identifiable, Codable {
    let id: String  // Unique video ID
    let uploaderID: String  // User or mentor who uploaded the video
    var title: String  // Video title
    var description: String?  // Video description
    var videoURL: String  // Cloud storage URL of the video
    var thumbnailURL: String?  // Thumbnail image for the video
    var duration: Int  // Video duration in seconds
    var category: VideoCategory  // Category of the video content
    var uploadDate: Date  // Timestamp of when the video was uploaded
    var engagement: VideoEngagement  // Engagement metrics
    var isFeatured: Bool = false  // Whether the video is featured in the StryVr feed

    /// Computed property to format upload date
    var formattedUploadDate: String {
        return VideoPostModel.dateFormatter.string(from: uploadDate)
    }

    /// Static date formatter to avoid creating a new instance every time
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

/// Enum for classifying video content
enum VideoCategory: String, Codable {
    /// Video related to mentorship
    case mentorship = "Mentorship"
    /// Video tutorial for skills
    case skillTutorial = "Skill Tutorial"
    /// Video providing industry insights
    case industryInsights = "Industry Insights"
    /// Video showcasing success stories
    case successStory = "Success Story"
    /// Video showcasing projects
    case projectShowcase = "Project Showcase"
    /// Other types of videos
    case other = "Other"
}

/// Represents engagement metrics for a video post
struct VideoEngagement: Codable {
    var likes: Int = 0
    var comments: Int = 0
    var shares: Int = 0
    var views: Int = 0

    /// Computed property to calculate engagement score
    var engagementScore: Int {
        return (likes * 2) + (comments * 3) + (shares * 5) + views
    }
}
