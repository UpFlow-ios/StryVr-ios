//
//  StryVrCardView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  🪪 Reusable Themed Card Container with iOS 18 Liquid Glass & Shadow
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
    var useLiquidGlass: Bool = true
    @Namespace private var glassNamespace

    init(
        title: String,
        backgroundColor: Color = Theme.Colors.card,
        shadowColor: Color = Theme.Colors.accent.opacity(0.1),
        cornerRadius: CGFloat = Theme.CornerRadius.medium,
        shadowRadius: CGFloat = 5,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        useLiquidGlass: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.shadowColor = shadowColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.useLiquidGlass = useLiquidGlass
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            if #available(iOS 18.0, *), useLiquidGlass {
                Text(title)
                    .font(Theme.Typography.subheadline)
                    .foregroundColor(Theme.Colors.accent)
                    .glassEffect(
                        .regular.tint(Theme.Colors.accent.opacity(0.1)),
                        in: RoundedRectangle(cornerRadius: 6)
                    )
                    .glassEffectID("card-title-\(title)", in: glassNamespace)
                    .accessibilityLabel("Card title: \(title)")
                    .accessibilityHint("Displays the title of the card")
            } else {
                Text(title)
                    .font(Theme.Typography.subheadline)
                    .foregroundColor(Theme.Colors.accent)
                    .accessibilityLabel("Card title: \(title)")
                    .accessibilityHint("Displays the title of the card")
            }

            content
        }
        .padding()
        .applyStryVrCardGlassEffect()
        .cornerRadius(cornerRadius)
        .shadow(
            color: shadowColor, radius: shadowRadius, x: shadowOffset.width, y: shadowOffset.height
        )
        .accessibilityElement(children: .combine)
    }
}

// MARK: - iOS 18 Liquid Glass Helper Extensions

extension View {
    /// Apply StryVr card glass effect with iOS 18 Liquid Glass
    func applyStryVrCardGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(
                .regular.tint(Theme.Colors.card.opacity(0.3)),
                in: RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
        } else {
            return self.background(Theme.Colors.card)
        }
    }
}

#Preview {
    StryVrCardView(title: "Example Card") {
        Text("This is card content.")
            .foregroundColor(Theme.Colors.textPrimary)
    }
}
