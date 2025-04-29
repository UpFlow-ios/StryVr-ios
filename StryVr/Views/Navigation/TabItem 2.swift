//
//  TabItem 2.swift
//  StryVr
//
//  Created by Joe Dormond on 4/28/25.
//


//
//  CustomTabBar.swift
//  StryVr
//
//  🌳 Custom Tab Bar with Themed Icons and Smooth Transitions
//

import SwiftUI

/// Defines each tab item in the custom tab bar
enum TabItem: Int, CaseIterable {
    case home, learning, community, profile

    var title: String {
        switch self {
        case .home: return "Home"
        case .learning: return "Learn"
        case .community: return "Community"
        case .profile: return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .home: return "icon_home"
        case .learning: return "icon_learning"
        case .community: return "icon_community"
        case .profile: return "icon_profile"
        }
    }
}

/// Custom tab bar with dynamic selection and theme styling
struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: Theme.Spacing.large) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, Theme.Spacing.medium)
        .padding(.bottom, Theme.Spacing.small)
        .background(colorScheme == .dark ? Color.black : Theme.Colors.background)
        .cornerRadius(24)
        .shadow(color: Theme.Colors.accent.opacity(0.1), radius: 8, x: 0, y: -2)
    }

    private func tabButton(for tab: TabItem) -> some View {
        VStack(spacing: 4) {
            if let iconImage = UIImage(named: tab.icon) {
                Image(uiImage: iconImage)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundColor(selectedTab == tab ? Theme.Colors.accent : Theme.Colors.textSecondary)
            } else {
                Image(systemName: "questionmark.circle") // fallback icon
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.red)
            }

            Text(tab.title)
                .font(Theme.Typography.caption)
                .foregroundColor(selectedTab == tab ? Theme.Colors.accent : Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.small)
        .onTapGesture {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        }
        .accessibilityLabel("\(tab.title) Tab")
        .accessibilityHint("Switches to the \(tab.title) section")
    }
}
