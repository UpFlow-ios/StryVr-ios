//
//  CustomTabBar.swift
//  StryVr
//
//  Created by Joe Dormond on 4/28/25.
//  🧭 Custom tab bar with iOS 18 Liquid Glass + Apple Glow UI
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var glassNamespace

    var body: some View {
        HStack(spacing: Theme.Spacing.large) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, Theme.Spacing.large)
        .padding(.vertical, Theme.Spacing.medium)
        .applyTabBarGlassEffect()
        .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.card))
        .padding(.horizontal, Theme.Spacing.medium)
        .padding(.bottom, Theme.Spacing.small)
    }

    private func tabButton(for tab: TabItem) -> some View {
        VStack(spacing: Theme.Spacing.small) {
            // Icon with enhanced glow for selected state
            if let iconImage = UIImage(named: tab.icon) {
                Image(uiImage: iconImage)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundColor(selectedTab == tab ? Theme.Colors.textPrimary : Theme.Colors.textSecondary)
                    .scaleEffect(selectedTab == tab ? 1.2 : 1.0)
                    .applyTabIconGlassEffect(isSelected: selectedTab == tab, tabId: tab.rawValue)
                    .liquidGlassGlow(
                        color: selectedTab == tab ? Theme.Colors.glowPrimary : Color.clear,
                        radius: selectedTab == tab ? 8 : 0,
                        intensity: selectedTab == tab ? 1.0 : 0.0
                    )
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab == tab)
            } else {
                Image(systemName: tab.systemIcon)
                    .font(.title2)
                    .foregroundColor(selectedTab == tab ? Theme.Colors.textPrimary : Theme.Colors.textSecondary)
                    .scaleEffect(selectedTab == tab ? 1.2 : 1.0)
                    .applyTabIconGlassEffect(isSelected: selectedTab == tab, tabId: tab.rawValue)
                    .liquidGlassGlow(
                        color: selectedTab == tab ? Theme.Colors.glowPrimary : Color.clear,
                        radius: selectedTab == tab ? 8 : 0,
                        intensity: selectedTab == tab ? 1.0 : 0.0
                    )
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab == tab)
            }

            // Tab title
            Text(tab.title)
                .font(Theme.Typography.caption)
                .fontWeight(selectedTab == tab ? .semibold : .medium)
                .foregroundColor(selectedTab == tab ? Theme.Colors.textPrimary : Theme.Colors.textSecondary)
                .scaleEffect(selectedTab == tab ? 1.1 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab == tab)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.small)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                selectedTab = tab
            }
        }
        .accessibilityLabel("\(tab.title) Tab")
        .accessibilityHint("Switches to the \(tab.title) section")
    }
}

// MARK: - iOS 18 Liquid Glass Helper Extensions

extension View {
    /// Apply tab bar glass effect with iOS 18 Liquid Glass
    func applyTabBarGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular, in: RoundedRectangle(cornerRadius: Theme.CornerRadius.card))
        } else {
            return self.navigationGlass()
        }
    }
    
    /// Apply tab icon glass effect with iOS 18 Liquid Glass
    func applyTabIconGlassEffect(isSelected: Bool, tabId: String) -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(
                isSelected ? 
                .regular.tint(Theme.Colors.textPrimary.opacity(0.3)) : 
                .regular.tint(Theme.Colors.textSecondary.opacity(0.2)), 
                in: Circle()
            )
            .glassEffectID("tab-icon-\(tabId)", in: Namespace().wrappedValue)
        } else {
            return self
        }
    }
}
