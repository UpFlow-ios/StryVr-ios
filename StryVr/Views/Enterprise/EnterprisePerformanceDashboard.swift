//
//  EnterprisePerformanceDashboard.swift
//  StryVr
//
//  🏢 Enterprise Performance & Analytics
//

import Foundation
import SwiftUI
import Charts

struct EnterprisePerformanceDashboard: View {
    @State private var employeeReports: [LearningReport] = []
    @State private var errorMessage: String?

    // MARK: - Computed Analytics

    private var averageProgressByCategory: [String: Double] {
        ReportAnalysisHelper.calculateAverageSkillProgress(from: employeeReports)
    }

    private var topContributors: [UserModel] {
        ReportAnalysisHelper.findTopUsers(from: employeeReports)
    }

    private var teamWeaknesses: [String] {
        ReportAnalysisHelper.findWeakSkills(from: employeeReports, threshold: 60)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    Text("📈 Team Performance Overview")
                        .font(Theme.Typography.headline)
                        .padding(.top, Theme.Spacing.medium)
                        .padding(.horizontal)

                    // MARK: - Skill Progress Chart

                    if !averageProgressByCategory.isEmpty {
                        Group {
                            Text("Average Progress by Area")
                                .font(Theme.Typography.subheadline)
                                .padding(.horizontal)

                            Chart {
                                ForEach(
                                    averageProgressByCategory.sorted(by: { $0.key < $1.key }),
                                    id: \.0
                                ) { skill, avg in
                                    BarMark(
                                        x: .value("Skill", skill),
                                        y: .value("Avg", avg)
                                    )
                                    .foregroundStyle(Theme.Colors.accent)
                                }
                            }
                            .frame(height: 240)
                            .padding(.horizontal)
                            .background(Theme.Colors.card)
                            .cornerRadius(Theme.CornerRadius.medium)
                            .shadow(radius: 2)
                        }
                    } else if errorMessage == nil {
                        Text("No data available.")
                            .foregroundColor(.secondary)
                            .padding()
                    }

                    // MARK: - Top Contributors

                    if !topContributors.isEmpty {
                        Group {
                            Text("🏅 Top Contributors")
                                .font(Theme.Typography.subheadline)
                                .padding(.horizontal)

                            ForEach(topContributors.prefix(3)) { user in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(user.name)
                                            .font(.headline)
                                        Text(
                                            "Avg Score: \(String(format: "%.1f", user.averageProgress))%"
                                        )
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            }
                        }
                    } else if errorMessage == nil {
                        Text("No top contributors yet.")
                            .foregroundColor(.secondary)
                            .padding()
                    }

                    // MARK: - Team Weaknesses

                    if !teamWeaknesses.isEmpty {
                        Group {
                            Text("⚠️ Areas for Improvement")
                                .font(Theme.Typography.subheadline)
                                .padding(.horizontal)

                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(teamWeaknesses, id: \.self) { skill in
                                    Text("• \(skill)")
                                        .font(.subheadline)
                                        .foregroundColor(.orange)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // MARK: - Error

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding(.bottom)
            }
            .background(Theme.Colors.background)
            .navigationTitle("Insights")
            .onAppear(perform: loadReports)
        }
    }

    // MARK: - Load Reports

    private func loadReports() {
        errorMessage = nil
        ReportGeneration.shared.fetchTeamReports { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(reports):
                    self.employeeReports = reports
                case .failure:
                    self.errorMessage = "⚠️ Could not load data. Try again later."
                }
            }
        }
    }
}

#Preview {
    EnterprisePerformanceDashboard()
}
