```swift
//
//  ReportAnalysisHelper.swift
//  StryVr
//
//  Created by Joe Dormond on 4/1/25.
//  📊 Optimized for Performance, Scalability, and Clarity
//

import Foundation
import os.log

struct ReportAnalysisHelper {
    
    /// Calculates average progress for each skill across all reports
    /// - Parameter reports: Array of `LearningReport`
    /// - Returns: Dictionary with skills as keys and average progress as values
    static func calculateAverageSkillProgress(from reports: [LearningReport]) -> [String: Double] {
        var skillProgressTotals = [String: [Double]]()
        
        reports.forEach { report in
            report.skillsProgress.forEach { skill, progress in
                skillProgressTotals[skill, default: []].append(progress)
            }
        }
        
        let averageProgress = skillProgressTotals.reduce(into: [String: Double]()) { result, entry in
            let (skill, progresses) = entry
            guard !progresses.isEmpty else {
                result[skill] = 0.0
                return
            }
            let average = progresses.reduce(0, +) / Double(progresses.count)
            os_log("📊 Skill %{public}@ average progress: %{public}.2f", skill, average)
            result[skill] = average
        }
        
        return averageProgress
    }
    
    /// Identifies the top N users based on their average skill progress
    /// - Parameters:
    ///   - reports: Array of `LearningReport`
    ///   - topCount: Number of top users to return (default 5)
    /// - Returns: Array of top `UserModel` objects
    static func findTopUsers(from reports: [LearningReport], topCount: Int = 5) -> [UserModel] {
        let userProgress: [UserModel] = reports.compactMap { report in
            guard !report.skillsProgress.isEmpty else { return nil }
            var user = report.user
            user.averageProgress = report.skillsProgress.values.reduce(0, +) / Double(report.skillsProgress.count)
            return user
        }
        
        let sortedUsers = userProgress.sorted(by: { $0.averageProgress > $1.averageProgress })
        os_log("🏅 Top %{public}d users calculated.", topCount)
        
        return Array(sortedUsers.prefix(topCount))
    }
    
    /// Finds skills below a specified threshold across reports
    /// - Parameters:
    ///   - reports: Array of `LearningReport`
    ///   - threshold: The skill-progress threshold (e.g., 50.0)
    /// - Returns: Array of skill names below threshold
    static func findWeakSkills(from reports: [LearningReport], threshold: Double = 50.0) -> [String] {
        let averageSkills = calculateAverageSkillProgress(from: reports)
        let weakSkills = averageSkills.filter { $0.value < threshold }.map { $0.key }
        
        os_log("⚠️ Weak skills identified: %{public}@", weakSkills.joined(separator: ", "))
        
        return weakSkills
    }
}

