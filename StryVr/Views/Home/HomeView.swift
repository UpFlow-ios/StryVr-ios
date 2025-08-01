//
//  HomeView.swift
//  StryVr
//
//  🏠 Main Home Screen with AI Greeting & Quick Actions
//  🌟 Liquid Glass + Apple Glow UI Implementation
//

import ConfettiSwiftUI
import Foundation
import OSLog
import SwiftUI

struct HomeView: View {
    @State private var dailyGoalCompleted = false
    @State private var currentStreak = 5
    @State private var bestStreak = 12
    @State private var activeChallengesCount = 3
    @State private var recentAchievementsCount = 2

    @StateObject private var confettiManager = ConfettiManager.shared
    @StateObject private var aiGreetingManager = AIGreetingManager.shared
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var showDevPanel = false

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "HomeView")

    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Dark Gradient Background (from mockup)

                Theme.LiquidGlass.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                        // MARK: - App Title & Greeting

                        appTitleAndGreeting()

                        // MARK: - Today's Goal Card (from mockup)

                        todaysGoalCard()

                        // MARK: - Skill Streak Card (from mockup)

                        skillStreakCard()

                        // MARK: - Active Challenges Card (from mockup)

                        activeChallengesCard()

                        // MARK: - Recent Achievements Card (from mockup)

                        recentAchievementsCard()

                        // MARK: - Unlock New Badge Button (from mockup)

                        unlockNewBadgeButton()

                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.top, Theme.Spacing.large)
                    .confettiCannon(
                        counter: $confettiManager.counter,
                        num: 30,
                        colors: [
                            .green,
                            .blue,
                            .purple,
                            .pink,
                            .orange
                        ],
                        radius: 350,
                        repetitions: 1,
                        repetitionInterval: 0.2
                    )
                }

                // MARK: - Hidden Long-Press Dev Trigger (Debug Only)

                #if DEBUG
                    Color.clear
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                        .onLongPressGesture(minimumDuration: 2.0) {
                            showDevPanel = true
                        }
                        .position(x: 40, y: 40)
                #endif
            }
            .navigationTitle("stryvr")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showDevPanel) {
            DevDebugView()
        }
        .onAppear {
            aiGreetingManager.generateGreeting()
        }
    }

    // MARK: - App Title & Greeting (from mockup)

    private func appTitleAndGreeting() -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("stryvr")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textPrimary)
                .fontWeight(.medium)

            Text(aiGreetingManager.currentGreeting)
                .font(Theme.Typography.largeTitle)
                .foregroundColor(Theme.Colors.textPrimary)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, Theme.Spacing.medium)
    }

    // MARK: - Today's Goal Card (from mockup)

    private func todaysGoalCard() -> some View {
        HStack(spacing: Theme.Spacing.large) {
            // Left side: Green checkmark with glow
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 60, height: 60)
                    .neonGlow(color: Theme.Colors.glowGreen, pulse: dailyGoalCompleted)

                Image(systemName: "checkmark")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }

            // Center: Goal content
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text("Today's Goal")
                    .font(Theme.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(dailyGoalCompleted ? "Completed" : "Complete 1 Learning Module")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.leading)
            }

            Spacer()

            // Right side: Small checkmark indicator
            if dailyGoalCompleted {
                ZStack {
                    Circle()
                        .fill(Theme.Colors.neonBlue)
                        .frame(width: 30, height: 30)
                        .neonGlow(color: Theme.Colors.glowPrimary)

                    Image(systemName: "checkmark")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowGreen, radius: 10, intensity: 0.8)
    }

    // MARK: - Skill Streak Card (from mockup)

    private func skillStreakCard() -> some View {
        HStack(spacing: Theme.Spacing.large) {
            // Left side: Content
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text("Skill Streak")
                    .font(Theme.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text("\(currentStreak) Days")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Spacer()

            // Right side: Blue flame with glow
            Image(systemName: "flame.fill")
                .font(.title)
                .foregroundColor(Theme.Colors.neonBlue)
                .neonGlow(color: Theme.Colors.glowPrimary, pulse: true)
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowPrimary, radius: 10, intensity: 0.8)
    }

    // MARK: - Active Challenges Card (from mockup)

    private func activeChallengesCard() -> some View {
        HStack(spacing: Theme.Spacing.large) {
            // Left side: Content
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text("Active Challenges")
                    .font(Theme.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text("\(activeChallengesCount) in Progress")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Spacer()

            // Right side: Orange target with glow
            Image(systemName: "target")
                .font(.title)
                .foregroundColor(Theme.Colors.neonOrange)
                .neonGlow(color: Theme.Colors.glowOrange, pulse: true)
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowOrange, radius: 10, intensity: 0.8)
    }

    // MARK: - Recent Achievements Card (from mockup)

    private func recentAchievementsCard() -> some View {
        HStack(spacing: Theme.Spacing.large) {
            // Left side: Content
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text("Recent Achievements")
                    .font(Theme.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text("\(recentAchievementsCount) Badges")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Spacer()

            // Right side: Yellow badge with glow
            Image(systemName: "shield.fill")
                .font(.title)
                .foregroundColor(Theme.Colors.neonYellow)
                .neonGlow(color: Theme.Colors.glowYellow, pulse: true)
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowYellow, radius: 10, intensity: 0.8)
    }

    // MARK: - Unlock New Badge Button (from mockup)

    private func unlockNewBadgeButton() -> some View {
        Button(action: unlockBadge) {
            Text("Unlock New Badge")
                .font(Theme.Typography.buttonText)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(Theme.Spacing.large)
                .liquidGlassCard()
                .liquidGlassGlow(color: Theme.Colors.glowAccent, radius: 12, intensity: 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Handle Daily Goal Completion

    private func markGoalCompleted() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            dailyGoalCompleted = true
        }
        ConfettiManager.shared.triggerConfetti()
        aiGreetingManager.updateContext(userAction: "goal_completed")
    }

    // MARK: - Badge Unlock

    private func unlockBadge() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            recentAchievementsCount += 1
        }
        ConfettiManager.shared.triggerConfetti()
        aiGreetingManager.updateContext(userAction: "badge_unlocked")
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel.previewMock)
}
