//
//  HomeView.swift
//  StryVr
//
//  🏡 Clean Home Dashboard – Daily Goals, Streaks, Challenges, Achievements with Confetti Celebrations
//

import ConfettiSwiftUI
import os.log
import SwiftUI

struct HomeView: View {
    @State private var dailyGoalCompleted = false
    @State private var currentStreak = 5
    @State private var bestStreak = 12
    @State private var activeChallengesCount = 3
    @State private var recentAchievementsCount = 2

    @StateObject private var confettiManager = ConfettiManager.shared
    @EnvironmentObject var authViewModel: AuthViewModel

    @Environment(\.isDebug) var isDebug
    @State private var showDevPanel = false

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "HomeView")

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                ScrollView {
                    VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                        // MARK: - Greeting

                        Text("Welcome back to StryVr! 👋")
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .padding(.top, Theme.Spacing.large)

                        // MARK: - Today's Goal Card

                        dashboardCard(
                            title: "Today's Goal",
                            subtitle: dailyGoalCompleted ? "✅ Completed" : "🎯 Complete 1 Learning Module",
                            buttonAction: markGoalCompleted
                        )

                        // MARK: - Skill Streak Card

                        dashboardCard(title: "Skill Streak", subtitle: "\(currentStreak) Days 🔥 | Best: \(bestStreak) Days 🏆")

                        // MARK: - Active Challenges Card

                        dashboardCard(title: "Active Challenges", subtitle: "\(activeChallengesCount) Challenges in Progress 🎯")

                        // MARK: - Recent Achievements Card

                        dashboardCard(title: "Recent Achievements", subtitle: "\(recentAchievementsCount) Badges Unlocked 🏅")

                        // MARK: - Manual Badge Unlock (Demo Button)

                        Button(action: unlockBadge) {
                            Text("🏅 Unlock New Badge")
                                .font(Theme.Typography.body)
                                .foregroundColor(Theme.Colors.whiteText)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Theme.Colors.accent)
                                .cornerRadius(Theme.CornerRadius.medium)
                        }

                        // MARK: - Log Out Button

                        Button(action: {
                            authViewModel.signOut()
                        }) {
                            Text("Log Out")
                                .font(Theme.Typography.buttonText)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(Theme.CornerRadius.medium)
                        }
                        .padding(.top, Theme.Spacing.large)

                        Spacer()
                    }
                    .padding()
                    .confettiCannon(
                        counter: $confettiManager.counter,
                        num: 30,
                        colors: [.green, .blue, .purple, .pink, .orange],
                        radius: 350,
                        repetitions: 1,
                        repetitionInterval: 0.2
                    )
                }

                // MARK: - Hidden Long-Press Dev Trigger (Debug Only)

                if isDebug {
                    Color.clear
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                        .onLongPressGesture(minimumDuration: 2.0) {
                            showDevPanel = true
                        }
                        .position(x: 40, y: 40)
                }
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showDevPanel) {
            DevDebugView()
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
        ConfettiManager.shared.triggerConfetti()
    }

    // MARK: - Badge Unlock

    private func unlockBadge() {
        recentAchievementsCount += 1
        ConfettiManager.shared.triggerConfetti()
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel.shared)
}
