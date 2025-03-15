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
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "FriendLearningFeed")

    var body: some View {
        NavigationView {
            List(feedItems) { item in
                HStack {
                    AsyncImage(url: URL(string: item.friendProfileImage)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Circle().fill(Color.gray.opacity(0.3))
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text("\(item.friendName) is learning \(item.skillName)")
                            .font(.headline)
                        Text(item.timestamp, style: .time)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Button(action: {
                        logger.info("Engaged with \(item.skillName)")
                    }) {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundColor(.blue)
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
                guard let documents = snapshot?.documents, error == nil else {
                    logger.error("Error fetching feed: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.feedItems = documents.compactMap { doc -> LearningFeedItem? in
                    try? doc.data(as: LearningFeedItem.self)
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

