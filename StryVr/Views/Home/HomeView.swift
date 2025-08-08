//
//  HomeView.swift
//  StryVr
//
//  🏠 Main Home Screen with AI Greeting & Quick Actions
//  🌟 iOS 18 Liquid Glass + Apple Glow UI Implementation
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
    @Namespace private var glassNamespace

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

                        // MARK: - Collaboration Spaces Card (Revolutionary Feature)

                        collaborationSpacesCard()

                        // MARK: - Gamification Progress Card (XP & Level System)

                        gamificationProgressCard()

                        // MARK: - Cross-Departmental Bridge Card (Revolutionary Gap Analysis)

                        crossDepartmentalBridgeCard()

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
                            .orange,
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
                if #available(iOS 18.0, *) {
                    Circle()
                        .glassEffect(
                            .regular.tint(Theme.Colors.neonGreen.opacity(0.3)), in: Circle()
                        )
                        .frame(width: 60, height: 60)
                        .glassEffectID("goal-checkmark", in: glassNamespace)
                } else {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 60, height: 60)
                }

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
                    if #available(iOS 18.0, *) {
                        Circle()
                            .glassEffect(
                                .regular.tint(Theme.Colors.neonBlue.opacity(0.3)), in: Circle()
                            )
                            .frame(width: 30, height: 30)
                            .glassEffectID("goal-indicator", in: glassNamespace)
                    } else {
                        Circle()
                            .fill(Theme.Colors.neonBlue)
                            .frame(width: 30, height: 30)
                    }

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
        .applyLiquidGlassCard()
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
        .applyLiquidGlassCard()
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
        .applyLiquidGlassCard()
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
        .applyLiquidGlassCard()
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
                .applyInteractiveLiquidGlassCard()
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

        // Award XP for completing goal
        GamificationService.shared.awardXP(for: .completeGoal, context: "Daily goal completed")
    }

    // MARK: - Collaboration Spaces Card (Revolutionary Feature)

    private func collaborationSpacesCard() -> some View {
        NavigationLink(destination: CollaborationSpacesListView()) {
            HStack(spacing: Theme.Spacing.large) {
                // Left side: Content
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text("Team Spaces")
                        .font(Theme.Typography.body)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text("Bridge gaps • Share skills")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                // Right side: Bridge icon with glow
                Image(systemName: "arrow.triangle.merge")
                    .font(.title)
                    .foregroundColor(Theme.Colors.neonBlue)
                    .neonGlow(color: Theme.Colors.glowPrimary, pulse: true)
            }
            .padding(Theme.Spacing.large)
            .applyLiquidGlassCard()
            .liquidGlassGlow(color: Theme.Colors.glowPrimary, radius: 10, intensity: 0.8)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Gamification Progress Card

    private func gamificationProgressCard() -> some View {
        NavigationLink(destination: GamificationDashboardView()) {
            HStack(spacing: Theme.Spacing.large) {
                // Left side: Level and XP info
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .foregroundColor(Theme.Colors.neonYellow)
                            .font(.title3)
                            .neonGlow(color: Theme.Colors.neonYellow, pulse: true)

                        Text("Level 8 • Rising Star")
                            .font(Theme.Typography.body)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }

                    Text("1,247 XP • 203 XP to next level")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                // Right side: Progress circle and streak
                VStack(spacing: 8) {
                    // XP Progress Circle
                    ZStack {
                        Circle()
                            .stroke(Theme.Colors.glassPrimary, lineWidth: 6)
                            .frame(width: 40, height: 40)

                        Circle()
                            .trim(from: 0, to: 0.73)  // 73% progress to next level
                            .stroke(
                                LinearGradient(
                                    colors: [Theme.Colors.neonYellow, Theme.Colors.neonOrange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .frame(width: 40, height: 40)
                            .rotationEffect(.degrees(-90))

                        Text("73%")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }

                    // Streak indicator
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(Theme.Colors.neonOrange)
                            .font(.caption2)

                        Text("3 day")
                            .font(.caption2)
                            .foregroundColor(Theme.Colors.neonOrange)
                            .fontWeight(.semibold)
                    }
                }

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Theme.Colors.textTertiary)
            }
            .padding(Theme.Spacing.large)
            .applyLiquidGlassCard()
            .liquidGlassGlow(color: Theme.Colors.neonYellow, radius: 10, intensity: 0.8)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Cross-Departmental Bridge Card (Revolutionary Gap Analysis)
    private func crossDepartmentalBridgeCard() -> some View {
        NavigationLink(destination: CrossDepartmentalBridgeDashboard()) {
            HStack(spacing: Theme.Spacing.large) {
                // Left side: Content
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    HStack(spacing: 8) {
                        Image(systemName: "building.2.crop.circle.badge.checkmark")
                            .foregroundColor(Theme.Colors.neonPurple)
                            .font(.title3)
                            .neonGlow(color: Theme.Colors.neonPurple, pulse: true)

                        Text("Bridge Gaps")
                            .font(Theme.Typography.body)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }

                    Text("Connect departments • Break silos")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                // Right side: Gap metrics and bridge icon
                VStack(spacing: 4) {
                    // Gap count indicator
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(Theme.Colors.neonOrange)
                            .font(.caption2)

                        Text("3 gaps")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.Colors.neonOrange)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Theme.Colors.neonOrange.opacity(0.2), in: Capsule())

                    // Success rate
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Theme.Colors.neonGreen)
                            .font(.caption2)

                        Text("85% success")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.Colors.neonGreen)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Theme.Colors.neonGreen.opacity(0.2), in: Capsule())
                }

                Image(systemName: "building.2.crop.circle.badge.checkmark")
                    .font(.title)
                    .foregroundColor(Theme.Colors.neonPurple)
                    .neonGlow(color: Theme.Colors.glowPrimary, pulse: true)
            }
            .padding(Theme.Spacing.large)
            .applyLiquidGlassCard()
            .liquidGlassGlow(color: Theme.Colors.neonPurple, radius: 10, intensity: 0.8)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Badge Unlock

    private func unlockBadge() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            recentAchievementsCount += 1
        }
        ConfettiManager.shared.triggerConfetti()
        aiGreetingManager.updateContext(userAction: "badge_unlocked")

        // Award XP for unlocking badge
        GamificationService.shared.awardXP(for: .shareAchievement, context: "Badge unlocked")
    }
}

// MARK: - iOS 18 Liquid Glass Helper Extensions

extension View {
    /// Apply iOS 18 Liquid Glass card with fallback
    func applyLiquidGlassCard() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(
                .regular, in: RoundedRectangle(cornerRadius: Theme.CornerRadius.card))
        } else {
            return self.liquidGlassCard()
        }
    }

    /// Apply iOS 18 Interactive Liquid Glass card with fallback
    func applyInteractiveLiquidGlassCard() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(
                .regular.interactive(), in: RoundedRectangle(cornerRadius: Theme.CornerRadius.card))
        } else {
            return self.liquidGlassCard()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel.previewMock)
}
