//
//  VideoContentService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import FirebaseStorage
import FirebaseFirestore
import os.log

/// Manages video uploads, real-time streaming, and AI-powered content tagging
final class VideoContentService {
    
    static let shared = VideoContentService()
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "VideoContentService")
    
    private init() {}

    /// Uploads a video file to Firebase Storage
    func uploadVideo(fileURL: URL, userID: String, completion: @escaping (String?) -> Void) {
        let videoID = UUID().uuidString
        let videoRef = storage.child("videos/\(userID)/\(videoID).mp4")

        videoRef.putFile(from: fileURL, metadata: nil) { _, error in
            if let error = error {
                self.logger.error("Error uploading video: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            videoRef.downloadURL { url, error in
                guard let downloadURL = url, error == nil else {
                    self.logger.error("Error retrieving download URL: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                
                self.saveVideoMetadata(videoID: videoID, userID: userID, url: downloadURL.absoluteString)
                completion(downloadURL.absoluteString)
            }
        }
    }

    /// Saves video metadata in Firestore
    private func saveVideoMetadata(videoID: String, userID: String, url: String) {
        generateAITags(for: url) { tags in
            let videoData: [String: Any] = [
                "videoID": videoID,
                "userID": userID,
                "url": url,
                "timestamp": Timestamp(date: Date()),
                "tags": tags
            ]

            self.db.collection("videos").document(videoID).setData(videoData) { error in
                if let error = error {
                    self.logger.error("Error saving video metadata: \(error.localizedDescription)")
                } else {
                    self.logger.info("Video metadata saved successfully")
                }
            }
        }
    }

    /// Fetches video data for real-time streaming
    func fetchVideoList(completion: @escaping ([VideoModel]) -> Void) {
        db.collection("videos").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                self.logger.error("Error fetching video list: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }

            let videos = documents.compactMap { doc -> VideoModel? in
                try? doc.data(as: VideoModel.self)
            }
            completion(videos)
        }
    }

    /// Generates AI-powered tags based on video content
    private func generateAITags(for videoURL: String, completion: @escaping ([String]) -> Void) {
        // Placeholder AI logic - In real implementation, use an AI model for tagging
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            completion(["mentorship", "learning", "career growth"])
        }
    }
}

/// Represents a video object for streaming
struct VideoModel: Identifiable, Codable {
    let id: String
    let userID: String
    let url: String
    let timestamp: Date
    let tags: [String]
}
