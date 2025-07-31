//
//  FriendLearningFeed.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//  🧠 Real-Time Friend Skill Feed with Liquid Glass UI
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
        ZStack {
            // MARK: - Dark Gradient Background
            
            Theme.LiquidGlass.background
                .ignoresSafeArea()

            if isLoading {
                loadingView()
            } else if isError {
                errorView()
            } else if feedItems.isEmpty {
                emptyStateView()
            } else {
                feedContentView()
            }
        }
        .navigationBarHidden(true)
        .onAppear(perform: fetchLearningFeed)
    }
    
    // MARK: - Loading View
    
    private func loadingView() -> some View {
        VStack(spacing: Theme.Spacing.large) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.neonBlue))
                .scaleEffect(1.5)
            
            Text("Loading feed...")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .accessibilityLabel("Loading friend learning feed")
    }
    
    // MARK: - Error View
    
    private func errorView() -> some View {
        VStack(spacing: Theme.Spacing.large) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(Theme.Colors.neonOrange)
                .neonGlow(color: Theme.Colors.glowOrange, pulse: true)
            
            Text("Failed to load feed")
                .font(Theme.Typography.headline)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Text("Please try again later")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                fetchLearningFeed()
            }
            .font(Theme.Typography.buttonText)
            .fontWeight(.semibold)
            .foregroundColor(Theme.Colors.textPrimary)
            .padding(Theme.Spacing.large)
            .liquidGlassCard()
            .liquidGlassGlow(color: Theme.Colors.glowPrimary, radius: 10, intensity: 0.8)
        }
        .padding(Theme.Spacing.large)
        .accessibilityLabel("Error loading learning feed")
    }
    
    // MARK: - Empty State View
    
    private func emptyStateView() -> some View {
        VStack(spacing: Theme.Spacing.large) {
            Image(systemName: "person.3.fill")
                .font(.largeTitle)
                .foregroundColor(Theme.Colors.textSecondary)
            
            Text("No recent activity")
                .font(Theme.Typography.headline)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Text("No recent activity from your network")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(Theme.Spacing.large)
        .accessibilityLabel("No activity to display")
    }
    
    // MARK: - Feed Content View
    
    private func feedContentView() -> some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.large) {
                // Header
                headerSection()
                
                // Feed Items
                LazyVStack(spacing: Theme.Spacing.medium) {
                    ForEach(feedItems) { item in
                        feedItemCard(item: item)
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, Theme.Spacing.large)
            .padding(.top, Theme.Spacing.large)
        }
    }
    
    // MARK: - Header Section
    
    private func headerSection() -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Learning Feed")
                .font(Theme.Typography.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Text("See what your network is learning")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, Theme.Spacing.medium)
    }
    
    // MARK: - Feed Item Card
    
    private func feedItemCard(item: LearningFeedItem) -> some View {
        HStack(spacing: Theme.Spacing.medium) {
            // Profile Image
            AsyncImage(url: URL(string: item.friendProfileImage)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Circle()
                    .fill(Theme.Colors.glassSecondary)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Theme.Colors.glassPrimary, lineWidth: 1)
            )
            .accessibilityLabel("\(item.friendName)'s profile image")

            // Content
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text("\(item.friendName) is learning \(item.skillName)")
                    .font(Theme.Typography.body)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(item.timestamp, style: .time)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Spacer()

            // Like Button
            Button {
                logger.info("👍 Liked \(item.skillName)")
            } label: {
                Image(systemName: "hand.thumbsup.fill")
                    .font(.title3)
                    .foregroundColor(Theme.Colors.neonBlue)
                    .neonGlow(color: Theme.Colors.glowPrimary, pulse: false)
                    .accessibilityLabel("Like \(item.skillName)")
            }
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowSecondary, radius: 10, intensity: 0.6)
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
