//
//  CustomButton.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  🌱 Themed Minimalist Button with Icon & Customization Support
//

import SwiftUI

/// A reusable, minimalist StryVr button with optional icon and theming
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

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.small) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(font)
                }
                Text(title)
                    .font(font)
                    .fontWeight(.semibold)
            }
            .padding(padding)
            .background(backgroundColor)
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

#Preview {
    VStack(spacing: 20) {
        CustomButton(title: "Get Started", action: {})
        CustomButton(
            title: "Dark Mode", action: {}, backgroundColor: .black, icon: "moon.stars.fill")
    }
    .padding()
    .background(Theme.Colors.background)
}
