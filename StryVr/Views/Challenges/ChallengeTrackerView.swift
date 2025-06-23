//
//  ChallengeTrackerView.swift
//  StryVr
//
//  🎯 Challenge Tracker Screen – Visual Progress & Challenge Completion
//

import SwiftUI

struct Challenge: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let currentProgress: Int
    let goal: Int
}

struct ChallengeTrackerView: View {
    @State private var challenges: [Challenge] = [
        Challenge(title: "Complete 5 Modules", description: "Finish 5 modules in your current learning path.", currentProgress: 3, goal: 5),
        Challenge(title: "Master a New Skill", description: "Complete a full learning path in any subject.", currentProgress: 4, goal: 4),
        Challenge(title: "Engage Daily for a Week", description: "Log in every day for 7 consecutive days.", currentProgress: 5, goal: 7)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    Text("Active Challenges")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .padding(.top, Theme.Spacing.large)

                    ForEach(challenges) { challenge in
                        challengeCard(for: challenge)
                    }
                }
                .padding()
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Challenges")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Challenge Card
    private func challengeCard(for challenge: Challenge) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            HStack {
                Text(challenge.title)
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()

                if challenge.currentProgress >= challenge.goal {
                    Text("✅ Completed")
                        .font(Theme.Typography.caption)
                        .foregroundColor(.green)
                        .bold()
                }
            }

            Text(challenge.description)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.leading)

            ProgressView(value: Double(challenge.currentProgress), total: Double(challenge.goal))
                .progressViewStyle(LinearProgressViewStyle(tint: Theme.Colors.accent))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding()
        .background(Theme.Colors.card)
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Theme.Colors.accent.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ChallengeTrackerView()
}
