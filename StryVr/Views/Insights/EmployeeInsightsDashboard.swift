//
//  EmployeeInsightsDashboard.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25.
//  📊 Unified Dashboard – Team Health, Behavior, Goals, Feedback Access
//

import SwiftUI

struct EmployeeInsightsDashboard: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    // MARK: - Title

                    Text("📊 Employee Insights")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .padding(.top, Theme.Spacing.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // MARK: - Team Health Overview

                    NavigationLink(destination: TeamHealthOverviewView()) {
                        insightsCard(
                            title: "❤️ Team Health Overview",
                            description: "Visualize wellness & performance trends",
                            systemIcon: "waveform.path.ecg"
                        )
                    }

                    // MARK: - Workplace Goal Tracker

                    NavigationLink(destination: WorkplaceGoalTrackerView()) {
                        insightsCard(
                            title: "🎯 Goal Tracker",
                            description: "Track active employee goals & progress",
                            systemIcon: "target"
                        )
                    }

                    // MARK: - Feedback History

                    NavigationLink(
                        destination: FeedbackHistoryView(employeeId: "example_employee_id")
                    ) {
                        insightsCard(
                            title: "🧾 Feedback History",
                            description: "View recent feedback submitted for employees",
                            systemIcon: "doc.plaintext"
                        )
                    }

                    // MARK: - Progress Timeline

                    NavigationLink(
                        destination: EmployeeProgressTimelineView(employeeId: "example_employee_id")
                    ) {
                        insightsCard(
                            title: "🕒 Progress Timeline",
                            description: "View employee milestones, feedback & achievements",
                            systemIcon: "calendar"
                        )
                    }
                }
                .padding(.horizontal)
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Team Insights")
        }
    }

    // MARK: - Card Component

    private func insightsCard(title: String, description: String, systemIcon: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: Theme.Spacing.xSmall) {
                Text(title)
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(description)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Spacer()

            if systemIcon == "target" {
                Image(systemName: systemIcon)
                    .foregroundColor(Theme.Colors.accent)
                    .font(.title2)
                    .animateSymbol(true, type: "bounce")
                    .shadow(color: .blue.opacity(0.5), radius: 10)
            } else {
                Image(systemName: systemIcon)
                    .foregroundColor(Theme.Colors.accent)
                    .font(.title2)
            }
        }
        .padding()
        .background(Theme.Colors.card)
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Theme.Colors.accent.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    EmployeeInsightsDashboard()
        .environmentObject(AuthViewModel.previewMock)
}
