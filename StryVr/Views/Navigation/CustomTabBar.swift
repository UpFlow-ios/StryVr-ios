//
//  CustomTabBar.swift
//  StryVr
//
//  Created by Joe Dormond on 3/5/25.
//  🧭 Custom Navigation Tab Bar with Branded Icons & Theme Integration
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
        case .home: return "icon_home"        // Replace with custom asset
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

    var backgroundColor: Color = Color.white
    var cornerRadius: CGFloat = 16

    var body: some View {
        HStack(spacing: Theme.Spacing.large) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                VStack(spacing: 4) {
                    if let iconImage = UIImage(named: tab.icon) {
                        Image(uiImage: iconImage)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundColor(selectedTab == tab ? Theme.Colors.accent : Theme.Colors.textSecondary)
                    } else {
                        Image(systemName: "questionmark.circle") // Fallback icon
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.red)
                    }

                    Text(tab.title)
                        .font(Theme.Typography.caption)
                        .foregroundColor(selectedTab == tab ? Theme.Colors.accent : Theme.Colors.textSecondary)
                        .accessibilityLabel("\(tab.title) Tab")
                        .accessibilityHint("Switches to the \(tab.title) section")
                }
                .padding(.vertical, Theme.Spacing.small)
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, Theme.Spacing.medium)
        .padding(.bottom, Theme.Spacing.small)
        .background(colorScheme == .dark ? Color.black : backgroundColor)
        .cornerRadius(cornerRadius)
        .shadow(color: Theme.Colors.accent.opacity(0.08), radius: 6, x: 0, y: -2)
    }
}
