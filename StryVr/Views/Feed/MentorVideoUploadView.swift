//
//  MentorVideoUploadView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/1/25.
//  📹 Mentor Video Upload Screen – AI-Powered & Scalable UI
//

import SwiftUI
import UniformTypeIdentifiers
import AVFoundation

/// Upload screen for mentors to post AI-tagged educational videos
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
        NavigationStack {
            Form {
                // MARK: - Video File Section
                Section(header: Text("Video File")) {
                    if let url = videoURL {
                        Text(url.lastPathComponent)
                            .font(.caption)
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
                    .accessibilityLabel("Choose Video Button")
                }

                // MARK: - Metadata Section
                Section(header: Text("Metadata")) {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.sentences)
                        .accessibilityLabel("Video Title Input")

                    TextField("Caption (optional)", text: $caption)
                        .textInputAutocapitalization(.sentences)
                        .accessibilityLabel("Video Caption Input")

                    Picker("Category", selection: $category) {
                        ForEach(VideoCategory.allCases, id: \.self) { category in
                            Text(category.displayName)
                        }
                    }
                    .accessibilityLabel("Video Category Picker")
                }

                // MARK: - Error Message
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .accessibilityLabel("Error Message: \(error)")
                }

                // MARK: - Upload Button or Loader
                if isUploading {
                    ProgressView("Uploading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                        .padding(Theme.Spacing.medium)
                } else {
                    Button("Upload Video") {
                        upload()
                    }
                    .disabled(videoURL == nil || title.trimmingCharacters(in: .whitespaces).isEmpty)
                    .accessibilityLabel("Upload Video Button")
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

        let duration = Int(CMTimeGetSeconds(AVAsset(url: videoURL).duration))

        VideoContentService.shared.uploadVideo(
            fileURL: videoURL,
            uploaderID: "mentor-id-placeholder", // 🔐 Replace with AuthViewModel.shared.userSession?.uid
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

    // MARK: - Form Reset After Upload
    private func clearForm() {
        videoURL = nil
        title = ""
        caption = ""
        category = .mentorship
    }
}

#Preview {
    MentorVideoUploadView()
}
