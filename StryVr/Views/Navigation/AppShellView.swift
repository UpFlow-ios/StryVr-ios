//
//  AppShellView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/17/25.
//  🧭 Main App Shell with Liquid Glass + Apple Glow UI
//

import SwiftUI

/// Root-level app shell controlled by CustomTabBar and TabItem switching
struct AppShellView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab: TabItem = .home
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            // MARK: - Dark Gradient Background
            
            Theme.LiquidGlass.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Active View

                Group {
                    switch selectedTab {
                    case .home:
                        HomeView()
                            .environmentObject(authViewModel)

                    case .feed:
                        FriendLearningFeed()
                            .environmentObject(authViewModel)

                    case .profile:
                        ProfileView()
                            .environmentObject(authViewModel)

                    case .reports:
                        ReportsDashboardView()
                            .environmentObject(authViewModel)
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.25), value: selectedTab)

                // MARK: - Custom Tab Bar

                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}
