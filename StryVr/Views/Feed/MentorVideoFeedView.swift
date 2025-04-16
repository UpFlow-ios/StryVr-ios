//
//  MentorVideoFeedView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/1/25.
//  🎥 Mentor Video Feed – AI-Powered, Scroll-Optimized, Fully Themed
//

import SwiftUI
import AVKit

struct MentorVideoFeedView: View {
    @State private var videoPosts: [VideoPostModel] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: Theme.Spacing.large) {
                    
                    // Feed Cards
                    if !videoPosts.isEmpty {
                        ForEach(videoPosts) { video in
                            MentorVideoCard(video: video)
                                .padding(.horizontal, Theme.Spacing.medium)
                        }
                    } else if !isLoading && errorMessage == nil {
                        Text("No mentor videos found. Check back soon or follow new mentors.")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                            .accessibilityLabel("No mentor videos available.")
                    }

                    // Loading Indicator
                    if isLoading {
                        ProgressView("Loading mentor videos...")
                            .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                            .padding()
                    }

                    // Error Message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                            .accessibilityLabel("Error: \(errorMessage)")
                    }
                }
                .padding(.vertical, Theme.Spacing.large)
            }
            .background(Theme.Colors.background)
            .navigationTitle("Mentor Feed")
            .onAppear(perform: loadVideos)
        }
    }

    // MARK: - Load AI Mentor Videos
    private func loadVideos() {
        isLoading = true
        errorMessage = nil

        VideoContentService.shared.fetchMentorVideos { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let videos):
                    self.videoPosts = videos
                    if videos.isEmpty {
                        self.errorMessage = "No mentor videos found. Check back soon or follow new mentors."
                    }
                case .failure:
                    self.errorMessage = "Failed to load videos. Please check your connection and try again."
                }
            }
        }
    }
}

#Preview {
    MentorVideoFeedView()
}
