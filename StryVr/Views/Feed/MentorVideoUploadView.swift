//
//  MentorVideoUploadView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/1/25.
//

import SwiftUI
import UniformTypeIdentifiers
import AVFoundation

/// Upload screen for mentors to post educational videos
struct MentorVideoUploadView: View {
    @State private var videoURL: URL?
    @State private var title: String = ""
    @State private var caption: String = ""
    @State private var category: VideoCategory = .mentorship
    @State private var isUploading: Bool = false
    @State private var uploadSuccess: Bool = false
    @State private var errorMessage: String?

    @State private var isPickerPresented = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Video File")) {
                    if let url = videoURL {
                        Text(url.lastPathComponent)
                            .font(.callout)
                            .lineLimit(1)
                            .accessibilityLabel("Selected video: \(url.lastPathComponent)")
                    } else {
                        Text("No video selected")
                            .foregroundColor(.secondary)
                            .accessibilityLabel("No video selected")
                    }

                    Button("Choose Video") {
                        isPickerPresented.toggle()
                    }
                    .accessibilityLabel("Choose Video")
                }

                Section(header: Text("Metadata")) {
                    TextField("Title", text: $title)
                        .accessibilityLabel("Video Title")
                    TextField("Caption (optional)", text: $caption)
                        .accessibilityLabel("Video Caption")

                    Picker("Category", selection: $category) {
                        ForEach(VideoCategory.allCases, id: \.self) { category in
                            Text(category.rawValue)
                        }
                    }
                    .accessibilityLabel("Video Category")
                }

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .accessibilityLabel("Error: \(error)")
                }

                if isUploading {
                    ProgressView("Uploading...")
                        .padding()
                        .accessibilityLabel("Uploading...")
                } else {
                    Button("Upload Video") {
                        upload()
                    }
                    .disabled(videoURL == nil || title.isEmpty)
                    .accessibilityLabel("Upload Video")
                }
            }
            .navigationTitle("Upload Mentor Video")
            .sheet(isPresented: $isPickerPresented) {
                DocumentPicker(videoURL: $videoURL)
            }
        }
    }

    // MARK: - Upload Logic

    private func upload() {
        guard let videoURL = videoURL else {
            errorMessage = "Please select a video to upload."
            return
        }

        isUploading = true
        errorMessage = nil

        // Estimate duration
        let duration = Int(CMTimeGetSeconds(AVAsset(url: videoURL).duration))

        VideoContentService.shared.uploadVideo(
            fileURL: videoURL,
            uploaderID: "mentor-id-placeholder", // 🔐 Replace with Auth ID later
            title: title,
            caption: caption,
            thumbnailURL: nil,
            duration: duration,
            category: category,
            isFeatured: false
        ) { downloadURL in
            DispatchQueue.main.async {
                self.isUploading = false

                if let _ = downloadURL {
                    self.uploadSuccess = true
                    self.clearForm()
                } else {
                    self.errorMessage = "Failed to upload video. Please try again."
                }
            }
        }
    }

    // MARK: - Clear Form After Upload

    private func clearForm() {
        self.videoURL = nil
        self.title = ""
        self.caption = ""
        self.category = .mentorship
    }
}
