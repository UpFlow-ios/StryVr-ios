//
//  LeaderboardView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//  🏆 Displays top learners (Gamification + Recognition)
//

import FirebaseFirestore
import SwiftUI
import os.log

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
                logger.error("Error fetching top learners: \(error.localizedDescription)")
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

// MARK: - Preview
#if DEBUG
struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView(mockTopLearners: LeaderboardUser.mockLeaderboardUsers)
    }
}
#endif
