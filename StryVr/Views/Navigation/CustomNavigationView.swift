//
//  CustomNavigationView.swift
//  StryVr
//
//  🌳 Real Tab Navigation Controller with Custom TabBar Integration
//

import SwiftUI

struct CustomNavigationView: View {
    @State private var selectedTab: TabItem = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            Theme.Colors.background.ignoresSafeArea()

            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .feed:
                    LearningPathsView()
                case .profile:
                    ProfileView()
                case .reports:
                    ReportsView()
                }
            }
            .transition(.opacity)
            .animation(.easeInOut, value: selectedTab)

            CustomTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, Theme.Spacing.large)
                .padding(.bottom, Theme.Spacing.small)
        }
    }
}
