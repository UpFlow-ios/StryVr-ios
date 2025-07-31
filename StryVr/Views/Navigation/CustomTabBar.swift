//
//  CustomTabBar.swift
//  StryVr
//
//  Created by Joe Dormond on 4/28/25.
//  🧭 Custom tab bar with Liquid Glass + Apple Glow UI
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: Theme.Spacing.large) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, Theme.Spacing.large)
        .padding(.vertical, Theme.Spacing.medium)
        .navigationGlass()
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

// MARK: - TabItem Extension for System Icons

extension TabItem {
    var systemIcon: String {
        switch self {
        case .home:
            return "house.fill"
        case .feed:
            return "list.bullet"
        case .profile:
            return "person.fill"
        case .reports:
            return "chart.bar.fill"
        }
    }
}
