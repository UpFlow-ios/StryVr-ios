//
//  LearningPathDetailView.swift
//  StryVr
//
//  📚 Detailed View of a Learning Path – Milestones, Progress, and Completion
//

import SwiftUI

struct LearningMilestone: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    var isCompleted: Bool
}

struct LearningPathDetailView: View {
    let learningPathTitle: String
    let learningPathDescription: String

    @State private var milestones: [LearningMilestone] = [
        LearningMilestone(title: "Learn Swift Basics", description: "Understand variables, control flow, functions, and basic syntax.", isCompleted: true),
        LearningMilestone(title: "Master SwiftUI", description: "Build beautiful, scalable UI using SwiftUI best practices.", isCompleted: false),
        LearningMilestone(title: "Connect to Firebase", description: "Integrate real-time databases and authentication.", isCompleted: false),
        LearningMilestone(title: "Publish to App Store", description: "Prepare your app for review and submission.", isCompleted: false),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    // MARK: - Learning Path Description

                    VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                        Text(learningPathTitle)
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)

                        Text(learningPathDescription)
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.top, Theme.Spacing.large)

                    Divider()

                    // MARK: - Milestones

                    VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                        Text("Milestones")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.textPrimary)

                        ForEach(milestones) { milestone in
                            milestoneCard(for: milestone)
                        }
                    }
                }
                .padding()
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Learning Path")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Milestone Card

    private func milestoneCard(for milestone: LearningMilestone) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            HStack {
                Image(systemName: milestone.isCompleted ? "checkmark.seal.fill" : "circle")
                    .foregroundColor(milestone.isCompleted ? .green : Theme.Colors.accent)
                    .font(.title2)

                VStack(alignment: .leading, spacing: Theme.Spacing.xSmall) {
                    Text(milestone.title)
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text(milestone.description)
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
            }
            .padding()
            .background(Theme.Colors.card)
            .cornerRadius(Theme.CornerRadius.medium)
            .shadow(color: Theme.Colors.accent.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    LearningPathDetailView(
        learningPathTitle: "iOS Developer Path",
        learningPathDescription: "Learn Swift, SwiftUI, Firebase, and how to publish your first app!"
    )
}
