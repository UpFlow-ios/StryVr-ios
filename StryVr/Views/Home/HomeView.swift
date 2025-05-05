//
//  HomeView.swift
//  StryVr
//
//  🏡 Upgraded Home Dashboard – Daily Goals, Streaks, Challenges, Achievements, Mentor Discovery
//

import SwiftUI
import os.log

struct HomeView: View {
    @State private var dailyGoalCompleted = false
    @State private var currentStreak = 5
    @State private var bestStreak = 12
    @State private var activeChallengesCount = 3
    @State private var recentAchievementsCount = 2

    @State private var recommendedMentors: [MentorModel] = []
    @State private var isLoadingMentors: Bool = false

    private let recommendationService: AIRecommendationService
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "HomeView")

    init(recommendationService: AIRecommendationService = .shared) {
        self.recommendationService = recommendationService
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {

                    // MARK: - Greeting
                    Text("Welcome back to StryVr! 👋")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .padding(.top, Theme.Spacing.large)

                    // MARK: - Today's Goal Card
                    dashboardCard(title: "Today's Goal", subtitle: dailyGoalCompleted ? "✅ Completed" : "🎯 Complete 1 Learning Module", buttonAction: markGoalCompleted)

                    // MARK: - Skill Streak Card
                    dashboardCard(title: "Skill Streak", subtitle: "\(currentStreak) Days 🔥 | Best: \(bestStreak) Days 🏆")

                    // MARK: - Active Challenges Card
                    dashboardCard(title: "Active Challenges", subtitle: "\(activeChallengesCount) Challenges in Progress 🎯")

                    // MARK: - Recent Achievements Card
                    dashboardCard(title: "Recent Achievements", subtitle: "\(recentAchievementsCount) Badges Unlocked 🏅")
                        }
                    }
                    .padding(.top, Theme.Spacing.large)

                    Spacer()
                }
                .padding()
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .onAppear(perform: fetchMentorRecommendations)
        }
    }

    // MARK: - Dashboard Card Component
    private func dashboardCard(title: String, subtitle: String, buttonAction: (() -> Void)? = nil) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            HStack {
                Text(title)
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textPrimary)
                Spacer()

                if let action = buttonAction {
                    Button(action: {
                        withAnimation { action() }
                    }) {
                        Image(systemName: dailyGoalCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(dailyGoalCompleted ? .green : Theme.Colors.accent)
                            .font(.title2)
                    }
                }
            }

            Text(subtitle)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Theme.Colors.card)
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Theme.Colors.accent.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    // MARK: - Handle Daily Goal Completion
    private func markGoalCompleted() {
        dailyGoalCompleted = true
      }
    // MARK: - Fetch Mentor Recommendations
}

#Preview {
    HomeView()
}
