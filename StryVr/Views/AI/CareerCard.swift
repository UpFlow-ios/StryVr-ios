//
//  CareerCard.swift
//  StryVr
//
//  Created by Joe Dormond on 4/1/25.
//  🧠 Reusable AI Career Suggestion Card | HIG-Compliant & Accessible
//

import SwiftUI

/// A reusable, visually polished career suggestion card powered by AI insights.
struct CareerCard: View {
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Main Career Title
            Text(title)
                .font(Theme.Typography.subheadline)
                .foregroundColor(Theme.Colors.textPrimary)
                .accessibilityLabel("Career title: \(title)")

            // AI-driven suggestion info
            Text("AI suggested this role based on your skill growth.")
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
                .accessibilityHint("AI-based recommendation.")
        }
        .padding(Theme.Spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.Colors.card ?? Color.gray) // Fallback color
        .cornerRadius(Theme.CornerRadius.large)
        .shadow(color: Theme.Colors.textSecondary.opacity(0.1), radius: 4, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton) // Optional: if the card is interactive
    }
}

#Preview {
    CareerCard(title: "iOS Developer")
        .padding()
        .preferredColorScheme(.dark)
}
