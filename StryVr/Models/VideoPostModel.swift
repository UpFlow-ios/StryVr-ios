import Foundation

// MARK: - VideoPostModel
/// Represents a video post within the StryVr platform
struct VideoPostModel: Identifiable, Codable {
    let id: String
    let uploaderID: String
    var title: String
    var description: String?
    var videoURL: String
    var thumbnailURL: String?
    var duration: Int
    var category: VideoCategory
    var uploadDate: Date
    var engagement: VideoEngagement
    var isFeatured: Bool

    /// Computed property for formatted upload date
    var formattedUploadDate: String {
        return VideoPostModel.dateFormatter.string(from: uploadDate)
    }

    /// Optimized static date formatter
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    /// Explicit initializer with clear defaults
    init(
        id: String,
        uploaderID: String,
        title: String,
        description: var caption: String?
        videoURL: String,
        thumbnailURL: String? = nil,
        duration: Int,
        category: VideoCategory,
        uploadDate: Date = Date(),
        engagement: VideoEngagement = VideoEngagement(),
        isFeatured: Bool = false
    ) {
        self.id = id
        self.uploaderID = uploaderID
        self.title = title
        self.description = description
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
        self.duration = duration
        self.category = category
        self.uploadDate = uploadDate
        self.engagement = engagement
        self.isFeatured = isFeatured
    }
}

// MARK: - VideoCategory
/// Enum classifying video content
enum VideoCategory: String, Codable {
    case mentorship = "Mentorship"
    case skillTutorial = "Skill Tutorial"
    case industryInsights = "Industry Insights"
    case successStory = "Success Story"
    case projectShowcase = "Project Showcase"
    case other = "Other"
}

// MARK: - VideoEngagement
/// Represents engagement metrics for a video post
struct VideoEngagement: Codable {
    var likes: Int
    var comments: Int
    var shares: Int
    var views: Int

    /// Computed property calculating engagement score
    var engagementScore: Int {
        return (likes * 2) + (comments * 3) + (shares * 5) + views
    }

    /// Explicit initializer clearly defined
    init(likes: Int = 0, comments: Int = 0, shares: Int = 0, views: Int = 0) {
        self.likes = likes
        self.comments = comments
        self.shares = shares
        self.views = views
    }
}
