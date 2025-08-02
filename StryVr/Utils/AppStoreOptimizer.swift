//
//  AppStoreOptimizer.swift
//  StryVr
//
//  📈 App Store Optimization & User Engagement Analytics
//  Tracks retention, engagement, and provides App Store insights
//

import Foundation
import OSLog
import SwiftUI

/// Professional App Store optimization and user engagement tracking
@MainActor
final class AppStoreOptimizer: ObservableObject {
    static let shared = AppStoreOptimizer()

    private let logger = Logger(subsystem: "com.stryvr.app", category: "AppStoreOptimizer")
    private let userDefaults = UserDefaults.standard

    // MARK: - Engagement Metrics

    @Published var sessionCount: Int = 0
    @Published var totalSessionTime: TimeInterval = 0
    @Published var averageSessionTime: TimeInterval = 0
    @Published var retentionRate: Double = 0.0

    private var sessionStartTime: Date?
    private var lastAppOpenDate: Date?

    // MARK: - App Store Metrics

    private let sessionCountKey = "app_session_count"
    private let totalSessionTimeKey = "app_total_session_time"
    private let lastAppOpenKey = "app_last_open_date"
    private let firstAppOpenKey = "app_first_open_date"

    private init() {
        loadMetrics()
        startSession()
    }

    // MARK: - Session Management

    func startSession() {
        sessionStartTime = Date()
        sessionCount += 1
        lastAppOpenDate = Date()

        // Track first app open
        if userDefaults.object(forKey: firstAppOpenKey) == nil {
            userDefaults.set(Date(), forKey: firstAppOpenKey)
            logger.info("🎉 First app launch recorded")
        }

        saveMetrics()
        logger.info("📱 Session #\(sessionCount) started")
    }

    func endSession() {
        guard let startTime = sessionStartTime else { return }

        let sessionDuration = Date().timeIntervalSince(startTime)
        totalSessionTime += sessionDuration

        // Update average session time
        averageSessionTime = totalSessionTime / Double(sessionCount)

        saveMetrics()
        logger.info("📱 Session ended - Duration: \(String(format: "%.1fs", sessionDuration))")

        sessionStartTime = nil
    }

    // MARK: - Retention Analytics

    func calculateRetentionRate() -> Double {
        guard let firstOpen = userDefaults.object(forKey: firstAppOpenKey) as? Date,
            let lastOpen = userDefaults.object(forKey: lastAppOpenKey) as? Date
        else {
            return 0.0
        }

        let daysSinceFirstOpen =
            Calendar.current.dateComponents([.day], from: firstOpen, to: Date()).day ?? 0
        let daysSinceLastOpen =
            Calendar.current.dateComponents([.day], from: lastOpen, to: Date()).day ?? 0

        if daysSinceFirstOpen == 0 { return 100.0 }

        // Simple retention calculation
        let retentionRate = max(
            0, 100 - (Double(daysSinceLastOpen) / Double(daysSinceFirstOpen) * 100))
        self.retentionRate = retentionRate

        return retentionRate
    }

    // MARK: - Feature Usage Tracking

    func trackFeatureUsage(_ feature: String) {
        let key = "feature_usage_\(feature)"
        let currentCount = userDefaults.integer(forKey: key)
        userDefaults.set(currentCount + 1, forKey: key)

        logger.info("📊 Feature used: \(feature) (Total: \(currentCount + 1))")
    }

    func getFeatureUsageCount(_ feature: String) -> Int {
        let key = "feature_usage_\(feature)"
        return userDefaults.integer(forKey: key)
    }

    // MARK: - User Engagement Score

    func calculateEngagementScore() -> Double {
        let sessionScore = min(Double(sessionCount) / 10.0, 1.0) * 30  // 30% weight
        let timeScore = min(averageSessionTime / 300.0, 1.0) * 40  // 40% weight (5 min = 100%)
        let retentionScore = retentionRate / 100.0 * 30  // 30% weight

        let totalScore = sessionScore + timeScore + retentionScore
        return min(totalScore, 100.0)
    }

    // MARK: - App Store Optimization

    func generateAppStoreInsights() -> [String: Any] {
        let insights: [String: Any] = [
            "total_sessions": sessionCount,
            "average_session_time": averageSessionTime,
            "retention_rate": retentionRate,
            "engagement_score": calculateEngagementScore(),
            "days_since_first_open": getDaysSinceFirstOpen(),
            "feature_usage": getTopUsedFeatures()
        ]

        logger.info("📈 App Store insights generated: \(insights)")
        return insights
    }

    private func getDaysSinceFirstOpen() -> Int {
        guard let firstOpen = userDefaults.object(forKey: firstAppOpenKey) as? Date else {
            return 0
        }
        return Calendar.current.dateComponents([.day], from: firstOpen, to: Date()).day ?? 0
    }

    private func getTopUsedFeatures() -> [String: Int] {
        let features = ["home", "profile", "challenges", "reports", "ai_coach"]
        var usage: [String: Int] = [:]

        for feature in features {
            usage[feature] = getFeatureUsageCount(feature)
        }

        return usage.sorted { $0.value > $1.value }.reduce(into: [:]) { result, element in
            result[element.key] = element.value
        }
    }

    // MARK: - Data Persistence

    private func saveMetrics() {
        userDefaults.set(sessionCount, forKey: sessionCountKey)
        userDefaults.set(totalSessionTime, forKey: totalSessionTimeKey)
        userDefaults.set(lastAppOpenDate, forKey: lastAppOpenKey)
    }

    private func loadMetrics() {
        sessionCount = userDefaults.integer(forKey: sessionCountKey)
        totalSessionTime = userDefaults.double(forKey: totalSessionTimeKey)
        lastAppOpenDate = userDefaults.object(forKey: lastAppOpenKey) as? Date

        if sessionCount > 0 {
            averageSessionTime = totalSessionTime / Double(sessionCount)
        }

        retentionRate = calculateRetentionRate()
    }
}

// MARK: - View Extensions

extension View {
    /// Track feature usage when view appears
    func trackFeatureUsage(_ feature: String) -> some View {
        self.onAppear {
            AppStoreOptimizer.shared.trackFeatureUsage(feature)
        }
    }

    /// Monitor view engagement
    func monitorEngagement() -> some View {
        self.onAppear {
            AppStoreOptimizer.shared.startSession()
        }
        .onDisappear {
            AppStoreOptimizer.shared.endSession()
        }
    }
}
