//
//  CustomButton.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  🌱 Themed Minimalist Button with iOS 18 Liquid Glass & Customization Support
//

import SwiftUI

/// A reusable, minimalist StryVr button with optional icon and iOS 18 Liquid Glass theming
struct CustomButton: View {
    var title: String
    var action: () -> Void
    var backgroundColor: Color = Theme.Colors.accent
    var textColor: Color = Theme.Colors.whiteText
    var icon: String?
    var cornerRadius: CGFloat = Theme.CornerRadius.medium
    var font: Font = Theme.Typography.body
    var fullWidth: Bool = true
    var padding: EdgeInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
    var shadowColor: Color = Theme.Colors.accent.opacity(0.15)
    var shadowRadius: CGFloat = 4
    var shadowOffset: CGSize = .init(width: 0, height: 2)
    var useLiquidGlass: Bool = true
    @Namespace private var glassNamespace

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.small) {
                if let icon = icon {
                    if #available(iOS 18.0, *), useLiquidGlass {
                        Image(systemName: icon)
                            .font(font)
                            .glassEffect(.regular.tint(textColor.opacity(0.3)), in: Circle())
                            .glassEffectID("button-icon-\(title)", in: glassNamespace)
                    } else {
                        Image(systemName: icon)
                            .font(font)
                    }
                }
                Text(title)
                    .font(font)
                    .fontWeight(.semibold)
            }
            .padding(padding)
            .applyCustomButtonGlassEffect()
            .foregroundColor(textColor)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .cornerRadius(cornerRadius)
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title) button")
        .accessibilityHint("Tap to \(title.lowercased())")
    }
}

// MARK: - iOS 18 Liquid Glass Helper Extensions

extension View {
    /// Apply custom button glass effect with iOS 18 Liquid Glass
    func applyCustomButtonGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(
                .regular.tint(Theme.Colors.accent.opacity(0.3)),
                in: RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
        } else {
            return self.background(Theme.Colors.accent)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomButton(title: "Get Started", action: {})
        CustomButton(
            title: "Dark Mode", action: {}, backgroundColor: .black, icon: "moon.stars.fill")
    }
    .padding()
    .background(Theme.Colors.background)
}
