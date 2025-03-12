//
//  VideoContentService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import FirebaseStorage
import FirebaseFirestore
import AVKit
import os.log

/// Handles AI-powered video uploads, tagging, auto-captioning, and recommendations
final class VideoContentService {

    static let shared = VideoContentService()
    private let storageRef = Storage.storage().reference()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "VideoContentService")

    private init() {}

    /// Uploads a video to Firebase Storage and generates AI-powered captions
    /// - Parameters:
    ///   - videoURL: The local URL of the video to be uploaded.
    ///   - title: The title of the video.
    ///   - description: The description of the video.
    ///   - tags: An array of tags associated with the video.
    ///   - completion: A closure that returns a result containing either the video URL or an error.
    func uploadVideo(_ videoURL: URL, title: String, description: String, tags: [String], completion: @escaping (Result<String, Error>) -> Void) {
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

                    // Generate AI captions & store video details
                    self.generateAutoCaptions(for: videoID) { captions in
                        self.saveVideoData(videoID: videoID, title: title, description: description, url: url.absoluteString, tags: tags, captions: captions)
                    }

                    completion(.success(url.absoluteString))
                }
            }
        }
    }

    /// Generates AI-powered captions for a given video
    /// - Parameters:
    ///   - videoID: The ID of the video.
    ///   - completion: A closure that returns the generated captions.
    private func generateAutoCaptions(for videoID: String, completion: @escaping (String) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {  // Simulating AI processing delay
            let generatedCaptions = "AI-generated captions for video \(videoID)..."  // Placeholder for AI-generated text
            completion(generatedCaptions)
        }
    }

    /// Saves video metadata, tags, and captions in Firestore
    /// - Parameters:
    ///   - videoID: The ID of the video.
    ///   - title: The title of the video.
    ///   - description: The description of the video.
    ///   - url: The URL of the video.
    ///   - tags: An array of tags associated with the video.
    ///   - captions: The AI-generated captions for the video.
    private func saveVideoData(videoID: String, title: String, description: String, url: String, tags: [String], captions: String) {
        let videoData: [String: Any] = [
            "id": videoID,
            "title": title,
            "description": description,
            "videoURL": url,
            "tags": tags,
            "captions": captions,
            "uploadDate": Date(),
            "engagement": ["likes": 0, "views": 0]
        ]

        db.collection("videos").document(videoID).setData(videoData) { error in
            if let error = error {
                self.logger.error("Error saving video data: \(error.localizedDescription)")
            } else {
                self.logger.info("Video metadata saved successfully!")
            }
        }
    }

    /// Fetches AI-powered recommended videos for a user
    /// - Parameters:
    ///   - userID: The ID of the user for whom to fetch recommendations.
    ///   - completion: A closure that returns an array of recommended videos.
    func fetchRecommendedVideos(for userID: String, completion: @escaping ([VideoPostModel]) -> Void) {
        db.collection("videos")
            .order(by: "engagement.views", descending: true)
            .limit(to: 5)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
