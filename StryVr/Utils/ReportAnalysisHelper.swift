//
//  ReportAnalysisHelper.swift
//  StryVr
//
//  Created by Joe Dormond on 4/1/25.
//  📊 Optimized for Performance, Scalability, and Clarity
//

import Foundation
import OSLog

private let logger = Logger(subsystem: "com.stryvr.app", category: "ReportAnalysis")

// MARK: - ReportAnalysisHelper

enum ReportAnalysisHelper {
    /// Calculates average performance score across reports.
    /// - Parameter reports: `[LearningReport]` array.
    /// - Returns: `Double` average performance score.
    static func calculateAveragePerformanceScore(from reports: [LearningReport]) -> Double {
        guard !reports.isEmpty else { return 0.0 }

        let totalScore = reports.reduce(0.0) { $0 + $1.performanceScore }
        let average = totalScore / Double(reports.count)

        logger.info(
            "📊 Average performance score: \(average, format: .number.precision(.fractionLength(2)))"
        )
        return average
    }

    /// Identifies top N employees based on performance score.
    /// - Parameters:
    ///   - reports: `[LearningReport]` array.
    ///   - topCount: Number of top employees, default is 5.
    /// - Returns: `[LearningReport]` top employees array.
    static func getTopPerformers(from reports: [LearningReport], topCount: Int = 5) -> [LearningReport] {
        return
            reports
            .sorted { $0.performanceScore > $1.performanceScore }
            .prefix(topCount)
            .map { $0 }
    }

    /// Calculates total learning hours across all reports.
    /// - Parameter reports: `[LearningReport]` array.
    /// - Returns: `Double` total learning hours.
    static func calculateTotalLearningHours(from reports: [LearningReport]) -> Double {
        let totalHours = reports.reduce(0.0) { $0 + $1.learningHours }
        logger.info(
            "📊 Total learning hours: \(totalHours, format: .number.precision(.fractionLength(1)))")
        return totalHours
    }

    /// Calculates average completion rate across reports.
    /// - Parameter reports: `[LearningReport]` array.
    /// - Returns: `Double` average completion rate (0.0 to 1.0).
    static func calculateAverageCompletionRate(from reports: [LearningReport]) -> Double {
        guard !reports.isEmpty else { return 0.0 }

        let totalCompletionRate = reports.reduce(0.0) { $0 + $1.completionRate }
        let average = totalCompletionRate / Double(reports.count)

        logger.info(
            "📊 Average completion rate: \(average, format: .number.precision(.fractionLength(2)))")
        return average
    }
}

// MARK: - Collection Extension for Clarity

extension Collection {
    /// Allows inline logging and chaining within closures.
    @discardableResult
    func also(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}
