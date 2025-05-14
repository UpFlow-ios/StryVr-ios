//
//  VideoPostModel.swift
//  StryVr
//
//  Created by Joe Dormond on [Date]
//
//  🎥 VideoPost Model – Represents user-generated video content and engagement
//
import Foundation

/// Represents a video post within the StryVr platform
struct VideoPostModel: Identifiable, Codable, Hashable {
    let id: String                      // Unique ID for the video post
    let uploaderID: String              // ID of the uploader
    var title: String                   // Title of the video
    var description: String?            // Optional description of the video
    var videoURL: String                // URL of the video
    var thumbnailURL: String?           // Optional URL of the thumbnail
    var duration: Int                   // Duration of the video in seconds
    var category: VideoCategory         // Category of the video
    var uploadDate: Date                // Date the video was uploaded
    var engagement: VideoEngagement     // Engagement metrics for the video
    var isFeatured: Bool                // Whether the video is featured

    /// Readable formatted date
    var formattedUploadDate: String {
        Self.dateFormatter.string(from: uploadDate)
    }

    /// Checks if the video is long (e.g., > 10 minutes)
    var isLongVideo: Bool {
        duration > 600
    }

    /// Validates that the video URL and thumbnail URL (if provided) are valid
    func isValid() -> Bool {
        guard URL(string: videoURL) != nil else { return false }
        if let thumbnail = thumbnailURL {
            return URL(string: thumbnail) != nil
        }
        return true
    }

    // MARK: - Date Formatter
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(
        id: String,
        uploaderID: String,
        title: String,
        description: String? = nil,
        videoURL: String,
        thumbnailURL: String? = nil,
        duration: Int,
        category: VideoCategory,
        uploadDate: Date = Date(),
        engagement: VideoEngagement = .init(),
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

    static let empty = VideoPostModel(
        id: UUID().uuidString,
        uploaderID: "",
        title: "",
        duration: 0,
        videoURL: "",
        category: .other
    )
}
