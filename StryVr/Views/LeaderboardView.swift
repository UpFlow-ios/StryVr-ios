//
//  LeaderboardView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//  🏆 Displays top learners & mentors (Gamification + Recognition)
//

import SwiftUI
import FirebaseFirestore
import os.log

struct LeaderboardView: View {
    @State private var topLearners: [LeaderboardUser] = []
    @State private var topMentors: [LeaderboardUser] = []
    @State private var isLoading: Bool = true
    @State private var hasError: Bool = false

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LeaderboardView")

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

                            StryVrCardView(title: "🎓 Top Mentors") {
                                ForEach(topMentors) { user in
                                    LeaderboardRow(user: user)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Leaderboard")
            .onAppear {
                fetchLeaderboardData()
            }
        }
    }

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

        group.enter()
        fetchData(collection: "mentors", orderBy: "rating", limit: 5) { result in
            switch result {
            case .success(let mentors):
                self.topMentors = mentors
            case .failure(let error):
                logger.error("Error fetching top mentors: \(error.localizedDescription)")
                self.hasError = true
            }
            group.leave()
        }

        group.notify(queue: .main) {
            self.isLoading = false
        }
    }

    private func fetchData(collection: String, orderBy: String, limit: Int, completion: @escaping (Result<[LeaderboardUser], Error>) -> Void) {
        Firestore.firestore().collection(collection)
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
