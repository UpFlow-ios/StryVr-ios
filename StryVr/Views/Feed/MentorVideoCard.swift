//
//  MentorVideoCardView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//  🎥 Reusable Mentor Video UI Card – Scalable, Themed, Accessible
//

import SwiftUI
import AVKit

struct MentorVideoCardView: View {
    let video: VideoPostModel
    @State private var player: AVPlayer?

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            
            // MARK: - Video Player
            if let url = URL(string: video.videoURL) {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(height: 220)
                    .cornerRadius(Theme.CornerRadius.medium)
                    .shadow(radius: 4)
                    .accessibilityLabel("Mentor video for \(video.title)")
                    .accessibilityHint("Double-tap to play the video.")
            } else {
                Color.gray
                    .frame(height: 220)
                    .overlay(Text("Invalid Video URL").foregroundColor(.white))
                    .cornerRadius(Theme.CornerRadius.medium)
                    .accessibilityLabel("Invalid video placeholder")
            }

            // MARK: - Title + Info
            VStack(alignment: .leading, spacing: 4) {
                Text(video.title)
                    .font(.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .lineLimit(2)
                    .accessibilityLabel("Video title: \(video.title)")

                if let caption = video.caption, !caption.isEmpty {
                    Text(caption)
                        .font(.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .lineLimit(3)
                        .accessibilityLabel("Video caption: \(caption)")
                }

                HStack {
                    Text(video.category.displayName)
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.accent)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background(Theme.Colors.accent.opacity(0.1))
                        .cornerRadius(8)
                        .accessibilityLabel("Category: \(video.category.displayName)")

                    Spacer()

                    Text("\(video.duration) sec")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .accessibilityLabel("Video duration: \(video.duration) seconds")
                }
            }
            .padding(.horizontal, 4)
        }
        .padding()
        .background(Theme.Colors.card)
        .cornerRadius(Theme.CornerRadius.large)
        .shadow(color: Theme.Colors.textSecondary.opacity(0.1), radius: 3, x: 0, y: 2)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    MentorVideoCardView(video: VideoPostModel.mock)
}
