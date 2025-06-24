//
//  FeedbackSummaryCard.swift
//  StryVr
//
//  📊 Compact Card UI to Display Summary of Feedback
//

import SwiftUI

struct FeedbackSummaryCard: View {
    let averageRating: Double
    let strengths: [String]
    let weaknesses: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            // MARK: - Title

            Text("Team Feedback Overview")
                .font(Theme.Typography.subheadline)
                .foregroundColor(Theme.Colors.textPrimary)

            // MARK: - Average Score

            HStack {
                Text("Average Rating: ")
                    .font(Theme.Typography.caption)
                Text(String(format: "%.1f ★", averageRating))
                    .font(Theme.Typography.caption)
                    .foregroundColor(.green)
            }

            // MARK: - Strengths

            if !strengths.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Strengths")
                        .font(Theme.Typography.caption)
                        .foregroundColor(.green)
                    ForEach(strengths, id: \.self) { item in
                        Text("• \(item)")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                }
            }

            // MARK: - Weaknesses

            if !weaknesses.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Needs Improvement")
                        .font(Theme.Typography.caption)
                        .foregroundColor(.red)
                    ForEach(weaknesses, id: \.self) { item in
                        Text("• \(item)")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                }
            }
        }
        .padding()
        .background(Theme.Colors.card)
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(radius: 2)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    FeedbackSummaryCard(
        averageRating: 4.3,
        strengths: ["Teamwork", "Responsiveness"],
        weaknesses: ["Clarity"]
    )
}
