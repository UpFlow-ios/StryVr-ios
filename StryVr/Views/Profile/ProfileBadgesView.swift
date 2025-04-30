//
//  ProfileBadgesView.swift
//  StryVr
//
//  🎖 Displays User Achievement and Verification Badges
//

import SwiftUI

struct Badge: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let isUnlocked: Bool
}

struct ProfileBadgesView: View {
    @State private var badges: [Badge] = [
        Badge(title: "Skill Verified", description: "Passed a skill verification quiz", imageName: "checkmark.shield", isUnlocked: true),
        Badge(title: "Top Learner", description: "Completed 3+ learning paths", imageName: "bolt.fill", isUnlocked: true),
        Badge(title: "Challenge Champion", description: "Won a weekly skill challenge", imageName: "trophy.fill", isUnlocked: false),
        Badge(title: "Mentor Contributor", description: "Mentored other users", imageName: "person.2.fill", isUnlocked: false),
        Badge(title: "Community Leader", description: "Highly active in community feed", imageName: "star.circle", isUnlocked: false)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                Text("Your Badges")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.top, Theme.Spacing.large)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.medium) {
                    ForEach(badges) { badge in
                        badgeCard(for: badge)
                    }
                }
            }
            .padding()
        }
        .background(Theme.Colors.background.ignoresSafeArea())
        .navigationTitle("Badges")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Badge Card
    private func badgeCard(for badge: Badge) -> some View {
        VStack(spacing: Theme.Spacing.small) {
            Image(systemName: badge.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(badge.isUnlocked ? Theme.Colors.accent : .gray.opacity(0.3))

            Text(badge.title)
                .font(Theme.Typography.body)
                .foregroundColor(badge.isUnlocked ? Theme.Colors.textPrimary : .gray)

            Text(badge.description)
                .font(Theme.Typography.caption)
                .foregroundColor(badge.isUnlocked ? Theme.Colors.textSecondary : .gray.opacity(0.5))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.Colors.card)
        .cornerRadius(Theme.CornerRadius.medium)
        .opacity(badge.isUnlocked ? 1 : 0.5)
    }
}

#Preview {
    ProfileBadgesView()
}

