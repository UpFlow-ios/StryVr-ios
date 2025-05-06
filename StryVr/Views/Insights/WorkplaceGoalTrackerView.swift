//
//  WorkplaceGoalTrackerView.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25.
//  🎯 Track & Update Workplace Goals – Team & Individual Goals with Progress Bars
//

import SwiftUI

struct WorkplaceGoal: Identifiable {
    let id = UUID()
    let title: String
    var progress: Double // 0.0 to 1.0
    var completed: Bool
}

struct WorkplaceGoalTrackerView: View {
    @State private var goals: [WorkplaceGoal] = [
        WorkplaceGoal(title: "Improve Communication", progress: 0.6, completed: false),
        WorkplaceGoal(title: "Finish Product Launch Prep", progress: 0.9, completed: false),
        WorkplaceGoal(title: "Complete Feedback Reviews", progress: 1.0, completed: true)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    Text("🎯 Workplace Goals")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .padding(.top, Theme.Spacing.large)
                        .padding(.horizontal)

                    ForEach($goals) { $goal in
                        goalCard(goal: $goal)
                    }
                }
                .padding(.bottom)
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Goals")
        }
    }

    // MARK: - Reusable Goal Card
    private func goalCard(goal: Binding<WorkplaceGoal>) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            HStack {
                Text(goal.wrappedValue.title)
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()

                Button(action: {
                    withAnimation {
                        goal.wrappedValue.completed.toggle()
                        goal.wrappedValue.progress = goal.wrappedValue.completed ? 1.0 : 0.0
                    }
                }) {
                    Image(systemName: goal.completed.wrappedValue ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(goal.completed.wrappedValue ? .green : Theme.Colors.accent)
                }
                .accessibilityLabel("Mark \(goal.wrappedValue.title) as completed")
            }

            ProgressView(value: goal.wrappedValue.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: Theme.Colors.accent))
                .accessibilityLabel("\(Int(goal.wrappedValue.progress * 100))% complete")
        }
        .padding()
        .background(Theme.Colors.card)
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Theme.Colors.accent.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}

#Preview {
    WorkplaceGoalTrackerView()
}
