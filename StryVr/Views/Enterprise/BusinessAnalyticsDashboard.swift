//
//  BusinessAnalyticsDashboard.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  📈 Business Analytics & Performance Metrics with iOS 18 Liquid Glass
//

import Charts
import Foundation
import SwiftUI

struct BusinessAnalyticsDashboard: View {
    @State private var teamReports: [LearningReport] = []
    @State private var errorMessage: String?
    @Namespace private var glassNamespace

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

                    if #available(iOS 18.0, *) {
                        Text("📈 Business Analytics")
                            .font(Theme.Typography.headline)
                            .padding(.top, Theme.Spacing.medium)
                            .padding(.horizontal)
                            .glassEffect(
                                .regular.tint(Theme.Colors.textPrimary.opacity(0.05)),
                                in: RoundedRectangle(cornerRadius: 8)
                            )
                            .glassEffectID("dashboard-title", in: glassNamespace)
                    } else {
                        Text("📈 Business Analytics")
                            .font(Theme.Typography.headline)
                            .padding(.top, Theme.Spacing.medium)
                            .padding(.horizontal)
                    }

                    // MARK: - Company Info (Optional)

                    Text("Organization: StryVr Inc.")
                        .font(Theme.Typography.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    // MARK: - Export Button (Placeholder)

                    Button(
                        action: {
                            // Future: export as PDF/CSV
                        },
                        label: {
                            if #available(iOS 18.0, *) {
                                Label("Export Summary", systemImage: "square.and.arrow.up")
                                    .font(Theme.Typography.caption)
                                    .foregroundColor(Theme.Colors.accent)
                                    .glassEffect(
                                        .regular.tint(Theme.Colors.accent.opacity(0.1)),
                                        in: RoundedRectangle(cornerRadius: 6)
                                    )
                                    .glassEffectID("export-button", in: glassNamespace)
                            } else {
                                Label("Export Summary", systemImage: "square.and.arrow.up")
                                    .font(Theme.Typography.caption)
                                    .foregroundColor(Theme.Colors.accent)
                            }
                        }
                    )
                    .padding(.horizontal)

                    // MARK: - Skill Progress Chart

                    if !averageProgressBySkill.isEmpty {
                        Group {
                            Text("Average Skill Progress")
                                .font(Theme.Typography.subheadline)
                                .padding(.horizontal)

                            Chart {
                                ForEach(
                                    averageProgressBySkill.sorted(by: { $0.key < $1.key }),
                                    id: \.key
                                ) { skill, avg in
                                    BarMark(
                                        x: .value("Skill", skill),
                                        y: .value("Average", avg)
                                    )
                                    .foregroundStyle(Theme.Colors.accent)
                                }
                            }
                            .frame(height: 240)
                            .padding(.horizontal)
                            .applyChartGlassEffect()
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
                            if #available(iOS 18.0, *) {
                                Text("🏅 Top Performers")
                                    .font(Theme.Typography.subheadline)
                                    .padding(.horizontal)
                                    .glassEffect(
                                        .regular.tint(Theme.Colors.textPrimary.opacity(0.05)),
                                        in: RoundedRectangle(cornerRadius: 6)
                                    )
                                    .glassEffectID("top-performers-title", in: glassNamespace)
                            } else {
                                Text("🏅 Top Performers")
                                    .font(Theme.Typography.subheadline)
                                    .padding(.horizontal)
                            }

                            ForEach(topPerformers.prefix(3)) { user in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(user.name)
                                            .font(.headline)
                                        Text(
                                            "Avg Progress: \(String(format: "%.1f", user.averageProgress))%"
                                        )
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                .accessibilityLabel(
                                    "Top performer: \(user.name), average progress \(String(format: "%.1f", user.averageProgress)) percent."
                                )
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
                            if #available(iOS 18.0, *) {
                                Text("⚠️ Skills Needing Attention")
                                    .font(Theme.Typography.subheadline)
                                    .padding(.horizontal)
                                    .glassEffect(.regular.tint(.orange.opacity(0.1)), in: RoundedRectangle(cornerRadius: 6))
                                    .glassEffectID("skills-attention-title", in: glassNamespace)
                            } else {
                                Text("⚠️ Skills Needing Attention")
                                    .font(Theme.Typography.subheadline)
                                    .padding(.horizontal)
                            }

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
                            .applyErrorGlassEffect()
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
                        if #available(iOS 18.0, *) {
                            Image(systemName: "arrow.clockwise")
                                .glassEffect(.regular.tint(Theme.Colors.accent.opacity(0.2)), in: Circle())
                                .glassEffectID("refresh-button", in: glassNamespace)
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
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

// MARK: - iOS 18 Liquid Glass Helper Extensions

extension View {
    /// Apply chart glass effect with iOS 18 Liquid Glass
    func applyChartGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(Theme.Colors.card.opacity(0.3)), in: RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
                .shadow(radius: 2)
        } else {
            return self.background(Theme.Colors.card)
                .cornerRadius(Theme.CornerRadius.medium)
                .shadow(radius: 2)
        }
    }
    
    /// Apply error glass effect with iOS 18 Liquid Glass
    func applyErrorGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(.red.opacity(0.1)), in: RoundedRectangle(cornerRadius: 8))
        } else {
            return self
        }
    }
}
