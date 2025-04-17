//
//  SkillTagView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  🏷️ Branded Skill Pill Component – Reusable & Themed
//

import SwiftUI

/// A compact, styled tag for representing a user skill or category
struct SkillTagView: View {
    @Binding var skill: String
    var backgroundColor: Color = Theme.Colors.accent.opacity(0.15)
    var textColor: Color = Theme.Colors.accent
    var font: Font = Theme.Typography.caption
    var cornerRadius: CGFloat = Theme.CornerRadius.small
    var horizontalPadding: CGFloat = Theme.Spacing.medium
    var verticalPadding: CGFloat = Theme.Spacing.small

    var body: some View {
        Text(skill)
            .font(font)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .accessibilityLabel("Skill tag: \(skill)")
            .accessibilityHint("Represents a skill or category")
    }
}

#Preview {
    StatefulPreviewWrapper("Leadership") { skill in
        SkillTagView(skill: skill)
            .padding()
            .background(Theme.Colors.background)
    }
}
