//
//  WorkplaceGoalTrackerView.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25.
//  ✅ Workplace Goal Tracker – Progress & Deadlines for Professional Growth
//

import SwiftUI

struct WorkplaceGoal: Identifiable {
    let id = UUID()
    let title: String
    let progress: Double // 0.0 - 1.0
    let dueDate: Date
}

struct WorkplaceGoalTrackerView: View {
    // MARK: - Placeholder Data
    @State private var goals: [WorkplaceGoal] = [
        WorkplaceGoal(title: "Submit Project Report", progress: 0.9, dueDate: .now.addingTimeInterval(86400)),
        WorkplaceGoal(title: "Complete Compliance Training", progress: 0.4, dueDate: .now.addingTimeInterval(-86400 * 2)),
        WorkplaceGoal(title: "Meet Quarterly Sales Target", progress: 0.7, dueDate: .now.addingTimeInterval(86400 * 10))
    ]

    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                Text("🎯 Workplace Goals")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.top)

                ForEach(goals) { goal in
                    VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                        HStack {
                            Text(goal.title)
                                .font(Theme.Typography.body)
                                .foregroundColor(Theme.Colors.textPrimary)

                            Spacer()

                            Text(goal.dueDate < Date() ? "Overdue" : dateFormatter.string(from: goal.dueDate))
                                .font(Theme.Typography.caption)
                                .foregroundColor(goal.dueDate < Date() ? .red : Theme.Colors.textSecondary)
                        }

                        ProgressView(value: goal.progress)
                            .tint(goal.progress < 0.5 ? .orange : Theme.Colors.accent)
                            .frame(height: 10)
                            .background(Theme.Colors.card.opacity(0.3))
                            .clipShape(Capsule())

                        Text("\(Int(goal.progress * 100))% Complete")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    .padding()
                    .background(Theme.Colors.card)
                    .cornerRadius(Theme.CornerRadius.medium)
                    .shadow(color: Theme.Colors.accent.opacity(0.05), radius: 4, x: 0, y: 2)
                }
            }
            .padding()
        }
        .background(Theme.Colors.background.ignoresSafeArea())
        .navigationTitle("Goal Tracker")
    }
}

#Preview {
    WorkplaceGoalTrackerView()
}
