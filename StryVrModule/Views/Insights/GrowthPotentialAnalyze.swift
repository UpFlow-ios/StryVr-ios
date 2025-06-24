//
//  GrowthPotentialAnalyze.swift
//  StryVr
//
//  📈 Growth Potential Analyzer – Scores employee growth capacity based on performance & trends
//

import Charts
import SwiftUI

struct GrowthPotentialAnalyzer: View {
    @State private var potentialScore: Double = 0.0
    @State private var feedbackAverage: Double = 0.0
    @State private var achievementCount: Int = 0
    @State private var progressConsistency: Double = 0.0

    @State private var isLoading = true
    @State private var errorMessage: String?

    let employeeId: String

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    Text("📈 Growth Potential")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if isLoading {
                        ProgressView("Calculating growth potential...")
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    } else {
                        Group {
                            growthScoreCard
                            breakdownChart
                        }
                        .transition(.opacity)
                    }
                }
                .padding()
            }
            .navigationTitle("Potential Analyzer")
            .background(Theme.Colors.background.ignoresSafeArea())
            .onAppear(perform: analyzeGrowthPotential)
        }
    }

    // MARK: - Growth Score Card

    private var growthScoreCard: some View {
        VStack(spacing: Theme.Spacing.small) {
            Text("Overall Score")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
            Text("\(Int(potentialScore)) / 100")
                .font(Theme.Typography.largeTitle)
                .foregroundColor(potentialScore >= 80 ? .green : .orange)
            Text("Higher scores indicate stronger potential based on feedback, consistency, and goals.")
                .font(Theme.Typography.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Theme.Colors.card)
        .cornerRadius(Theme.CornerRadius.medium)
    }

    // MARK: - Chart Breakdown

    private var breakdownChart: some View {
        VStack(alignment: .leading) {
            Text("Score Breakdown")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textPrimary)

            Chart {
                BarMark(
                    x: .value("Category", "Feedback Avg"),
                    y: .value("Score", feedbackAverage * 20)
                )
                BarMark(
                    x: .value("Category", "Achievements"),
                    y: .value("Score", Double(achievementCount) * 10)
                )
                BarMark(
                    x: .value("Category", "Consistency"),
                    y: .value("Score", progressConsistency)
                )
            }
            .frame(height: 220)
        }
        .padding()
        .background(Theme.Colors.card)
        .cornerRadius(Theme.CornerRadius.medium)
    }

    // MARK: - Simulated Analysis

    private func analyzeGrowthPotential() {
        isLoading = true

        // 🔧 Simulated logic (replace with Firestore logic as needed)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            feedbackAverage = 4.2 // from feedback service
            achievementCount = 5 // from achievement model
            progressConsistency = 75.0 // consistency index

            // 🚀 Calculated score logic
            potentialScore = (
                (feedbackAverage / 5.0) * 40 +
                    Double(achievementCount) * 10 +
                    progressConsistency * 0.5
            ).rounded()

            isLoading = false
        }
    }
}

#Preview {
    GrowthPotentialAnalyzer(employeeId: "abc123")
}
