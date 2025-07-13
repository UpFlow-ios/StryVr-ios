//
//  TeamHealthOverviewView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  📊 Team Health Overview – Wellness & Productivity Metrics
//

import Charts
import Foundation
import SwiftUI

struct TeamHealthOverviewView: View {
    @State private var teamStats: [TeamHealthStat] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    Text("📊 Team Health Overview")
                        .font(Theme.Typography.headline)
                        .padding(.horizontal)

                    if isLoading {
                        ProgressView("Loading team stats...")
                            .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                            .padding()
                    } else if let error = errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        healthChart
                        wellnessBreakdown
                    }
                }
                .padding(.bottom)
            }
            .background(Theme.Colors.background)
            .navigationTitle("Health Overview")
            .onAppear(perform: loadTeamHealthData)
        }
    }

    // MARK: - Health Progress Chart

    private var healthChart: some View {
        VStack(alignment: .leading) {
            Text("Overall Health Score")
                .font(Theme.Typography.subheadline)
                .padding(.horizontal)

            Chart {
                ForEach(teamStats, id: \._id) { stat in
                    LineMark(
                        x: .value("Week", stat.week),
                        y: .value("Score", stat.overallHealthScore)
                    )
                    .foregroundStyle(Theme.Colors.accent)
                }
            }
            .frame(height: 200)
            .padding(.horizontal)
            .background(Theme.Colors.card)
            .cornerRadius(Theme.CornerRadius.medium)
            .shadow(radius: 2)
        }
    }

    // MARK: - Category Breakdown

    private var wellnessBreakdown: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Category Breakdown")
                .font(Theme.Typography.subheadline)
                .padding(.horizontal)

            ForEach(teamStats.last?.categories ?? [], id: \.name) { category in
                VStack(alignment: .leading) {
                    Text(category.name)
                        .font(.caption)
                        .foregroundColor(Theme.Colors.textPrimary)

                    ProgressView(value: category.score / 100)
                        .tint(category.score >= 75 ? .green : category.score >= 50 ? .orange : .red)
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Load Data

    private func loadTeamHealthData() {
        TeamHealthService.shared.fetchWeeklyStats { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case let .success(stats):
                    self.teamStats = stats
                case let .failure(error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    TeamHealthOverviewView()
}
