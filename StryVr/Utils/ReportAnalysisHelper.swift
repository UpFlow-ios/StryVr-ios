//
//  ReportAnalysisHelper.swift
//  StryVr
//
//  Created by Joe Dormond on 4/1/25.
//

import Foundation

struct ReportAnalysisHelper {
    static func calculateAverageSkillProgress(from reports: [LearningReport]) -> [String: Double] {
        var skillTotals: [String: [Double]] = [:]

        for report in reports {
            for (skill, progress) in report.skillsProgress {
                skillTotals[skill, default: []].append(progress)
            }
        }

        return skillTotals.mapValues { progresses in
            progresses.reduce(0, +) / Double(progresses.count)
        }
    }

    static func findTopUsers(from reports: [LearningReport]) -> [UserModel] {
        let sorted = reports.map { report -> UserModel in
            var user = report.user
            user.averageProgress = report.skillsProgress.values.reduce(0, +) / Double(report.skillsProgress.count)
            return user
        }.sorted(by: { $0.averageProgress > $1.averageProgress })

        return Array(sorted.prefix(5))
    }

    static func findWeakSkills(from reports: [LearningReport], threshold: Double) -> [String] {
        let averageSkills = calculateAverageSkillProgress(from: reports)
        return averageSkills.filter { $0.value < threshold }.map { $0.key }
    }
}
