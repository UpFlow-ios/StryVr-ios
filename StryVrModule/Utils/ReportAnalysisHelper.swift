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
    /// Calculates average progress for each skill across reports.
    /// - Parameter reports: `[LearningReport]` array.
    /// - Returns: `[String: Double]` skills dictionary with average progress.
    static func calculateAverageSkillProgress(from reports: [LearningReport]) -> [String: Double] {
        var skillTotals = [String: (total: Double, count: Int)]()

        for report in reports {
            for (skill, progress) in report.skillsProgress {
                skillTotals[skill, default: (0, 0)].total += progress
                skillTotals[skill, default: (0, 0)].count += 1
            }
        }

        let averages = skillTotals.compactMapValues { total, count -> Double? in
            guard !count.isZero else { return nil }
            let average = total / Double(count)
            logger.info(
                "📊 Skill \($0) average: \(average, format: .number.precision(.fractionLength(2)))")
            return average
        }

        return averages
    }

    /// Identifies top N users based on average skill progress.
    /// - Parameters:
    ///   - reports: `[LearningReport]` array.
    ///   - topCount: Number of top users, default is 5.
    /// - Returns: `[UserModel]` top users array.
    static func findTopUsers(from reports: [LearningReport], topCount: Int = 5) -> [UserModel] {
        var userProgress = [UserModel]()

        for report in reports {
            guard !report.skillsProgress.isEmpty else { continue }
            var user = report.user
            user.averageProgress =
                report.skillsProgress.values.reduce(0, +) / Double(report.skillsProgress.count)
            userProgress.append(user)
        }

        let sortedUsers = userProgress.sorted(by: { $0.averageProgress > $1.averageProgress })
        logger.info("🏅 Top \(topCount) users calculated.")

        return Array(sortedUsers.prefix(topCount))
    }

    /// Identifies weak skills below a specified threshold.
    /// - Parameters:
    ///   - reports: `[LearningReport]` array.
    ///   - threshold: Skill threshold, default is 50.0.
    /// - Returns: `[String]` weak skill names.
    static func findWeakSkills(from reports: [LearningReport], threshold: Double = 50.0) -> [String]
    {
        let weakSkills = calculateAverageSkillProgress(from: reports)
            .filter { $0.value < threshold }
            .map { $0.key }
            .sorted()

        logger.warning("⚠️ Weak skills: \(weakSkills.joined(separator: ", "))")
        return weakSkills
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
