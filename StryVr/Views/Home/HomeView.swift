//
//  HomeView.swift
//  StryVr
//
//  🏡 Premium Home Dashboard – Liquid Glass UI, AI Greetings, Goals & Achievements
//  🌟 Enhanced with ultraThinMaterial, glow effects, and personalized experience
//

import ConfettiSwiftUI
import OSLog
import SwiftUI
import SymbolAnimator

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

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "HomeView")

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                // MARK: - Liquid Glass Background

                Theme.LiquidGlass.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                        // MARK: - AI Greeting Card

                        liquidGlassGreetingCard()

                        // MARK: - Today's Goal Card

                        liquidGlassGoalCard()

                        // MARK: - Skill Streak Card

                        liquidGlassStreakCard()

                        // MARK: - Active Challenges Card

                        liquidGlassChallengesCard()

                        // MARK: - Recent Achievements Card

                        liquidGlassAchievementsCard()

                        // MARK: - Action Buttons

                        liquidGlassActionButtons()

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
            .background(Theme.LiquidGlass.background.ignoresSafeArea())
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showDevPanel) {
            DevDebugView()
        }
        .onAppear {
            aiGreetingManager.generateGreeting()
        }
    }

    // MARK: - Liquid Glass AI Greeting Card

    private func liquidGlassGreetingCard() -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text(aiGreetingManager.currentGreeting)
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
                .multilineTextAlignment(.leading)

            Text(aiGreetingManager.personalizedGoal)
                .font(Theme.Typography.subheadline)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.leading)

            Text(aiGreetingManager.motivationTip)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.glassAccent)
                .multilineTextAlignment(.leading)
                .padding(.top, Theme.Spacing.small)
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowPrimary)
    }

    // MARK: - Liquid Glass Goal Card

    private func liquidGlassGoalCard() -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            HStack {
                Text("Today's Goal")
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textPrimary)
                Spacer()

                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        markGoalCompleted()
                    }
                }) {
                    Image(systemName: dailyGoalCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(dailyGoalCompleted ? .green : Theme.Colors.glassAccent)
                        .font(.title2)
                        .liquidGlassGlow(
                            color: dailyGoalCompleted ? .green : Theme.Colors.glowAccent
                        )
                        .animateSymbol(dailyGoalCompleted, type: .bounce)
                        .shadow(
                            color: .green.opacity(dailyGoalCompleted ? 0.5 : 0),
                            radius: dailyGoalCompleted ? 10 : 0)
                }
            }

            Text(dailyGoalCompleted ? "✅ Completed" : "🎯 Complete 1 Learning Module")
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.leading)
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowSecondary)
    }

    // MARK: - Liquid Glass Streak Card

    private func liquidGlassStreakCard() -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            Text("Skill Streak")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textPrimary)

            HStack(spacing: 8) {
                Text("\(currentStreak) Days")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.title3)
                    .animateSymbol(true, type: .variableColor)
                    .shadow(color: .orange.opacity(0.5), radius: 8)
                Text("| Best: \(bestStreak) Days 🏆")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowPrimary)
    }

    // MARK: - Liquid Glass Challenges Card

    private func liquidGlassChallengesCard() -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            Text("Active Challenges")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textPrimary)

            Text("\(activeChallengesCount) Challenges in Progress 🎯")
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.leading)
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowSecondary)
    }

    // MARK: - Liquid Glass Achievements Card

    private func liquidGlassAchievementsCard() -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            Text("Recent Achievements")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textPrimary)

            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.title3)
                    .animateSymbol(true, type: .pulse)
                    .shadow(color: .yellow.opacity(0.5), radius: 8)
                Text("\(recentAchievementsCount) Badges Unlocked 🏅")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowAccent)
    }

    // MARK: - Liquid Glass Action Buttons

    private func liquidGlassActionButtons() -> some View {
        VStack(spacing: Theme.Spacing.medium) {
            Button(action: unlockBadge) {
                HStack {
                    Text("🏅 Unlock New Badge")
                        .font(Theme.Typography.buttonText)
                        .foregroundColor(Theme.Colors.whiteText)
                    Spacer()
                    Image(systemName: "sparkles")
                        .foregroundColor(Theme.Colors.whiteText)
                }
                .padding(Theme.Spacing.large)
                .liquidGlassButton()
                .liquidGlassGlow(color: Theme.Colors.glowAccent)
            }

            Button(action: {
                authViewModel.signOut()
            }) {
                HStack {
                    Text("Log Out")
                        .font(Theme.Typography.buttonText)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.white)
                }
                .padding(Theme.Spacing.large)
                .background(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                .stroke(Color.red.opacity(0.6), lineWidth: 1)
                        )
                )
                .liquidGlassGlow(color: Color.red.opacity(0.3))
            }
        }
        .padding(.top, Theme.Spacing.large)
    }

    // MARK: - Handle Daily Goal Completion

    private func markGoalCompleted() {
        dailyGoalCompleted = true
        ConfettiManager.shared.triggerConfetti()
        aiGreetingManager.updateContext(userAction: "goal_completed")
    }

    // MARK: - Badge Unlock

    private func unlockBadge() {
        recentAchievementsCount += 1
        ConfettiManager.shared.triggerConfetti()
        aiGreetingManager.updateContext(userAction: "badge_unlocked")
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel.previewMock)
}
