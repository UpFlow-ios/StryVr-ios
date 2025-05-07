//
//  FeedbackSummaryService.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25.
//  📊 Feedback Summary Engine – Categorized Ratings, Trend Flags, AI-Ready
//

import Foundation

struct FeedbackSummary {
    let employeeId: String
    let categoryAverages: [FeedbackCategory: Double]
    let flaggedCategories: [FeedbackCategory]
    let overallAverage: Double
}

final class FeedbackSummaryService {

    static func generateSummary(from feedbacks: [BehaviorFeedback], for employeeId: String, threshold: Double = 3.0) -> FeedbackSummary {
        let filtered = feedbacks.filter { $0.employeeId == employeeId }

        var categoryTotals: [FeedbackCategory: [Int]] = [:]

        for feedback in filtered {
            categoryTotals[feedback.category, default: []].append(feedback.rating)
        }

        var categoryAverages: [FeedbackCategory: Double] = [:]
        var flaggedCategories: [FeedbackCategory] = []

        for (category, ratings) in categoryTotals {
            let average = Double(ratings.reduce(0, +)) / Double(ratings.count)
            categoryAverages[category] = average

            if average < threshold {
                flaggedCategories.append(category)
            }
        }

        let allRatings = filtered.map { $0.rating }
        let overallAverage = allRatings.isEmpty ? 0.0 : Double(allRatings.reduce(0, +)) / Double(allRatings.count)

        return FeedbackSummary(
            employeeId: employeeId,
            categoryAverages: categoryAverages,
            flaggedCategories: flaggedCategories,
            overallAverage: overallAverage
        )
    }
}
