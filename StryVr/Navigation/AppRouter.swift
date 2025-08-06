//
//  AppRouter.swift
//  StryVr
//
//  Created by Joe Dormond on 8/1/25.
//  🧭 Centralized navigation management for StryVr app
//

import SwiftUI
import Combine

/// Central navigation manager that handles app-wide routing and navigation state
@MainActor
final class AppRouter: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Navigation path that drives the NavigationStack
    @Published var path: NavigationPath = NavigationPath()
    
    /// Current navigation destination for UI state management
    @Published var currentDestination: AppDestination?
    
    /// Whether the navigation is in loading state
    @Published var isNavigating: Bool = false
    
    /// Navigation history for analytics and debugging
    @Published private(set) var navigationHistory: [AppDestination] = []
    
    // MARK: - Private Properties
    
    /// Maximum navigation history to keep in memory
    private let maxHistoryCount = 50
    
    /// Cancellables for Combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        setupNavigationObservation()
    }
    
    // MARK: - Navigation Methods
    
    /// Navigate to a specific destination
    func navigate(to destination: AppDestination) {
        isNavigating = true
        
        // Add to history
        addToHistory(destination)
        
        // Update current destination
        currentDestination = destination
        
        // Add to navigation path
        path.append(destination)
        
        // Reset loading state after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isNavigating = false
        }
    }
    
    /// Navigate back one level
    func navigateBack() {
        guard !path.isEmpty else { return }
        
        isNavigating = true
        path.removeLast()
        
        // Update current destination to previous one
        if let lastDestination = navigationHistory.dropLast().last {
            currentDestination = lastDestination
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isNavigating = false
        }
    }
    
    /// Navigate to root (clear entire navigation stack)
    func navigateToRoot() {
        isNavigating = true
        path = NavigationPath()
        currentDestination = .dashboard
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isNavigating = false
        }
    }
    
    /// Pop to a specific destination in the stack
    func popTo(destination: AppDestination) {
        // Find the destination in current path
        let pathArray = extractPathArray()
        
        if let index = pathArray.firstIndex(of: destination) {
            let itemsToRemove = pathArray.count - index - 1
            
            if itemsToRemove > 0 {
                isNavigating = true
                path.removeLast(itemsToRemove)
                currentDestination = destination
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.isNavigating = false
                }
            }
        }
    }
    
    /// Replace current destination (useful for authentication flows)
    func replace(with destination: AppDestination) {
        if !path.isEmpty {
            path.removeLast()
        }
        navigate(to: destination)
    }
    
    // MARK: - Deep Linking
    
    /// Handle deep link navigation
    func handleDeepLink(url: URL) {
        guard let destination = AppDestination.from(url: url) else {
            print("❌ Unable to parse deep link: \(url)")
            return
        }
        
        // Check if authentication is required
        if destination.requiresAuthentication {
            // TODO: Check authentication state and redirect to login if needed
            // For now, navigate directly
            navigate(to: destination)
        } else {
            navigate(to: destination)
        }
    }
    
    /// Generate shareable URL for current destination
    func generateShareURL() -> URL? {
        guard let current = currentDestination else { return nil }
        return current.toURL()
    }
    
    // MARK: - Navigation State Queries
    
    /// Check if we can navigate back
    var canNavigateBack: Bool {
        return !path.isEmpty
    }
    
    /// Get current path depth
    var pathDepth: Int {
        return extractPathArray().count
    }
    
    /// Check if specific destination is in current path
    func contains(destination: AppDestination) -> Bool {
        return extractPathArray().contains(destination)
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationObservation() {
        // Observe path changes for debugging and analytics
        $path
            .dropFirst()
            .sink { [weak self] newPath in
                self?.logNavigationChange()
            }
            .store(in: &cancellables)
    }
    
    private func addToHistory(_ destination: AppDestination) {
        navigationHistory.append(destination)
        
        // Trim history if it gets too long
        if navigationHistory.count > maxHistoryCount {
            navigationHistory.removeFirst(navigationHistory.count - maxHistoryCount)
        }
    }
    
    private func extractPathArray() -> [AppDestination] {
        // Extract destinations from NavigationPath
        // Note: This is a simplified version. NavigationPath doesn't expose its contents directly
        // In a real implementation, you might need to maintain a parallel array
        return navigationHistory.suffix(pathDepth)
    }
    
    private func logNavigationChange() {
        #if DEBUG
        print("🧭 Navigation changed - Path depth: \(pathDepth)")
        if let current = currentDestination {
            print("🧭 Current destination: \(current)")
        }
        #endif
    }
}

// MARK: - Navigation Convenience Methods

extension AppRouter {
    
    /// Quick navigation to common destinations
    func navigateToDashboard() {
        navigate(to: .dashboard)
    }
    
    func navigateToProfile(userId: String) {
        navigate(to: .profile(userId: userId))
    }
    
    func navigateToReports() {
        navigate(to: .reports)
    }
    
    func navigateToSettings() {
        navigate(to: .settings)
    }
    
    func navigateToSubscription() {
        navigate(to: .subscription)
    }
    
    /// Navigate to report detail with animation
    func navigateToReportDetail(reportId: String, userId: String) {
        navigate(to: .reportDetail(reportId: reportId, userId: userId))
    }
    
    /// Navigate to analytics with user context
    func navigateToAnalytics(userId: String) {
        navigate(to: .analytics(userId: userId))
    }
    
    /// Navigate to AI insights
    func navigateToAIInsights(userId: String) {
        navigate(to: .aiInsights(userId: userId))
    }
}

// MARK: - Analytics Integration

extension AppRouter {
    
    /// Track navigation for analytics
    private func trackNavigation(to destination: AppDestination) {
        // TODO: Integrate with your analytics service
        #if DEBUG
        print("📊 Analytics: Navigated to \(destination)")
        #endif
    }
    
    /// Get navigation analytics data
    func getNavigationAnalytics() -> [String: Any] {
        return [
            "current_destination": currentDestination?.title ?? "Unknown",
            "path_depth": pathDepth,
            "can_navigate_back": canNavigateBack,
            "navigation_history_count": navigationHistory.count
        ]
    }
}