//
//  ReportsDashboardView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/9/25.
//  📊 Skill Reports Dashboard – Progress Charts & Growth Metrics
//

import SkillProgress
import SwiftUI

struct ReportsDashboardView: View {
    // MARK: - Mock Data

    var skillData: [SkillProgress] = [
        .init(skill: "Leadership", progress: 0.72),
        .init(skill: "UI/UX", progress: 0.64),
        .init(skill: "iOS Dev", progress: 0.89),
        .init(skill: "Problem Solving", progress: 0.58),
    ]

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    // MARK: - Title

                    Text("Reports")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .accessibilityLabel("Reports Dashboard")
                        .padding(.top, Theme.Spacing.large)

                    // MARK: - Skill Progress Chart

                    if skillData.isEmpty {
                        Text("No skill data available")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .accessibilityLabel("No skill data available")
                    } else {
                        StryVrChartCard(data: skillData)
                            .accessibilityLabel(
                                "Skill progress chart with \(skillData.count) skills")
                    }

                    // MARK: - Circular Progress Grid

                    if skillData.isEmpty {
                        Text("No skills to display")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .accessibilityLabel("No skills to display")
                    } else {
                        StryVrCardView(title: "Skill Breakdown") {
                            LazyVGrid(
                                columns: [GridItem(.flexible()), GridItem(.flexible())],
                                spacing: Theme.Spacing.medium
                            ) {
                                ForEach(skillData) { skill in
                                    StryVrProgressCircle(
                                        progress: skill.progress, label: skill.skill
                                    )
                                    .accessibilityLabel(
                                        "\(skill.skill) progress: \(Int(skill.progress * 100)) percent"
                                    )
                                    .accessibilityHint("Displays the progress for \(skill.skill)")
                                }
                            }
                            .padding(.top, Theme.Spacing.small)
                        }
                    }

                    // MARK: - Daily Learning Metrics

                    StryVrCardView(title: "Learning Metrics") {
                        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                            HStack {
                                Text("Streak")
                                Spacer()
                                Text("12 Days")
                            }
                            .accessibilityLabel("Learning streak: 12 days")

                            HStack {
                                Text("Last Activity")
                                Spacer()
                                Text("Today at 08:42")
                            }
                            .accessibilityLabel("Last activity: Today at 8:42 AM")

                            HStack {
                                Text("Monthly Growth")
                                Spacer()
                                Text("22% ↑")
                            }
                            .accessibilityLabel("Monthly growth: 22 percent increase")
                        }
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.textPrimary)
                    }

                    Spacer()
                }
                .padding(.horizontal, Theme.Spacing.large)
            }
        }
    }
}

#Preview {
    ReportsDashboardView()
}
