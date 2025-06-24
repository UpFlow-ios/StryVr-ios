//
//  StryVrCardView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  🪪 Reusable Themed Card Container with Title & Shadow
//

import SwiftUI

struct StryVrCardView<Content: View>: View {
    let title: String
    let content: Content
    var backgroundColor: Color = Theme.Colors.card
    var shadowColor: Color = Theme.Colors.accent.opacity(0.1)
    var cornerRadius: CGFloat = Theme.CornerRadius.medium
    var shadowRadius: CGFloat = 5
    var shadowOffset: CGSize = .init(width: 0, height: 2)

    init(
        title: String,
        backgroundColor: Color = Theme.Colors.card,
        shadowColor: Color = Theme.Colors.accent.opacity(0.1),
        cornerRadius: CGFloat = Theme.CornerRadius.medium,
        shadowRadius: CGFloat = 5,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.shadowColor = shadowColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            Text(title)
                .font(Theme.Typography.subheadline)
                .foregroundColor(Theme.Colors.accent)
                .accessibilityLabel("Card title: \(title)")
                .accessibilityHint("Displays the title of the card")

            content
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .shadow(color: shadowColor, radius: shadowRadius, x: shadowOffset.width, y: shadowOffset.height)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    StryVrCardView(title: "Example Card") {
        Text("This is card content.")
            .foregroundColor(Theme.Colors.textPrimary)
    }
}
