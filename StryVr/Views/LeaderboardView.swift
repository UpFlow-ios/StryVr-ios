//
//  LeaderboardView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//  🏆 Displays top learners (Gamification + Recognition)
//

import FirebaseFirestore
import OSLog
import SwiftUI

struct LeaderboardView: View {
    @State private var topLearners: [LeaderboardUser] = []
    @State private var isLoading: Bool = true
    @State private var hasError: Bool = false

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "StryVr", category: "LeaderboardView"
    )

    // MARK: - Debug-only initializer for previews
    #if DEBUG
        init(mockTopLearners: [LeaderboardUser]) {
            self._topLearners = State(initialValue: mockTopLearners)
            self._isLoading = State(initialValue: false)
            self._hasError = State(initialValue: false)
        }
    #endif

    var body: some View {
        NavigationView {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                if isLoading {
                    ProgressView("Loading Leaderboard...")
                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                        .accessibilityLabel("Loading leaderboard")
                } else if hasError {
                    VStack(spacing: Theme.Spacing.medium) {
                        Text("⚠️ Failed to load leaderboard data.")
                            .foregroundColor(.red)
                            .font(.headline)
                            .accessibilityLabel("Failed to load leaderboard data")

                        Button("Retry") {
                            fetchLeaderboardData()
                        }
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.accent)
                        .accessibilityLabel("Retry button")
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                            Text("🏆 Leaderboard")
                                .font(Theme.Typography.headline)
                                .foregroundColor(Theme.Colors.textPrimary)

                            StryVrCardView(title: "🔥 Top Learners") {
                                ForEach(topLearners) { user in
                                    LeaderboardRow(user: user)
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.medium)
                        }
                    }
                }
            }
            .navigationTitle("Leaderboard")
            .onAppear {
                fetchLeaderboardData()
            }
        }
    }

    // MARK: - Firestore Data Fetch
    private func fetchLeaderboardData() {
        isLoading = true
        hasError = false

        let group = DispatchGroup()
        group.enter()

        fetchData(collection: "users", orderBy: "skillProgress", limit: 5) { result in
            switch result {
            case .success(let users):
                self.topLearners = users
            case .failure(let error):
                logger.error("❌ Failed to cast scene to UIWindowScene")
                self.hasError = true
            }
            group.leave()
        }

        group.notify(queue: .main) {
            self.isLoading = false
        }
    }

    private func fetchData(
        collection: String,
        orderBy: String,
        limit: Int,
        completion: @escaping (Result<[LeaderboardUser], Error>) -> Void
    ) {
        Firestore.firestore()
            .collection(collection)
            .order(by: orderBy, descending: true)
            .limit(to: limit)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: nil)))
                    return
                }

                let users = documents.compactMap { doc in
                    try? doc.data(as: LeaderboardUser.self)
                }
                completion(.success(users))
            }
    }
}

struct LeaderboardRow: View {
    let user: LeaderboardUser
    var isTopUser: Bool { user.rank == 1 }
    var body: some View {
        HStack(spacing: 12) {
            if isTopUser {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
                    .animateSymbol(true, type: .bounce)
                    .shadow(color: .yellow.opacity(0.5), radius: 8)
            }
            user.profileImage
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle().stroke(Theme.Colors.accent, lineWidth: isTopUser ? 3 : 1))
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                Text("Points: \(user.totalPoints)")
                    .font(.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            Spacer()
            Text("#\(user.rank)")
                .font(.title3.bold())
                .foregroundColor(isTopUser ? .yellow : Theme.Colors.textSecondary)
        }
        .padding(.vertical, 8)
        .background(isTopUser ? Theme.Colors.glassAccent.opacity(0.2) : Color.clear)
        .cornerRadius(12)
    }
}

// MARK: - Preview
#if DEBUG
    struct LeaderboardView_Previews: PreviewProvider {
        static var previews: some View {
            LeaderboardView(mockTopLearners: LeaderboardUser.mockLeaderboardUsers)
        }
    }
#endif
