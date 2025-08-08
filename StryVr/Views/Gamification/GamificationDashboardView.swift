//
//  GamificationDashboardView.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  🎮 Revolutionary Gamification Dashboard - XP, Levels, Streaks & Achievements
//  🏆 Social Competition & Progress Visualization with Liquid Glass Beauty
//

import SwiftUI

struct GamificationDashboardView: View {
    @StateObject private var gamificationService = GamificationService.shared
    @State private var selectedTab: GamificationTab = .overview
    @State private var showingLeaderboard = false
    @State private var showingAchievements = false
    @State private var showingBadges = false
    @Namespace private var gamificationNamespace
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.LiquidGlass.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with user level
                    levelHeaderSection
                    
                    // Tab selection
                    gamificationTabs
                    
                    // Main content
                    ScrollView {
                        VStack(spacing: Theme.Spacing.large) {
                            switch selectedTab {
                            case .overview:
                                overviewContent
                            case .achievements:
                                achievementsContent
                            case .leaderboard:
                                leaderboardContent
                            case .challenges:
                                challengesContent
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        .padding(.top, Theme.Spacing.medium)
                    }
                }
                
                // Floating animations overlay
                animationsOverlay
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("View Badges") { showingBadges = true }
                        Button("Share Progress") { shareProgress() }
                        Button("Settings") { /* Handle settings */ }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(Theme.Colors.neonBlue)
                            .font(.title2)
                    }
                }
            }
        }
        .sheet(isPresented: $showingLeaderboard) {
            LeaderboardDetailView()
        }
        .sheet(isPresented: $showingAchievements) {
            AchievementsDetailView()
        }
        .sheet(isPresented: $showingBadges) {
            BadgesCollectionView()
        }
        .onAppear {
            gamificationService.updateLeaderboardPosition()
        }
    }
    
    // MARK: - Level Header Section
    private var levelHeaderSection: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Level \(gamificationService.userLevel.level)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text(gamificationService.userLevel.title)
                        .font(.subheadline)
                        .foregroundColor(Theme.Colors.neonBlue)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                // XP Circle
                ZStack {
                    Circle()
                        .stroke(Theme.Colors.glassPrimary, lineWidth: 12)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: gamificationService.userLevel.progressToNext)
                        .stroke(
                            LinearGradient(
                                colors: [Theme.Colors.neonBlue, Theme.Colors.neonGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(), value: gamificationService.userLevel.progressToNext)
                    
                    VStack(spacing: 2) {
                        Text("\(gamificationService.currentXP)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        Text("XP")
                            .font(.caption2)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }
            }
            
            // Progress bar to next level
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Progress to Level \(gamificationService.userLevel.level + 1)")
                        .font(.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                    
                    Spacer()
                    
                    Text("\(gamificationService.userLevel.xpToNext - (gamificationService.currentXP % gamificationService.userLevel.xpToNext)) XP to go")
                        .font(.caption)
                        .foregroundColor(Theme.Colors.textTertiary)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Theme.Colors.glassPrimary)
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [Theme.Colors.neonBlue, Theme.Colors.neonGreen],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * gamificationService.userLevel.progressToNext, height: 8)
                            .animation(.spring(), value: gamificationService.userLevel.progressToNext)
                    }
                }
                .frame(height: 8)
            }
        }
        .padding()
        .liquidGlassCard()
        .padding(.horizontal, Theme.Spacing.large)
        .padding(.top, Theme.Spacing.medium)
    }
    
    // MARK: - Gamification Tabs
    private var gamificationTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.medium) {
                ForEach(GamificationTab.allCases, id: \.self) { tab in
                    GamificationTabButton(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        action: {
                            withAnimation(.spring()) {
                                selectedTab = tab
                            }
                        }
                    )
                    .matchedGeometryEffect(id: "tab-\(tab.rawValue)", in: gamificationNamespace)
                }
            }
            .padding(.horizontal, Theme.Spacing.large)
        }
        .padding(.vertical, Theme.Spacing.medium)
    }
    
    // MARK: - Overview Content
    private var overviewContent: some View {
        VStack(spacing: Theme.Spacing.large) {
            // Daily streak card
            dailyStreakCard
            
            // Recent achievements
            recentAchievementsSection
            
            // Quick stats
            quickStatsGrid
            
            // Recent rewards
            recentRewardsSection
        }
    }
    
    private var dailyStreakCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(Theme.Colors.neonOrange)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonOrange, pulse: true)
                
                Text("Daily Streak")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                if gamificationService.dailyStreak.isActive {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Theme.Colors.neonGreen)
                            .frame(width: 8, height: 8)
                        
                        Text("Active")
                            .font(.caption2)
                            .foregroundColor(Theme.Colors.neonGreen)
                            .fontWeight(.semibold)
                    }
                }
            }
            
            HStack(spacing: Theme.Spacing.large) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(gamificationService.dailyStreak.currentStreak)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.neonOrange)
                    
                    Text("Current Streak")
                        .font(.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(gamificationService.dailyStreak.longestStreak)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text("Best Streak")
                        .font(.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }
            
            // Streak visualization
            StreakVisualization(streak: gamificationService.dailyStreak)
        }
        .padding()
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.neonOrange, radius: 10)
    }
    
    private var recentAchievementsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundColor(Theme.Colors.neonYellow)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonYellow, pulse: true)
                
                Text("Recent Achievements")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Button("View All") {
                    showingAchievements = true
                }
                .font(.caption)
                .foregroundColor(Theme.Colors.neonYellow)
            }
            
            if gamificationService.achievements.isEmpty {
                EmptyAchievementsView()
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: Theme.Spacing.medium) {
                    ForEach(gamificationService.achievements.prefix(6)) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    private var quickStatsGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: Theme.Spacing.medium) {
            QuickStatCard(
                title: "Total XP",
                value: "\(gamificationService.currentXP)",
                icon: "star.fill",
                color: Theme.Colors.neonBlue
            )
            
            QuickStatCard(
                title: "Achievements",
                value: "\(gamificationService.achievements.count)",
                icon: "trophy.fill",
                color: Theme.Colors.neonYellow
            )
            
            QuickStatCard(
                title: "Badges",
                value: "\(gamificationService.unlockedBadges.count)",
                icon: "shield.fill",
                color: Theme.Colors.neonPink
            )
            
            QuickStatCard(
                title: "Rank",
                value: gamificationService.leaderboardPosition?.rank.description ?? "?",
                icon: "chart.bar.fill",
                color: Theme.Colors.neonGreen
            )
        }
    }
    
    private var recentRewardsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "gift.fill")
                    .foregroundColor(Theme.Colors.neonPink)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonPink, pulse: true)
                
                Text("Recent Rewards")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
            }
            
            if gamificationService.recentRewards.isEmpty {
                EmptyRewardsView()
            } else {
                ForEach(gamificationService.recentRewards.prefix(5)) { reward in
                    RewardCard(reward: reward)
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Achievements Content
    private var achievementsContent: some View {
        VStack(spacing: Theme.Spacing.large) {
            // Achievement categories
            achievementCategoriesGrid
            
            // All achievements
            allAchievementsGrid
        }
    }
    
    private var achievementCategoriesGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: Theme.Spacing.medium) {
            AchievementCategoryCard(
                title: "Progress",
                count: gamificationService.achievements.filter { $0.id.contains("level") }.count,
                icon: "star.fill",
                color: Theme.Colors.neonBlue
            )
            
            AchievementCategoryCard(
                title: "Social",
                count: gamificationService.achievements.filter { $0.id.contains("social") || $0.id.contains("encourage") }.count,
                icon: "heart.fill",
                color: Theme.Colors.neonPink
            )
            
            AchievementCategoryCard(
                title: "Skills",
                count: gamificationService.achievements.filter { $0.id.contains("skill") || $0.id.contains("learn") }.count,
                icon: "brain.head.profile",
                color: Theme.Colors.neonGreen
            )
            
            AchievementCategoryCard(
                title: "Streaks",
                count: gamificationService.achievements.filter { $0.id.contains("streak") }.count,
                icon: "flame.fill",
                color: Theme.Colors.neonOrange
            )
        }
    }
    
    private var allAchievementsGrid: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("All Achievements")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: Theme.Spacing.medium) {
                ForEach(gamificationService.achievements) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Leaderboard Content
    private var leaderboardContent: some View {
        VStack(spacing: Theme.Spacing.large) {
            // User position card
            userPositionCard
            
            // Top players
            topPlayersSection
        }
    }
    
    private var userPositionCard: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(Theme.Colors.neonGreen)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonGreen, pulse: true)
                
                Text("Your Position")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
            }
            
            if let position = gamificationService.leaderboardPosition {
                HStack(spacing: Theme.Spacing.large) {
                    VStack(spacing: 4) {
                        Text("#\(position.rank)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.Colors.neonGreen)
                        
                        Text("Rank")
                            .font(.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    
                    VStack(spacing: 4) {
                        Text("\(position.weeklyXP)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        Text("Weekly XP")
                            .font(.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Image(systemName: position.trend == .up ? "arrow.up" : "arrow.down")
                            .foregroundColor(position.trend == .up ? Theme.Colors.neonGreen : Theme.Colors.neonOrange)
                            .font(.title3)
                        
                        Text("Trend")
                            .font(.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }
            } else {
                Text("Loading position...")
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            Button("View Full Leaderboard") {
                showingLeaderboard = true
            }
            .font(.caption)
            .foregroundColor(Theme.Colors.neonGreen)
        }
        .padding()
        .liquidGlassCard()
    }
    
    private var topPlayersSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Top Players This Week")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ForEach(gamificationService.getLeaderboard().prefix(5)) { entry in
                LeaderboardEntryCard(entry: entry)
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Challenges Content
    private var challengesContent: some View {
        VStack(spacing: Theme.Spacing.large) {
            // Weekly challenge
            if let challenge = gamificationService.weeklyChallenge {
                WeeklyChallengeCard(challenge: challenge)
            }
            
            // Challenge history placeholder
            Text("More challenges coming soon!")
                .font(.subheadline)
                .foregroundColor(Theme.Colors.textSecondary)
                .padding()
                .liquidGlassCard()
        }
    }
    
    // MARK: - Animations Overlay
    private var animationsOverlay: some View {
        ZStack {
            // XP Gain Animation
            if gamificationService.showingXPGainAnimation, let xpGain = gamificationService.pendingXPGain {
                XPGainAnimation(xpGain: xpGain) {
                    gamificationService.dismissXPAnimation()
                }
            }
            
            // Level Up Animation
            if gamificationService.showingLevelUpAnimation {
                LevelUpAnimation(userLevel: gamificationService.userLevel) {
                    gamificationService.dismissLevelUpAnimation()
                }
            }
            
            // Achievement Animation
            if gamificationService.showingAchievementAnimation, let achievement = gamificationService.pendingAchievement {
                AchievementUnlockedAnimation(achievement: achievement) {
                    gamificationService.dismissAchievementAnimation()
                }
            }
            
            // Streak Animation
            if gamificationService.showingStreakAnimation {
                StreakCelebrationAnimation(streak: gamificationService.dailyStreak) {
                    gamificationService.dismissStreakAnimation()
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func shareProgress() {
        // Implementation for sharing progress
        HapticManager.shared.impact(.medium)
    }
}

// MARK: - Supporting Views

struct GamificationTabButton: View {
    let tab: GamificationTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.caption)
                    .foregroundColor(isSelected ? tab.color : Theme.Colors.textSecondary)
                
                Text(tab.title)
                    .font(Theme.Typography.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? Theme.Colors.textPrimary : Theme.Colors.textSecondary)
            }
            .padding(.horizontal, Theme.Spacing.medium)
            .padding(.vertical, Theme.Spacing.small)
            .background(
                isSelected ? tab.color.opacity(0.2) : Theme.Colors.glassPrimary,
                in: Capsule()
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? tab.color : Color.clear, lineWidth: 1)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StreakVisualization: View {
    let streak: DailyStreak
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<7, id: \.self) { day in
                let dayIndex = (7 - day)
                let hasActivity = dayIndex <= streak.currentStreak
                
                Circle()
                    .fill(hasActivity ? Theme.Colors.neonOrange : Theme.Colors.glassPrimary)
                    .frame(width: 20, height: 20)
                    .scaleEffect(hasActivity ? 1.1 : 1.0)
                    .animation(.spring().delay(Double(day) * 0.1), value: hasActivity)
            }
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: achievement.icon)
                .foregroundColor(Theme.Colors.fromString(achievement.rarity.color))
                .font(.title3)
                .neonGlow(color: Theme.Colors.fromString(achievement.rarity.color), pulse: true)
            
            Text(achievement.title)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.Colors.fromString(achievement.rarity.color).opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.Colors.fromString(achievement.rarity.color).opacity(0.3), lineWidth: 1)
        )
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .neonGlow(color: color, pulse: true)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .liquidGlassCard()
    }
}

struct RewardCard: View {
    let reward: Reward
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            Image(systemName: reward.icon)
                .foregroundColor(Theme.Colors.fromString(reward.type.color))
                .font(.title3)
                .neonGlow(color: Theme.Colors.fromString(reward.type.color), pulse: true)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(reward.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text(reward.description)
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            Spacer()
            
            Text(reward.timestamp, style: .relative)
                .font(.caption2)
                .foregroundColor(Theme.Colors.textTertiary)
        }
        .padding()
        .background(Theme.Colors.fromString(reward.type.color).opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct AchievementCategoryCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .neonGlow(color: color, pulse: true)
            
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .liquidGlassCard()
    }
}

struct LeaderboardEntryCard: View {
    let entry: LeaderboardEntry
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            // Rank
            Text("#\(entry.rank)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(entry.isCurrentUser ? Theme.Colors.neonGreen : Theme.Colors.textSecondary)
                .frame(width: 30)
            
            // Name and level
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name)
                    .font(.caption)
                    .fontWeight(entry.isCurrentUser ? .bold : .medium)
                    .foregroundColor(entry.isCurrentUser ? Theme.Colors.neonGreen : Theme.Colors.textPrimary)
                
                Text("Level \(entry.level)")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            Spacer()
            
            // Weekly XP
            Text("\(entry.weeklyXP) XP")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .padding()
        .background(
            entry.isCurrentUser ? Theme.Colors.neonGreen.opacity(0.1) : Theme.Colors.glassPrimary,
            in: RoundedRectangle(cornerRadius: 12)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(entry.isCurrentUser ? Theme.Colors.neonGreen.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}

struct WeeklyChallengeCard: View {
    let challenge: WeeklyChallenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: challenge.icon)
                    .foregroundColor(Theme.Colors.neonGreen)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonGreen, pulse: true)
                
                Text("Weekly Challenge")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                if challenge.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Theme.Colors.neonGreen)
                        .font(.title3)
                }
            }
            
            Text(challenge.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Text(challenge.description)
                .font(.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            
            // Progress
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Progress: \(challenge.currentProgress)/\(challenge.targetCount)")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                    
                    Spacer()
                    
                    Text("\(Int(challenge.progressPercentage * 100))%")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.neonGreen)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Theme.Colors.glassPrimary)
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Theme.Colors.neonGreen)
                            .frame(width: geometry.size.width * challenge.progressPercentage, height: 6)
                            .animation(.spring(), value: challenge.progressPercentage)
                    }
                }
                .frame(height: 6)
            }
            
            HStack {
                Text("Reward: \(challenge.xpReward) XP")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.neonYellow)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("Ends: \(challenge.deadline, style: .relative)")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textTertiary)
            }
        }
        .padding()
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.neonGreen, radius: 10)
    }
}

// MARK: - Empty State Views

struct EmptyAchievementsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "trophy")
                .font(.title)
                .foregroundColor(Theme.Colors.textTertiary)
            
            Text("No achievements yet")
                .font(.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            
            Text("Complete activities to unlock achievements")
                .font(.caption2)
                .foregroundColor(Theme.Colors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.Colors.glassPrimary.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct EmptyRewardsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "gift")
                .font(.title)
                .foregroundColor(Theme.Colors.textTertiary)
            
            Text("No recent rewards")
                .font(.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            
            Text("Earn XP and complete goals to receive rewards")
                .font(.caption2)
                .foregroundColor(Theme.Colors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.Colors.glassPrimary.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Supporting Types

enum GamificationTab: String, CaseIterable {
    case overview = "Overview"
    case achievements = "Achievements"
    case leaderboard = "Leaderboard"
    case challenges = "Challenges"
    
    var title: String { rawValue }
    
    var icon: String {
        switch self {
        case .overview: return "rectangle.grid.1x2.fill"
        case .achievements: return "trophy.fill"
        case .leaderboard: return "chart.bar.fill"
        case .challenges: return "target"
        }
    }
    
    var color: Color {
        switch self {
        case .overview: return Theme.Colors.neonBlue
        case .achievements: return Theme.Colors.neonYellow
        case .leaderboard: return Theme.Colors.neonGreen
        case .challenges: return Theme.Colors.neonOrange
        }
    }
}

// MARK: - Theme Extension

extension Theme.Colors {
    static func fromString(_ colorString: String) -> Color {
        switch colorString {
        case "neonBlue": return neonBlue
        case "neonGreen": return neonGreen
        case "neonPink": return neonPink
        case "neonYellow": return neonYellow
        case "neonOrange": return neonOrange
        case "neonPurple": return neonPurple ?? neonPink
        case "textSecondary": return textSecondary
        default: return neonBlue
        }
    }
}

// MARK: - Placeholder Views (to be implemented)

struct XPGainAnimation: View {
    let xpGain: XPGain
    let onComplete: () -> Void
    
    var body: some View {
        Text("+\(xpGain.amount) XP")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Theme.Colors.neonBlue)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    onComplete()
                }
            }
    }
}

struct LevelUpAnimation: View {
    let userLevel: UserLevel
    let onComplete: () -> Void
    
    var body: some View {
        Text("Level Up!")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(Theme.Colors.neonYellow)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    onComplete()
                }
            }
    }
}

struct AchievementUnlockedAnimation: View {
    let achievement: Achievement
    let onComplete: () -> Void
    
    var body: some View {
        Text("Achievement Unlocked!")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Theme.Colors.neonPink)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    onComplete()
                }
            }
    }
}

struct StreakCelebrationAnimation: View {
    let streak: DailyStreak
    let onComplete: () -> Void
    
    var body: some View {
        Text("\(streak.currentStreak) Day Streak!")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Theme.Colors.neonOrange)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    onComplete()
                }
            }
    }
}

struct LeaderboardDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("Full Leaderboard")
                .navigationTitle("Leaderboard")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

struct AchievementsDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("All Achievements")
                .navigationTitle("Achievements")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

struct BadgesCollectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("Badge Collection")
                .navigationTitle("Badges")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

#Preview {
    GamificationDashboardView()
}
