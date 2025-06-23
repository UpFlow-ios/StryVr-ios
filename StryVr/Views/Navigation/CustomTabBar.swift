//
//  CustomTabBar.swift
//  StryVr
//
//  Created by Joe Dormond on 4/28/25.
//  🧭 Custom tab bar with theme integration and tab switching.
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
                Image(systemName: "questionmark.circle")
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
