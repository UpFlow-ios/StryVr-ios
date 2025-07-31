//
//  FriendLearningFeed.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//  🧠 Real-Time Friend Skill Feed – Firebase-Powered Social Learning UI
//

import FirebaseFirestore
import OSLog
import SwiftUI

/// Displays a real-time social feed showing what friends are learning
struct FriendLearningFeed: View {
    @State private var feedItems: [LearningFeedItem] = []
    @State private var isError: Bool = false
    @State private var isLoading: Bool = true
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "FriendLearningFeed")

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                if isLoading {
                    ProgressView("Loading feed...")
                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                        .accessibilityLabel("Loading friend learning feed")
                } else if isError {
                    VStack {
                        Text("⚠️ Failed to load feed. Please try again later.")
                            .font(Theme.Typography.body)
                            .foregroundColor(.red)
                            .padding()
                            .accessibilityLabel("Error loading learning feed")

                        Button("Retry") {
                            fetchLearningFeed()
                        }
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.accent)
                        .padding()
                        .accessibilityLabel("Retry loading feed")
                    }
                } else if feedItems.isEmpty {
                    Text("No recent activity from your network.")
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .padding()
                        .accessibilityLabel("No activity to display")
                } else {
                    List(feedItems) { item in
                        HStack(spacing: Theme.Spacing.medium) {
                            AsyncImage(url: URL(string: item.friendProfileImage)) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Circle().fill(Color.gray.opacity(0.2))
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .accessibilityLabel("\(item.friendName)'s profile image")

                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(item.friendName) is learning \(item.skillName)")
                                    .font(Theme.Typography.body)
                                    .foregroundColor(Theme.Colors.textPrimary)

                                Text(item.timestamp, style: .time)
                                    .font(Theme.Typography.caption)
                                    .foregroundColor(Theme.Colors.textSecondary)
                            }

                            Spacer()

                            Button {
                                logger.info("👍 Liked \(item.skillName)")
                            } label: {
                                Image(systemName: "hand.thumbsup.fill")
                                    .foregroundColor(Theme.Colors.accent)
                                    .accessibilityLabel("Like \(item.skillName)")
                            }
                        }
                        .padding(.vertical, Theme.Spacing.small)
                        .transition(.opacity)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Friend Learning Feed")
            .onAppear(perform: fetchLearningFeed)
        }
    }

    /// Fetches real-time updates of what friends are learning from Firestore
    private func fetchLearningFeed() {
        isLoading = true
        isError = false
        let userID = "currentUserID"  // 🔐 Replace with AuthManager.userID
        Firestore.firestore().collection("friendLearningFeed")
            .whereField("followers", arrayContains: userID)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    isLoading = false
                    if let error = error {
                        logger.error("❌ Error fetching feed: \(error.localizedDescription)")
                        isError = true
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        isError = true
                        return
                    }

                    withAnimation {
                        self.feedItems = documents.compactMap { doc in
                            try? doc.data(as: LearningFeedItem.self)
                        }
                    }
                }
            }
    }
}

// MARK: - LearningFeedItem Model

struct LearningFeedItem: Identifiable, Codable {
    let id: String
    let friendID: String
    let friendName: String
    let friendProfileImage: String
    let skillName: String
    let timestamp: Date
}

#Preview {
    FriendLearningFeed()
}
