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

/// Manages mentor video uploads, metadata, streaming & AI tagging
final class VideoContentService {

    static let shared = VideoContentService()
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "VideoContentService")

    private init() {}

    // MARK: - Upload Video

    func uploadVideo(
        fileURL: URL,
        uploaderID: String,
        title: String,
        caption: String?,
        thumbnailURL: String? = nil,
        duration: Int,
        category: VideoCategory,
        isFeatured: Bool = false,
        completion: @escaping (String?) -> Void
    ) {
        let videoID = UUID().uuidString
        let videoRef = storage.child("videos/\(uploaderID)/\(videoID).mp4")

        videoRef.putFile(from: fileURL, metadata: nil) { _, error in
            if let error = error {
                self.logger.error("Upload failed: \(error.localizedDescription)")
                completion(nil)
                return
            }

            videoRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    self.logger.error("Download URL failed: \(error?.localizedDescription ?? "Unknown")")
                    completion(nil)
                    return
                }

                self.generateAITags(for: downloadURL.absoluteString) { tags in
                    let metadata: [String: Any] = [
                        "id": videoID,
                        "uploaderID": uploaderID,
                        "title": title,
                        "caption": caption ?? "",
                        "videoURL": downloadURL.absoluteString,
                        "thumbnailURL": thumbnailURL ?? "",
                        "duration": duration,
                        "category": category.rawValue,
                        "uploadDate": Timestamp(date: Date()),
                        "isFeatured": isFeatured,
                        "likes": 0,
                        "comments": 0,
                        "shares": 0,
                        "views": 0,
                        "tags": tags
                    ]

                    self.db.collection("mentorVideos").document(videoID).setData(metadata) { error in
                        if let error = error {
                            self.logger.error("Metadata write failed: \(error.localizedDescription)")
                        } else {
                            self.logger.info("Video metadata saved successfully.")
                        }
                        completion(downloadURL.absoluteString)
                    }
                }
            }
        }
    }

    // MARK: - Fetch Videos (Streaming)

    func fetchMentorVideos(completion: @escaping ([VideoPostModel]) -> Void) {
        db.collection("mentorVideos")
            .order(by: "uploadDate", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    self.logger.error("Fetch failed: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let videos: [VideoPostModel] = snapshot?.documents.compactMap { doc in
                    let data = doc.data()

                    guard
                        let uploaderID = data["uploaderID"] as? String,
                        let title = data["title"] as? String,
                        let videoURL = data["videoURL"] as? String,
                        let duration = data["duration"] as? Int,
                        let categoryRaw = data["category"] as? String,
                        let uploadDate = (data["uploadDate"] as? Timestamp)?.dateValue()
                    else { return nil }

                    let caption = data["caption"] as? String
                    let thumbnailURL = data["thumbnailURL"] as? String
                    let isFeatured = data["isFeatured"] as? Bool ?? false

                    let engagement = VideoEngagement(
                        likes: data["likes"] as? Int ?? 0,
                        comments: data["comments"] as? Int ?? 0,
                        shares: data["shares"] as? Int ?? 0,
                        views: data["views"] as? Int ?? 0
                    )

                    let category = VideoCategory(rawValue: categoryRaw) ?? .other

                    return VideoPostModel(
                        id: doc.documentID,
                        uploaderID: uploaderID,
                        title: title,
                        caption: caption,
                        videoURL: videoURL,
                        thumbnailURL: thumbnailURL,
                        duration: duration,
                        category: category,
                        uploadDate: uploadDate,
                        engagement: engagement,
                        isFeatured: isFeatured
                    )
                } ?? []

                completion(videos)
            }
    }

    // MARK: - AI Content Tagging Stub

    private func generateAITags(for videoURL: String, completion: @escaping ([String]) -> Void) {
        // 🔁 Replace this with Hugging Face API or custom endpoint later
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            completion(["career", "mentorship", "skills"])
        }
    }
}
