//
//  MentorVideoCard.swift
//  StryVr
//
//  Created by Joe Dormond on 4/1/25.
//

import SwiftUI
import AVKit

struct MentorVideoFeedView: View {
    @State private var videoPosts: [VideoPostModel] = []
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(videoPosts) { video in
                        MentorVideoCard(video: video)
                            .padding(.horizontal)
                    }

                    if isLoading {
                        ProgressView()
                            .padding()
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Mentor Feed")
            .onAppear {
                if videoPosts.isEmpty {
                    loadVideos()
                }
            }
        }
    }

    // MARK: - Data Fetching
    private func loadVideos() {
        isLoading = true
        VideoContentService.shared.fetchMentorVideos { videos in
            DispatchQueue.main.async {
                self.videoPosts = videos
                self.isLoading = false
            }
        }
    }
}
