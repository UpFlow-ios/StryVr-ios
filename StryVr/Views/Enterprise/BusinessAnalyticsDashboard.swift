///
//  BusinessAnalyticsDashboard.swift
//  StryVr
//
//  📊 Team Analytics Dashboard – Skill Insights, Top Performers, Skill Gaps
//

import Charts
import SwiftUI

struct BusinessAnalyticsDashboard: View {
    @State private var teamReports: [LearningReport] = []
    @State private var errorMessage: String?

    // MARK: - Computed Analytics

    private var averageProgressBySkill: [String: Double] {
        ReportAnalysisHelper.calculateAverageSkillProgress(from: teamReports)
    }

    private var topPerformers: [UserModel] {
        ReportAnalysisHelper.findTopUsers(from: teamReports)
    }

    private var lowPerformingSkills: [String] {
        ReportAnalysisHelper.findWeakSkills(from: teamReports, threshold: 60)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    // MARK: - Dashboard Title

                    Text("📈 Business Analytics")
                        .font(Theme.Typography.headline)
                        .padding(.top, Theme.Spacing.medium)
                        .padding(.horizontal)

                    // MARK: - Company Info (Optional)

                    Text("Organization: StryVr Inc.")
                        .font(Theme.Typography.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    // MARK: - Export Button (Placeholder)

                    Button(action: {
                        // Future: export as PDF/CSV
                    }) {
                        Label("Export Summary", systemImage: "square.and.arrow.up")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.accent)
                    }
                    .padding(.horizontal)

                    // MARK: - Skill Progress Chart

                    if !averageProgressBySkill.isEmpty {
                        Group {
                            Text("Average Skill Progress")
                                .font(Theme.Typography.subheadline)
                                .padding(.horizontal)

                            Chart {
                                ForEach(averageProgressBySkill.sorted(by: { $0.key < $1.key }), id: \.key) { skill, avg in
                                    BarMark(
                                        x: .value("Skill", skill),
                                        y: .value("Average", avg)
                                    )
                                    .foregroundStyle(Theme.Colors.accent)
                                }
                            }
                            .frame(height: 240)
                            .padding(.horizontal)
                            .background(Theme.Colors.card)
                            .cornerRadius(Theme.CornerRadius.medium)
                            .shadow(radius: 2)
                            .accessibilityLabel("Average skill progress chart")
                        }
                    } else if errorMessage == nil {
                        Text("No data available for skill progress.")
                            .foregroundColor(.secondary)
                            .padding()
                            .accessibilityLabel("No skill progress data available.")
                    }

                    // MARK: - Top Performers

                    if !topPerformers.isEmpty {
                        Group {
                            Text("🏅 Top Performers")
                                .font(Theme.Typography.subheadline)
                                .padding(.horizontal)

                            ForEach(topPerformers.prefix(3)) { user in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(user.name)
                                            .font(.headline)
                                        Text("Avg Progress: \(String(format: "%.1f", user.averageProgress))%")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                .accessibilityLabel("Top performer: \(user.name), average progress \(String(format: "%.1f", user.averageProgress)) percent.")
                            }
                        }
                    } else if errorMessage == nil {
                        Text("No top performers found.")
                            .foregroundColor(.secondary)
                            .padding()
                            .accessibilityLabel("No top performers available.")
                    }

                    // MARK: - Skills Needing Attention

                    if !lowPerformingSkills.isEmpty {
                        Group {
                            Text("⚠️ Skills Needing Attention")
                                .font(Theme.Typography.subheadline)
                                .padding(.horizontal)

                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(lowPerformingSkills, id: \.self) { skill in
                                    Text("• \(skill)")
                                        .font(.subheadline)
                                        .foregroundColor(.orange)
                                        .accessibilityLabel("Skill needing attention: \(skill)")
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else if errorMessage == nil {
                        Text("No skills needing attention.")
                            .foregroundColor(.secondary)
                            .padding()
                            .accessibilityLabel("No skills needing attention.")
                    }

                    // MARK: - Error Message

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                            .accessibilityLabel("Error: \(errorMessage)")
                    }
                }
                .padding(.bottom)
            }
            .background(Theme.Colors.background)
            .navigationTitle("Team Insights")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: loadData) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .accessibilityLabel("Refresh dashboard data")
                }
            }
            .onAppear(perform: loadData)
        }
    }

    // MARK: - Data Fetch Logic

    private func loadData() {
        errorMessage = nil
        ReportGeneration.shared.fetchTeamReports { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(reports):
                    self.teamReports = reports
                case .failure:
                    self.errorMessage = "Failed to load team reports. Please try again later."
                }
            }
        }
    }
}

#Preview {
    BusinessAnalyticsDashboard()
}
