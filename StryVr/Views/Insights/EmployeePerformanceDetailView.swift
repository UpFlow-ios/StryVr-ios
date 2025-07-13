//
//  EmployeePerformanceDetailView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  📊 Employee Performance Detail – Comprehensive Performance Analytics
//

import Charts
import Foundation
import SwiftUI

struct EmployeePerformanceDetailView: View {
    let employeeName: String = "Alex Jordan"
    let completedGoals: Int = 22
    let totalGoals: Int = 30
    let challengeParticipation: Int = 5
    let achievementsUnlocked: Int = 3
    let dailyStreaks: [Int] = [1, 1, 0, 1, 1, 1, 1]

    var goalCompletionRate: Double {
        totalGoals == 0 ? 0 : Double(completedGoals) / Double(totalGoals) * 100
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                Text("📌 Performance: \(employeeName)")
                    .font(Theme.Typography.headline)
                    .padding(.top)

                // MARK: - Goal Completion Rate

                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text("🎯 Goal Completion")
                        .font(Theme.Typography.subheadline)

                    ProgressView(value: goalCompletionRate, total: 100)
                        .progressViewStyle(.linear)
                        .tint(.green)
                        .accessibilityLabel(
                            "Goal completion rate: \(Int(goalCompletionRate)) percent")

                    Text("\(completedGoals) of \(totalGoals) goals completed")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                .padding()
                .background(Theme.Colors.card)
                .cornerRadius(Theme.CornerRadius.medium)

                // MARK: - Challenge Participation

                dashboardCard(
                    title: "💪 Challenge Participation", value: "\(challengeParticipation) joined")

                // MARK: - Achievements Unlocked

                dashboardCard(title: "🏅 Achievements", value: "\(achievementsUnlocked) badges")

                // MARK: - Daily Consistency (Bar Chart)

                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text("📅 Daily Streak (Last 7 Days)")
                        .font(Theme.Typography.subheadline)

                    Chart {
                        ForEach(0..<dailyStreaks.count, id: \ .. self) { index in
                            BarMark(
                                x: .value("Day", index),
                                y: .value("Check-ins", dailyStreaks[index])
                            )
                            .foregroundStyle(dailyStreaks[index] > 0 ? .blue : .gray)
                        }
                    }
                    .frame(height: 150)
                }
                .padding()
                .background(Theme.Colors.card)
                .cornerRadius(Theme.CornerRadius.medium)

                Spacer(minLength: Theme.Spacing.large)
            }
            .padding()
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Employee Insights")
        }
    }

    // MARK: - Dashboard Card Builder

    private func dashboardCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            Text(title)
                .font(Theme.Typography.subheadline)
            Text(value)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding()
        .background(Theme.Colors.card)
        .cornerRadius(Theme.CornerRadius.medium)
    }
}

#Preview {
    EmployeePerformanceDetailView()
}
