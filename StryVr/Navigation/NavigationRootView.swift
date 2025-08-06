//
//  NavigationRootView.swift
//  StryVr
//
//  Created by Joe Dormond on 8/1/25.
//  🧭 Root navigation view that manages authentication flow and main app navigation
//

import SwiftUI

/// Root navigation view that coordinates between authentication flow and main app navigation
struct NavigationRootView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var authViewModel: AuthViewModel
    
    /// Navigation coordinator for view creation
    @State private var coordinator: NavigationCoordinator
    
    init() {
        self._coordinator = State(initialValue: NavigationCoordinator(router: AppRouter()))
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            rootView
                .navigationDestination(for: AppDestination.self) { destination in
                    coordinator.view(for: destination)
                        .navigationBarTitleDisplayMode(.large)
                        .environmentObject(router)
                        .environmentObject(authViewModel)
                }
        }
        .onAppear {
            // Update coordinator with the actual router from environment
            coordinator = NavigationCoordinator(router: router)
            
            // Set initial destination based on auth state
            if authViewModel.isAuthenticated {
                router.currentDestination = .dashboard
            } else {
                router.currentDestination = .login
            }
        }
        .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                // User just logged in - navigate to dashboard
                router.navigateToRoot()
                router.navigate(to: .dashboard)
            } else {
                // User logged out - navigate to login
                router.navigateToRoot()
                router.navigate(to: .login)
            }
        }
    }
    
    /// Determines the root view based on authentication state
    @ViewBuilder
    private var rootView: some View {
        if authViewModel.isAuthenticated {
            // Main app - start with dashboard
            MainAppView()
                .environmentObject(router)
                .environmentObject(authViewModel)
        } else {
            // Authentication flow
            AuthenticationFlowView()
                .environmentObject(router)
                .environmentObject(authViewModel)
        }
    }
}

// MARK: - Main App View

/// Main app container with tab-based navigation
private struct MainAppView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            // Dashboard Tab
            DashboardTabView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Dashboard")
                }
                .tag(0)
            
            // Reports Tab
            ReportsTabView()
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Reports")
                }
                .tag(1)
            
            // AI Insights Tab
            AIInsightsTabView()
                .tabItem {
                    Image(systemName: "brain.head.profile.fill")
                    Text("AI Insights")
                }
                .tag(2)
            
            // Profile Tab
            ProfileTabView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .background(.ultraThinMaterial)
        .liquidGlassDepth()
    }
}

// MARK: - Tab Views

private struct DashboardTabView: View {
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text("Dashboard")
                        .font(Theme.Typography.largeTitle)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text("Welcome back to StryVr")
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                
                Spacer()
                
                Button {
                    router.navigateToSettings()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(Theme.Colors.textPrimary)
                }
                .liquidGlassButton()
            }
            .padding(.horizontal)
            
            // Quick Actions
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Reports Card
                    QuickActionCard(
                        title: "View Reports",
                        subtitle: "See your performance analytics",
                        icon: "doc.text.fill",
                        action: {
                            router.navigateToReports()
                        }
                    )
                    
                    // Analytics Card
                    QuickActionCard(
                        title: "Analytics",
                        subtitle: "Deep dive into your metrics",
                        icon: "chart.line.uptrend.xyaxis",
                        action: {
                            router.navigateToAnalytics(userId: "current_user")
                        }
                    )
                    
                    // AI Insights Card
                    QuickActionCard(
                        title: "AI Insights",
                        subtitle: "Get personalized recommendations",
                        icon: "brain.head.profile",
                        action: {
                            router.navigateToAIInsights(userId: "current_user")
                        }
                    )
                    
                    // Subscription Card
                    QuickActionCard(
                        title: "Subscription",
                        subtitle: "Manage your StryVr plan",
                        icon: "crown.fill",
                        action: {
                            router.navigateToSubscription()
                        }
                    )
                }
                .padding(.horizontal)
            }
        }
        .background(
            LinearGradient(
                colors: [Theme.Colors.deepNavyBlue, Theme.Colors.subtleLightGray],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

private struct ReportsTabView: View {
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        VStack {
            Text("Reports")
                .font(Theme.Typography.largeTitle)
                .foregroundColor(Theme.Colors.textPrimary)
            
            // This will be replaced by your actual ReportsView
            Button("View Sample Report") {
                router.navigateToReportDetail(reportId: "sample_report", userId: "current_user")
            }
            .liquidGlassButton()
        }
        .background(
            LinearGradient(
                colors: [Theme.Colors.deepNavyBlue, Theme.Colors.subtleLightGray],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

private struct AIInsightsTabView: View {
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        VStack {
            Text("AI Insights")
                .font(Theme.Typography.largeTitle)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Button("Get AI Recommendations") {
                router.navigateToPersonalizedRecommendations(userId: "current_user")
            }
            .liquidGlassButton()
        }
        .background(
            LinearGradient(
                colors: [Theme.Colors.deepNavyBlue, Theme.Colors.subtleLightGray],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

private struct ProfileTabView: View {
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(Theme.Typography.largeTitle)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Button("View Profile") {
                router.navigateToProfile(userId: "current_user")
            }
            .liquidGlassButton()
        }
        .background(
            LinearGradient(
                colors: [Theme.Colors.deepNavyBlue, Theme.Colors.subtleLightGray],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

// MARK: - Authentication Flow

private struct AuthenticationFlowView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            // App Logo
            Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(Theme.Colors.neonBlue)
                .liquidGlassGlow(color: Theme.Colors.glowPrimary, radius: 20)
            
            // App Title
            VStack(spacing: 8) {
                Text("StryVr")
                    .font(Theme.Typography.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text("AI-Powered Professional Development")
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Authentication Buttons
            VStack(spacing: 16) {
                Button {
                    // TODO: Implement actual login logic
                    authViewModel.signIn(email: "demo@stryvr.com", password: "demo123")
                } label: {
                    HStack {
                        Text("Sign In")
                            .font(Theme.Typography.buttonText)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                    .padding()
                }
                .liquidGlassButton()
                
                Button {
                    router.navigate(to: .signup)
                } label: {
                    HStack {
                        Text("Create Account")
                            .font(Theme.Typography.buttonText)
                            .foregroundColor(Theme.Colors.textSecondary)
                        
                        Spacer()
                        
                        Image(systemName: "person.badge.plus")
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    .padding()
                }
                .liquidGlassCard()
            }
            .padding(.horizontal)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Theme.Colors.deepNavyBlue, Theme.Colors.subtleLightGray],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

// MARK: - Quick Action Card Component

private struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(Theme.Colors.neonBlue)
                    .frame(width: 40, height: 40)
                    .background(Theme.Colors.glassPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Theme.Typography.subheadline)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text(subtitle)
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            .padding()
        }
        .liquidGlassCard()
    }
}