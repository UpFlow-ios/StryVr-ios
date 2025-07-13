//
//  FeedbackTrendsView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  📊 Feedback Trends View – Historical Feedback Analysis & Patterns
//

import Charts
import Foundation
import SwiftUI

struct FeedbackTrendsView: View {
    // MARK: - Sample Data (replace with Firestore fetch later)

    private let sampleFeedback: [BehaviorFeedback] = [
        .init(
            employeeId: "1", reviewerId: "x", category: .communication, rating: 4, comment: "",
            isAnonymous: false),
        .init(
            employeeId: "2", reviewerId: "y", category: .clarity, rating: 2, comment: "",
            isAnonymous: true),
        .init(
            employeeId: "3", reviewerId: "z", category: .collaboration, rating: 5, comment: "",
            isAnonymous: false),
        .init(
            employeeId: "4", reviewerId: "x", category: .communication, rating: 3, comment: "",
            isAnonymous: true),
        .init(
            employeeId: "5", reviewerId: "y", category: .responsiveness, rating: 2, comment: "",
            isAnonymous: false),
        .init(
            employeeId: "6", reviewerId: "z", category: .clarity, rating: 1, comment: "",
            isAnonymous: true),
    ]

    private var averageRatings: [(category: FeedbackCategory, average: Double)] {
        let grouped = Dictionary(grouping: sampleFeedback, by: { $0.category })

        return grouped.map { category, entries in
            let avg = entries.map { Double($0.rating) }.reduce(0, +) / Double(entries.count)
            return (category, avg)
        }
        .sorted { $0.average < $1.average }  // Show weakest areas first
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                Text("📊 Behavior Feedback Trends")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.top)

                if averageRatings.isEmpty {
                    Text("No feedback available yet.")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .padding()
                } else {
                    Chart {
                        ForEach(averageRatings, id: \.category) { entry in
                            BarMark(
                                x: .value("Category", entry.category.displayName),
                                y: .value("Avg Rating", entry.average)
                            )
                            .foregroundStyle(entry.average < 3 ? .red : Theme.Colors.accent)
                            .annotation(position: .top) {
                                Text(String(format: "%.1f", entry.average))
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .frame(height: 280)
                    .padding()
                    .background(Theme.Colors.card)
                    .cornerRadius(Theme.CornerRadius.medium)
                    .shadow(radius: 3)
                }
            }
            .padding()
        }
        .background(Theme.Colors.background.ignoresSafeArea())
        .navigationTitle("Feedback Trends")
    }
}

#Preview {
    FeedbackTrendsView()
}
