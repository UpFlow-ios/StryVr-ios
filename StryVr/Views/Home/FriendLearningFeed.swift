//
//  FriendLearningFeed.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import SwiftUI
import FirebaseFirestore
import os.log

/// Displays a real-time social feed showing what friends are learning
struct FriendLearningFeed: View {
    @State private var feedItems: [LearningFeedItem] = []
    @State private var isError: Bool = false
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "FriendLearningFeed")

    var body: some View {
        NavigationView {
            ZStack {
                if isError {
                    Text("Failed to load feed. Please try again later.")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                        .accessibilityLabel("Error: Failed to load feed")
                } else if feedItems.isEmpty {
                    Text("No activity to display.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                        .accessibilityLabel("No activity to display")
                } else {
                    List(feedItems) { item in
                        HStack {
                            AsyncImage(url: URL(string: item.friendProfileImage)) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Circle().fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .accessibilityLabel("Profile image of \(item.friendName)")

                            VStack(alignment: .leading) {
                                Text("\(item.friendName) is learning \(item.skillName)")
                                    .font(.headline)
                                    .accessibilityLabel("\(item.friendName) is learning \(item.skillName)")
                                Text(item.timestamp, style: .time)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .accessibilityLabel("Timestamp: \(item.timestamp.formatted())")
                            }

                            Spacer()

                            Button(action: {
                                logger.info("Engaged with \(item.skillName)")
                            }) {
                                Image(systemName: "hand.thumbsup.fill")
                                    .foregroundColor(.blue)
                                    .accessibilityLabel("Like \(item.skillName)")
                            }
                        }
                        .transition(.opacity) // Smooth fade animation
                    }
                }
            }
            .navigationTitle("Friend Learning Feed")
            .onAppear {
                fetchLearningFeed()
            }
        }
    }

    /// Fetches real-time updates of what friends are learning
    private func fetchLearningFeed() {
        let userID = "currentUserID"
        Firestore.firestore().collection("friendLearningFeed")
            .whereField("followers", arrayContains: userID)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        logger.error("Error fetching feed: \(error.localizedDescription)")
                        isError = true
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        isError = true
                        return
                    }

                    withAnimation {
                        self.feedItems = documents.compactMap { doc -> LearningFeedItem? in
                            try? doc.data(as: LearningFeedItem.self)
                        }
                    }
                }
            }
    }
}

/// Represents a learning feed item
struct LearningFeedItem: Identifiable, Codable {
    let id: String
    let friendID: String
    let friendName: String
    let friendProfileImage: String
    let skillName: String
    let timestamp: Date
}
