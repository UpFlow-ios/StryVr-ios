//
//  WorkplaceProgressTracker.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  📊 Workplace Progress Tracker – Pie Chart of Completed vs Missed Goals
//

import Charts
import Foundation
import SwiftUI

struct GoalProgress: Identifiable {
    let id = UUID()
    let category: String
    let count: Int
    let color: Color
}

struct WorkplaceProgressTracker: View {
    // MARK: - Sample Data

    let goalData: [GoalProgress] = [
        GoalProgress(category: "Completed", count: 42, color: .green),
        GoalProgress(category: "In Progress", count: 18, color: .orange),
        GoalProgress(category: "Missed", count: 10, color: .red),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    Text("📊 Progress Breakdown")
                        .font(Theme.Typography.headline)
                        .padding(.top, Theme.Spacing.large)
                        .padding(.horizontal)
                        .accessibilityLabel("Progress Breakdown Title")

                    // MARK: - Pie Chart

                    Chart(goalData) { item in
                        SectorMark(
                            angle: .value("Goals", item.count),
                            innerRadius: .ratio(0.6),
                            angularInset: 1.5
                        )
                        .foregroundStyle(item.color)
                        .cornerRadius(4)
                        .annotation(position: .center, alignment: .center) {
                            Text("\(item.category): \(item.count)")
                                .font(Theme.Typography.caption)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(height: 280)
                    .padding()
                    .background(Theme.Colors.card)
                    .cornerRadius(Theme.CornerRadius.medium)
                    .shadow(color: Theme.Colors.accent.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)

                    // MARK: - Breakdown Legend

                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(goalData) { item in
                            HStack {
                                Circle()
                                    .fill(item.color)
                                    .frame(width: 14, height: 14)
                                Text("\(item.category): \(item.count)")
                                    .font(Theme.Typography.body)
                                    .foregroundColor(Theme.Colors.textPrimary)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Workplace Progress")
        }
    }
}

#Preview {
    WorkplaceProgressTracker()
}
