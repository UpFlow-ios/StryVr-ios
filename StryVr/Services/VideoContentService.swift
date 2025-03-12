//
//  VideoContentService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import FirebaseStorage
import AVKit
import os.log

/// Handles video uploads, playback, and AI-powered recommendations
final class VideoContentService {

    static let shared = VideoContentService()
    private let storageRef = Storage.storage().reference()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "VideoContentService")

    private init() {}

    /// Uploads a video to Firebase Storage
    /// - Parameters:
    ///   - videoURL: The local URL of the video to be uploaded.
    ///   - completion: A closure that returns a result containing either the video URL or an error.
    func uploadVideo(_ videoURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        let videoID = UUID().uuidString
        let videoRef = storageRef.child("videos/\(videoID).mp4")

        videoRef.putFile(from: videoURL, metadata: nil) { _, error in
            if let error = error {
                self.logger.error("Video Upload Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            videoRef.downloadURL { url, error in
                if let error = error {
                    self.logger.error("Error getting video URL: \(error.localizedDescription)")
                    completion(.failure(error))
                } else if let url = url {
                    self.logger.info("Video uploaded successfully: \(url.absoluteString)")
                    completion(.success(url.absoluteString))
                }
            }
        }
    }

    /// Fetches AI-recommended videos based on user preferences
    /// - Parameters:
    ///   - userID: The ID of the user for whom to fetch recommendations.
    ///   - completion: A closure that returns an array of recommended videos.
    func fetchRecommendedVideos(for userID: String, completion: @escaping ([VideoPostModel]) -> Void) {
        let sampleVideos = [
            VideoPostModel(id: "1", uploaderID: "mentor123", title: "SwiftUI Basics", videoURL: "https://example.com/video1.mp4", duration: 300, category: .skillTutorial, uploadDate: Date(), engagement: VideoEngagement(likes: 100, comments: 20, shares: 15, views: 500)),
            VideoPostModel(id: "2", uploaderID: "mentor456", title: "iOS Development Tips", videoURL: "https://example.com/video2.mp4", duration: 420, category: .industryInsights, uploadDate: Date(), engagement: VideoEngagement(likes: 250, comments: 40, shares: 30, views: 1200))
        ]

        completion(sampleVideos)
    }

    /// Plays a video using AVPlayer
    /// - Parameter url: The URL of the video to be played.
    /// - Returns: An AVPlayer instance configured to play the video.
    func playVideo(from url: String) -> AVPlayer {
        let player = AVPlayer(url: URL(string: url)!)
        return player
    }
}
