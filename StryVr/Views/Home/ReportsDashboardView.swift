//
//  ReportsDashboardView.swift
//  StryVr
//
//  📊 Reports Dashboard & Analytics with Liquid Glass UI
//

import Charts
import Foundation
import SwiftUI

struct ReportsDashboardView: View {
    // MARK: - Mock Data

    var skillData: [SkillProgress] = [
        .init(skillId: "leadership", skillName: "Leadership", progressPercentage: 0.72),
        .init(skillId: "uiux", skillName: "UI/UX", progressPercentage: 0.64),
        .init(skillId: "iosdev", skillName: "iOS Dev", progressPercentage: 0.89),
        .init(skillId: "problemsolving", skillName: "Problem Solving", progressPercentage: 0.58),
    ]

    var body: some View {
        ZStack {
            // MARK: - Dark Gradient Background
            
            Theme.LiquidGlass.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    // MARK: - Header
                    
                    headerSection()
                    
                    // MARK: - Skill Progress Chart

                    if skillData.isEmpty {
                        emptyStateCard(title: "No skill data available")
                    } else {
                        skillProgressCard()
                    }

                    // MARK: - Circular Progress Grid

                    if skillData.isEmpty {
                        emptyStateCard(title: "No skills to display")
                    } else {
                        skillBreakdownCard()
                    }

                    // MARK: - Daily Learning Metrics

                    learningMetricsCard()
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, Theme.Spacing.large)
                .padding(.top, Theme.Spacing.large)
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Header Section
    
    private func headerSection() -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Reports")
                .font(Theme.Typography.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Text("Your performance analytics and insights")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, Theme.Spacing.medium)
    }
    
    // MARK: - Skill Progress Card
    
    private func skillProgressCard() -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Skill Progress")
                .font(Theme.Typography.headline)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            StryVrChartCard(data: skillData)
                .accessibilityLabel("Skill progress chart with \(skillData.count) skills")
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowPrimary, radius: 12, intensity: 0.6)
    }
    
    // MARK: - Skill Breakdown Card
    
    private func skillBreakdownCard() -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Skill Breakdown")
                .font(Theme.Typography.headline)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: Theme.Spacing.medium
            ) {
                ForEach(skillData) { skill in
                    StryVrProgressCircle(
                        progress: skill.progressPercentage, label: skill.skillName
                    )
                    .accessibilityLabel(
                        "\(skill.skillName) progress: \(Int(skill.progressPercentage * 100)) percent"
                    )
                    .accessibilityHint(
                        "Displays the progress for \(skill.skillName)")
                }
            }
            .padding(.top, Theme.Spacing.small)
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowSecondary, radius: 12, intensity: 0.6)
    }
    
    // MARK: - Learning Metrics Card
    
    private func learningMetricsCard() -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Learning Metrics")
                .font(Theme.Typography.headline)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                metricRow(title: "Streak", value: "12 Days", icon: "flame.fill", color: Theme.Colors.neonOrange)
                metricRow(title: "Last Activity", value: "Today at 08:42", icon: "clock.fill", color: Theme.Colors.neonBlue)
                metricRow(title: "Monthly Growth", value: "22% ↑", icon: "chart.line.uptrend.xyaxis", color: Theme.Colors.neonGreen)
            }
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowAccent, radius: 12, intensity: 0.6)
    }
    
    // MARK: - Metric Row
    
    private func metricRow(title: String, value: String, icon: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .neonGlow(color: color.opacity(0.6), pulse: false)
                .frame(width: 24)
            
            Text(title)
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(Theme.Typography.body)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)
        }
    }
    
    // MARK: - Empty State Card
    
    private func emptyStateCard(title: String) -> some View {
        VStack(spacing: Theme.Spacing.medium) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.largeTitle)
                .foregroundColor(Theme.Colors.textSecondary)
            
            Text(title)
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowSecondary, radius: 12, intensity: 0.4)
    }
}

#Preview {
    ReportsDashboardView()
}
