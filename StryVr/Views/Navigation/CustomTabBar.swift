//
//  CustomTabBar.swift
//  StryVr
//
//  Created by Joe Dormond on 3/5/25.
//  🧭 Custom Tab Navigation – Themed, Accessible, Scalable
//

import SwiftUI

/// A model representing a tab item
struct TabItem: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let index: Int
}

/// A custom tab bar styled for StryVr with theming and accessibility
struct CustomTabBar: View {
    @Binding var selectedTab: Int

    private let tabItems: [TabItem] = [
        TabItem(icon: "house.fill", label: "Home", index: 0),
        TabItem(icon: "person.fill", label: "Profile", index: 1)
        // ✅ Add more: TabItem(icon: "chart.bar.fill", label: "Reports", index: 2), etc.
    ]

    var body: some View {
        HStack(spacing: Theme.Spacing.large) {
            ForEach(tabItems) { item in
                Button(action: {
                    withAnimation {
                        selectedTab = item.index
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: item.icon)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(selectedTab == item.index ? Theme.Colors.accent : Theme.Colors.textSecondary)

                        Text(item.label)
                            .font(.caption)
                            .foregroundColor(selectedTab == item.index ? Theme.Colors.accent : Theme.Colors.textSecondary)
                    }
                    .accessibilityLabel("\(item.label) tab")
                    .accessibilityHint("Switches to the \(item.label) tab")
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, Theme.Spacing.medium)
        .padding(.horizontal)
        .background(Theme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.large))
        .shadow(color: Theme.Colors.textSecondary.opacity(0.1), radius: 4, x: 0, y: -2)
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(0))
}
