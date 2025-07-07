//
//  AchievementsView.swift
//  StryVr
//
//  🎖 User Achievements Screen – Unlock Badges, Celebrate with Confetti
//

import SwiftUI

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let isUnlocked: Bool
    let imageName: String
}

struct AchievementsView: View {
    @State private var achievements: [Achievement] = [
        Achievement(title: "First Challenge Completed", isUnlocked: true, imageName: "star.fill"),
        Achievement(title: "Profile Verified", isUnlocked: true, imageName: "checkmark.shield"),
        Achievement(title: "Learning Streak - 7 Days", isUnlocked: false, imageName: "flame.fill"),
    ]

    @State private var showConfetti = false
    @State private var recentlyUnlockedAchievement: Achievement?

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    Text("Achievements")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .padding(.top, Theme.Spacing.large)

                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: Theme.Spacing.large
                    ) {
                        ForEach(achievements) { achievement in
                            achievementCard(for: achievement)
                                .onTapGesture {
                                    handleAchievementTap(achievement)
                                }
                        }
                    }
                }
                .padding()
            }

            if showConfetti {
                LottieAnimationView(animationName: "confetti", loopMode: .playOnce)
                    .frame(width: 300, height: 300)
                    .transition(.scale)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showConfetti = false
                            }
                        }
                    }
            }
        }
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Achievement Card

    private func achievementCard(for achievement: Achievement) -> some View {
        VStack(spacing: Theme.Spacing.small) {
            Image(systemName: achievement.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(achievement.isUnlocked ? Theme.Colors.accent : .gray.opacity(0.4))

            Text(achievement.title)
                .font(Theme.Typography.caption)
                .foregroundColor(achievement.isUnlocked ? Theme.Colors.textPrimary : .gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.Colors.card)
        .cornerRadius(Theme.CornerRadius.medium)
        .opacity(achievement.isUnlocked ? 1 : 0.5)
    }

    // MARK: - Handle Achievement Tap

    private func handleAchievementTap(_ achievement: Achievement) {
        if achievement.isUnlocked {
            recentlyUnlockedAchievement = achievement
            withAnimation {
                showConfetti = true
            }
        }
    }
}

#Preview {
    AchievementsView()
}
