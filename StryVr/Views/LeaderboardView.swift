//
//  LeaderboardView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import SwiftUI
import FirebaseFirestore
import os.log

/// Displays top learners and mentors in StryVr
struct LeaderboardView: View {
    @State private var topLearners: [LeaderboardUser] = []
    @State private var topMentors: [LeaderboardUser] = []
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LeaderboardView")

    var body: some View {
        NavigationView {
            VStack {
                Text("🏆 Leaderboard")
                    .font(.largeTitle)
                    .bold()

                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    Text("🔥 Top Learners")
                        .font(.headline)

                    ForEach(topLearners, id: \.id) { user in
                        LeaderboardRow(user: user)
                    }

                    Divider()

                    Text("🎓 Top Mentors")
                        .font(.headline)

                    ForEach(topMentors, id: \.id) { user in
                        LeaderboardRow(user: user)
                    }
                }
                .padding()
            }
            .onAppear {
                fetchTopLearners()
                fetchTopMentors()
            }
            .navigationBarHidden(true)
        }
    }

    /// Fetches top learners from Firestore
    private func fetchTopLearners() {
        Firestore.firestore().collection("users")
            .order(by: "skillProgress", descending: true)
            .limit(to: 5)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    logger.error("Error fetching top learners: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.topLearners = documents.compactMap { doc -> LeaderboardUser? in
                }
            }
    }

                    try? doc.data(as: LeaderboardUser.self)
    /// Fetches top mentors from Firestore
    private func fetchTopMentors() {
        Firestore.firestore().collection("mentors")
            .order(by: "rating", descending: true)
            .limit(to: 5)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    logger.error("Error fetching top mentors: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.topMentors = documents.compactMap { doc -> LeaderboardUser? in
                    try? doc.data(as: LeaderboardUser.self)
                }
            }
    }
}

/// Represents a user or mentor on the leaderboard
struct LeaderboardUser: Identifiable, Codable {
    let id: String
    let name: String
    let profileImageURL: String
    let score: Int  // Skill progress or mentor rating
}

/// Row for leaderboard ranking
struct LeaderboardRow: View {
    var user: LeaderboardUser

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.profileImageURL)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Circle().fill(Color.gray.opacity(0.3))
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
