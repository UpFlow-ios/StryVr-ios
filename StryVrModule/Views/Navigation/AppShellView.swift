//
//  AppShellView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/17/25.
//  🧭 Main App Shell with Tab Navigation & Dynamic Routing
//

import SwiftUI

/// Root-level app shell controlled by CustomTabBar and TabItem switching
struct AppShellView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab: TabItem = .home
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Active View
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView()

                    case .learning:
                        LearningPathsView()

                    case .community:
                        FriendLearningFeed()

                    case .profile:
                        if let user = authViewModel.currentUser {
                            ProfileView(user: user)
                        } else {
                            Text("Loading Profile...")
                                .foregroundColor(.gray)
                        }
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
