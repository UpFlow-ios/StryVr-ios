//
//  GamificationService.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  🎮 Revolutionary Gamification System - XP, Levels, Streaks & Achievements
//  🏆 Social Competition & Progress Visualization for Maximum Engagement
//

import Foundation
import Combine

@MainActor
class GamificationService: ObservableObject {
    static let shared = GamificationService()
    
    // MARK: - Published Properties
    @Published var userLevel: UserLevel = UserLevel()
    @Published var currentXP: Int = 0
    @Published var dailyStreak: DailyStreak = DailyStreak()
    @Published var achievements: [Achievement] = []
    @Published var unlockedBadges: [Badge] = []
    @Published var leaderboardPosition: LeaderboardPosition?
    @Published var weeklyChallenge: WeeklyChallenge?
    @Published var recentRewards: [Reward] = []
    @Published var socialStats: SocialStats = SocialStats()
    
    // MARK: - Animation States
    @Published var showingLevelUpAnimation = false
    @Published var showingXPGainAnimation = false
    @Published var showingAchievementAnimation = false
    @Published var showingStreakAnimation = false
    @Published var pendingXPGain: XPGain?
    @Published var pendingAchievement: Achievement?
    
    private var cancellables = Set<AnyCancellable>()
    private let hapticManager = HapticManager.shared
    
    private init() {
        setupGamificationSystem()
        loadUserProgress()
    }
    
    // MARK: - XP and Level System
    
    func awardXP(for action: GameAction, context: String = "", multiplier: Double = 1.0) {
        let baseXP = action.baseXP
        let finalXP = Int(Double(baseXP) * multiplier)
        
        let xpGain = XPGain(
            action: action,
            amount: finalXP,
            context: context,
            timestamp: Date()
        )
        
        // Add XP
        currentXP += finalXP
        
        // Check for level up
        let previousLevel = userLevel.level
        updateUserLevel()
        
        // Trigger animations
        pendingXPGain = xpGain
        showingXPGainAnimation = true
        
        if userLevel.level > previousLevel {
            triggerLevelUpAnimation()
            awardLevelUpRewards()
        }
        
        // Check for achievements
        checkForNewAchievements(action: action, xpGain: finalXP)
        
        // Update streak if applicable
        if action.countsForStreak {
            updateDailyStreak()
        }
        
        // Add to recent rewards
        addReward(Reward(
            type: .xp,
            title: "+\(finalXP) XP",
            description: action.description,
            icon: action.icon,
            timestamp: Date()
        ))
        
        hapticManager.impact(.light)
    }
    
    private func updateUserLevel() {
        let newLevel = calculateLevel(from: currentXP)
        let previousLevel = userLevel.level
        
        userLevel = UserLevel(
            level: newLevel,
            title: getLevelTitle(newLevel),
            currentXP: currentXP,
            xpToNext: getXPToNextLevel(newLevel),
            progressToNext: calculateProgressToNext(newLevel)
        )
        
        // Update social stats
        if newLevel > previousLevel {
            socialStats.totalLevelsGained += (newLevel - previousLevel)
        }
    }
    
    private func calculateLevel(from xp: Int) -> Int {
        // Progressive XP requirements: 100, 250, 450, 700, 1000, 1350, 1750, 2200...
        var level = 1
        var requiredXP = 0
        
        while requiredXP <= xp {
            level += 1
            requiredXP += (level * 150) + (level * level * 25)
        }
        
        return max(1, level - 1)
    }
    
    private func getXPToNextLevel(_ level: Int) -> Int {
        return ((level + 1) * 150) + ((level + 1) * (level + 1) * 25)
    }
    
    private func calculateProgressToNext(_ level: Int) -> Double {
        let currentLevelXP = getTotalXPForLevel(level)
        let nextLevelXP = getTotalXPForLevel(level + 1)
        let progress = Double(currentXP - currentLevelXP) / Double(nextLevelXP - currentLevelXP)
        return max(0, min(1, progress))
    }
    
    private func getTotalXPForLevel(_ level: Int) -> Int {
        var totalXP = 0
        for levelIndex in 1..<level {
            totalXP += (levelIndex * 150) + (levelIndex * levelIndex * 25)
        }
        return totalXP
    }
    
    private func getLevelTitle(_ level: Int) -> String {
        switch level {
        case 1...5: return "Newcomer"
        case 6...10: return "Rising Star"
        case 11...20: return "Professional"
        case 21...35: return "Expert"
        case 36...50: return "Master"
        case 51...75: return "Elite"
        case 76...100: return "Legendary"
        default: return "Grandmaster"
        }
    }
    
    // MARK: - Daily Streak System
    
    private func updateDailyStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        let lastActivityDate = Calendar.current.startOfDay(for: dailyStreak.lastActivityDate)
        
        if Calendar.current.isDate(today, inSameDayAs: lastActivityDate) {
            // Same day, no streak change
            return
        } else if Calendar.current.date(byAdding: .day, value: 1, to: lastActivityDate) == today {
            // Consecutive day, increase streak
            dailyStreak.currentStreak += 1
            dailyStreak.lastActivityDate = Date()
            
            if dailyStreak.currentStreak > dailyStreak.longestStreak {
                dailyStreak.longestStreak = dailyStreak.currentStreak
            }
            
            // Award streak bonus XP
            let streakBonus = min(dailyStreak.currentStreak * 10, 100)
            currentXP += streakBonus
            
            triggerStreakAnimation()
            checkForStreakAchievements()
            
            addReward(Reward(
                type: .streak,
                title: "\(dailyStreak.currentStreak) Day Streak!",
                description: "Bonus +\(streakBonus) XP",
                icon: "flame.fill",
                timestamp: Date()
            ))
        } else {
            // Streak broken
            if dailyStreak.currentStreak > 0 {
                // Award a small consolation for effort
                addReward(Reward(
                    type: .consolation,
                    title: "Streak Reset",
                    description: "Start fresh tomorrow!",
                    icon: "arrow.clockwise",
                    timestamp: Date()
                ))
            }
            
            dailyStreak.currentStreak = 1
            dailyStreak.lastActivityDate = Date()
        }
        
        socialStats.totalDaysActive += 1
    }
    
    // MARK: - Achievement System
    
    private func checkForNewAchievements(action: GameAction, xpGain: Int) {
        let newAchievements = AchievementChecker.checkAchievements(
            action: action,
            xpGain: xpGain,
            userLevel: userLevel,
            streak: dailyStreak,
            socialStats: socialStats,
            currentAchievements: achievements
        )
        
        for achievement in newAchievements {
            unlockAchievement(achievement)
        }
    }
    
    private func checkForStreakAchievements() {
        let streakAchievements = AchievementChecker.checkStreakAchievements(
            streak: dailyStreak,
            currentAchievements: achievements
        )
        
        for achievement in streakAchievements {
            unlockAchievement(achievement)
        }
    }
    
    private func unlockAchievement(_ achievement: Achievement) {
        guard !achievements.contains(where: { $0.id == achievement.id }) else { return }
        
        achievements.append(achievement)
        
        // Award achievement XP
        currentXP += achievement.xpReward
        updateUserLevel()
        
        // Award badge if applicable
        if let badge = achievement.badge {
            unlockedBadges.append(badge)
        }
        
        // Trigger celebration animation
        pendingAchievement = achievement
        showingAchievementAnimation = true
        
        // Add to rewards
        addReward(Reward(
            type: .achievement,
            title: "Achievement Unlocked!",
            description: achievement.title,
            icon: achievement.icon,
            timestamp: Date()
        ))
        
        // Update social stats
        socialStats.totalAchievements += 1
        
        hapticManager.impact(.heavy)
    }
    
    // MARK: - Leaderboard System
    
    func updateLeaderboardPosition() {
        // In a real implementation, this would fetch from server
        leaderboardPosition = LeaderboardPosition(
            rank: Int.random(in: 15...45),
            totalPlayers: Int.random(in: 250...500),
            weeklyXP: Int.random(in: 800...2000),
            trend: Bool.random() ? .up : .down
        )
    }
    
    func getLeaderboard(type: LeaderboardType = .weekly) -> [LeaderboardEntry] {
        // Mock leaderboard data
        return LeaderboardGenerator.generateMockLeaderboard(userLevel: userLevel.level)
    }
    
    // MARK: - Weekly Challenge System
    
    func loadWeeklyChallenge() {
        weeklyChallenge = WeeklyChallengeGenerator.generateChallenge()
    }
    
    func updateChallengeProgress(for action: GameAction) {
        guard var challenge = weeklyChallenge else { return }
        
        if challenge.targetAction == action {
            challenge.currentProgress += 1
            
            if challenge.currentProgress >= challenge.targetCount {
                completeWeeklyChallenge(challenge)
            }
            
            weeklyChallenge = challenge
        }
    }
    
    private func completeWeeklyChallenge(_ challenge: WeeklyChallenge) {
        // Award challenge rewards
        currentXP += challenge.xpReward
        updateUserLevel()
        
        addReward(Reward(
            type: .challenge,
            title: "Challenge Complete!",
            description: challenge.title,
            icon: "star.circle.fill",
            timestamp: Date()
        ))
        
        // Generate next week's challenge
        loadWeeklyChallenge()
        
        hapticManager.impact(.heavy)
    }
    
    // MARK: - Social Features
    
    func celebrateWithFriends(_ achievement: Achievement) {
        socialStats.totalCelebrations += 1
        // In real implementation, would share to social feed
    }
    
    func encourageFriend(_ friendId: String) {
        socialStats.totalEncouragements += 1
        // Award small XP for being supportive
        awardXP(for: .encourageFriend, context: "Supporting community")
    }
    
    // MARK: - Animation Triggers
    
    private func triggerLevelUpAnimation() {
        showingLevelUpAnimation = true
        hapticManager.impact(.heavy)
    }
    
    private func triggerStreakAnimation() {
        showingStreakAnimation = true
        hapticManager.impact(.medium)
    }
    
    private func awardLevelUpRewards() {
        let levelUpReward = Reward(
            type: .levelUp,
            title: "Level Up!",
            description: "Welcome to Level \(userLevel.level)",
            icon: "star.fill",
            timestamp: Date()
        )
        
        addReward(levelUpReward)
        
        // Award level-specific bonuses
        if userLevel.level % 5 == 0 {
            // Every 5 levels, award a special badge
            let milestoneAchievement = Achievement(
                id: "level_\(userLevel.level)",
                title: "Level \(userLevel.level) Master",
                description: "Reached level \(userLevel.level)!",
                icon: "crown.fill",
                rarity: .rare,
                xpReward: userLevel.level * 50,
                badge: Badge(
                    id: "milestone_\(userLevel.level)",
                    name: "Level \(userLevel.level)",
                    icon: "crown.fill",
                    color: "neonYellow",
                    rarity: .rare
                )
            )
            
            unlockAchievement(milestoneAchievement)
        }
    }
    
    private func addReward(_ reward: Reward) {
        recentRewards.insert(reward, at: 0)
        
        // Keep only recent 20 rewards
        if recentRewards.count > 20 {
            recentRewards = Array(recentRewards.prefix(20))
        }
    }
    
    // MARK: - Animation Dismissal
    
    func dismissXPAnimation() {
        showingXPGainAnimation = false
        pendingXPGain = nil
    }
    
    func dismissLevelUpAnimation() {
        showingLevelUpAnimation = false
    }
    
    func dismissAchievementAnimation() {
        showingAchievementAnimation = false
        pendingAchievement = nil
    }
    
    func dismissStreakAnimation() {
        showingStreakAnimation = false
    }
    
    // MARK: - System Setup
    
    private func setupGamificationSystem() {
        // Setup periodic leaderboard updates
        Timer.publish(every: 300, on: .main, in: .common) // Every 5 minutes
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateLeaderboardPosition()
            }
            .store(in: &cancellables)
        
        // Load weekly challenge
        loadWeeklyChallenge()
    }
    
    private func loadUserProgress() {
        // In a real implementation, load from persistent storage
        currentXP = 1247
        updateUserLevel()
        
        dailyStreak = DailyStreak(
            currentStreak: 3,
            longestStreak: 12,
            lastActivityDate: Date().addingTimeInterval(-86400)
        )
        
        socialStats = SocialStats(
            totalDaysActive: 45,
            totalAchievements: 12,
            totalLevelsGained: 8,
            totalCelebrations: 23,
            totalEncouragements: 67
        )
        
        updateLeaderboardPosition()
    }
}

// MARK: - Data Models

struct UserLevel {
    var level: Int = 1
    var title: String = "Newcomer"
    var currentXP: Int = 0
    var xpToNext: Int = 150
    var progressToNext: Double = 0.0
}

struct DailyStreak {
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastActivityDate: Date = Date()
    
    var isActive: Bool {
        Calendar.current.isDateInToday(lastActivityDate)
    }
}

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let rarity: AchievementRarity
    let xpReward: Int
    let badge: Badge?
    let timestamp: Date = Date()
}

enum AchievementRarity {
    case common, rare, epic, legendary
    
    var color: String {
        switch self {
        case .common: return "neonBlue"
        case .rare: return "neonGreen"
        case .epic: return "neonPink"
        case .legendary: return "neonYellow"
        }
    }
    
    var glowIntensity: Double {
        switch self {
        case .common: return 0.5
        case .rare: return 0.7
        case .epic: return 0.9
        case .legendary: return 1.2
        }
    }
}

struct Badge: Identifiable {
    let id: String
    let name: String
    let icon: String
    let color: String
    let rarity: AchievementRarity
    let timestamp: Date = Date()
}

struct XPGain {
    let action: GameAction
    let amount: Int
    let context: String
    let timestamp: Date
}

enum GameAction {
    case completeMeeting, shareInsight, helpColleague, completeGoal, learnSkill
    case askQuestion, givePresentation, facilitateMeeting, provideFeedback
    case encourageFriend, shareAchievement, joinCollaboration, completeChallenge
    
    var baseXP: Int {
        switch self {
        case .completeMeeting: return 50
        case .shareInsight: return 25
        case .helpColleague: return 30
        case .completeGoal: return 100
        case .learnSkill: return 75
        case .askQuestion: return 15
        case .givePresentation: return 80
        case .facilitateMeeting: return 90
        case .provideFeedback: return 20
        case .encourageFriend: return 10
        case .shareAchievement: return 5
        case .joinCollaboration: return 40
        case .completeChallenge: return 150
        }
    }
    
    var description: String {
        switch self {
        case .completeMeeting: return "Completed meeting"
        case .shareInsight: return "Shared insight"
        case .helpColleague: return "Helped colleague"
        case .completeGoal: return "Completed goal"
        case .learnSkill: return "Learned new skill"
        case .askQuestion: return "Asked question"
        case .givePresentation: return "Gave presentation"
        case .facilitateMeeting: return "Facilitated meeting"
        case .provideFeedback: return "Provided feedback"
        case .encourageFriend: return "Encouraged friend"
        case .shareAchievement: return "Shared achievement"
        case .joinCollaboration: return "Joined collaboration"
        case .completeChallenge: return "Completed challenge"
        }
    }
    
    var icon: String {
        switch self {
        case .completeMeeting: return "checkmark.circle.fill"
        case .shareInsight: return "lightbulb.fill"
        case .helpColleague: return "hand.raised.fill"
        case .completeGoal: return "target"
        case .learnSkill: return "brain.head.profile"
        case .askQuestion: return "questionmark.circle.fill"
        case .givePresentation: return "person.wave.2.fill"
        case .facilitateMeeting: return "person.3.fill"
        case .provideFeedback: return "quote.bubble.fill"
        case .encourageFriend: return "heart.fill"
        case .shareAchievement: return "star.fill"
        case .joinCollaboration: return "person.2.badge.plus"
        case .completeChallenge: return "trophy.fill"
        }
    }
    
    var countsForStreak: Bool {
        switch self {
        case .completeMeeting, .completeGoal, .learnSkill, .givePresentation, .facilitateMeeting:
            return true
        default:
            return false
        }
    }
}

struct LeaderboardPosition {
    let rank: Int
    let totalPlayers: Int
    let weeklyXP: Int
    let trend: RankTrend
}

enum RankTrend {
    case up, down, stable
}

struct LeaderboardEntry: Identifiable {
    let id = UUID()
    let rank: Int
    let name: String
    let level: Int
    let weeklyXP: Int
    let badge: String?
    let isCurrentUser: Bool
}

enum LeaderboardType {
    case weekly, monthly, allTime
}

struct WeeklyChallenge: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let targetAction: GameAction
    let targetCount: Int
    var currentProgress: Int
    let xpReward: Int
    let icon: String
    let deadline: Date
    
    var progressPercentage: Double {
        return min(1.0, Double(currentProgress) / Double(targetCount))
    }
    
    var isCompleted: Bool {
        return currentProgress >= targetCount
    }
}

struct SocialStats {
    var totalDaysActive: Int = 0
    var totalAchievements: Int = 0
    var totalLevelsGained: Int = 0
    var totalCelebrations: Int = 0
    var totalEncouragements: Int = 0
}

struct Reward: Identifiable {
    let id = UUID()
    let type: RewardType
    let title: String
    let description: String
    let icon: String
    let timestamp: Date
}

enum RewardType {
    case xp, levelUp, achievement, streak, challenge, badge, consolation
    
    var color: String {
        switch self {
        case .xp: return "neonBlue"
        case .levelUp: return "neonYellow"
        case .achievement: return "neonPink"
        case .streak: return "neonOrange"
        case .challenge: return "neonGreen"
        case .badge: return "neonPurple"
        case .consolation: return "textSecondary"
        }
    }
}

// MARK: - Helper Classes

class AchievementChecker {
    static func checkAchievements(
        action: GameAction,
        xpGain: Int,
        userLevel: UserLevel,
        streak: DailyStreak,
        socialStats: SocialStats,
        currentAchievements: [Achievement]
    ) -> [Achievement] {
        var newAchievements: [Achievement] = []
        
        // First meeting achievement
        if action == .completeMeeting && !hasAchievement("first_meeting", in: currentAchievements) {
            newAchievements.append(Achievement(
                id: "first_meeting",
                title: "Meeting Master",
                description: "Completed your first meeting",
                icon: "checkmark.circle.fill",
                rarity: .common,
                xpReward: 25,
                badge: Badge(id: "first_meeting", name: "First Meeting", icon: "checkmark.circle.fill", color: "neonBlue", rarity: .common)
            ))
        }
        
        // Level milestones
        if userLevel.level >= 10 && !hasAchievement("level_10", in: currentAchievements) {
            newAchievements.append(Achievement(
                id: "level_10",
                title: "Rising Professional",
                description: "Reached level 10",
                icon: "star.fill",
                rarity: .rare,
                xpReward: 100,
                badge: Badge(id: "level_10", name: "Level 10", icon: "star.fill", color: "neonGreen", rarity: .rare)
            ))
        }
        
        // Social achievements
        if socialStats.totalEncouragements >= 10 && !hasAchievement("encourager", in: currentAchievements) {
            newAchievements.append(Achievement(
                id: "encourager",
                title: "Team Encourager",
                description: "Encouraged colleagues 10 times",
                icon: "heart.fill",
                rarity: .rare,
                xpReward: 75,
                badge: Badge(id: "encourager", name: "Encourager", icon: "heart.fill", color: "neonPink", rarity: .rare)
            ))
        }
        
        return newAchievements
    }
    
    static func checkStreakAchievements(
        streak: DailyStreak,
        currentAchievements: [Achievement]
    ) -> [Achievement] {
        var newAchievements: [Achievement] = []
        
        // Streak milestones
        let streakMilestones = [7: "week_streak", 30: "month_streak", 100: "legendary_streak"]
        
        for (days, achievementId) in streakMilestones {
            if streak.currentStreak >= days && !hasAchievement(achievementId, in: currentAchievements) {
                let rarity: AchievementRarity = days >= 100 ? .legendary : (days >= 30 ? .epic : .rare)
                
                newAchievements.append(Achievement(
                    id: achievementId,
                    title: "\(days) Day Streak",
                    description: "Maintained a \(days) day streak",
                    icon: "flame.fill",
                    rarity: rarity,
                    xpReward: days * 2,
                    badge: Badge(id: achievementId, name: "\(days) Day Streak", icon: "flame.fill", color: rarity.color, rarity: rarity)
                ))
            }
        }
        
        return newAchievements
    }
    
    private static func hasAchievement(_ id: String, in achievements: [Achievement]) -> Bool {
        return achievements.contains { $0.id == id }
    }
}

class LeaderboardGenerator {
    static func generateMockLeaderboard(userLevel: Int) -> [LeaderboardEntry] {
        let names = ["Alex Chen", "Sarah Johnson", "Marcus Rodriguez", "Elena Petrov", "James Wilson", "Maya Patel", "David Kim", "Lisa Zhang"]
        
        var entries: [LeaderboardEntry] = []
        
        for index in 1...10 {
            let isCurrentUser = index == 5 // User is 5th place
            entries.append(LeaderboardEntry(
                rank: index,
                name: isCurrentUser ? "You" : names.randomElement()!,
                level: isCurrentUser ? userLevel : Int.random(in: max(1, userLevel-3)...(userLevel+2)),
                weeklyXP: Int.random(in: 500...2000),
                badge: Bool.random() ? "star.fill" : nil,
                isCurrentUser: isCurrentUser
            ))
        }
        
        return entries
    }
}

class WeeklyChallengeGenerator {
    static func generateChallenge() -> WeeklyChallenge {
        let challenges = [
            (action: GameAction.completeMeeting, title: "Meeting Champion", description: "Complete 5 meetings this week", count: 5),
            (action: GameAction.shareInsight, title: "Insight Sharer", description: "Share 10 insights this week", count: 10),
            (action: GameAction.helpColleague, title: "Team Helper", description: "Help 3 colleagues this week", count: 3),
            (action: GameAction.askQuestion, title: "Curious Mind", description: "Ask 15 questions this week", count: 15)
        ]
        
        let challenge = challenges.randomElement()!
        
        return WeeklyChallenge(
            title: challenge.title,
            description: challenge.description,
            targetAction: challenge.action,
            targetCount: challenge.count,
            currentProgress: Int.random(in: 0...(challenge.count/2)),
            xpReward: challenge.count * challenge.action.baseXP,
            icon: challenge.action.icon,
            deadline: Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()
        )
    }
}
