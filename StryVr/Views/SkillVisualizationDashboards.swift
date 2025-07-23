//
//  SkillVisualizationDashboards.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  📊 Skill Visualization Dashboards – Interactive Charts & AI Insights
//

import Charts
import Foundation
import OSLog
import SwiftUI

/// Displays a user's learning progress with interactive skill visualization charts
struct SkillVisualizationDashboards: View {
    @State private var skillProgress: [SkillProgress] = []
    @State private var hasError: Bool = false
    @State private var errorMessage: String = ""
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!, category: "SkillVisualizationDashboards")

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                if hasError {
                    VStack {
                        Text("⚠️ Failed to load skill data.")
                            .foregroundColor(.red)
                            .font(Theme.Typography.body)
                            .multilineTextAlignment(.center)
                            .padding()
                            .accessibilityLabel("Error: Failed to load skill data")
                        Button("Retry") {
                            fetchSkillProgress()
                        }
                        .font(Theme.Typography.buttonText)
                        .foregroundColor(Theme.Colors.accent)
                        .accessibilityLabel("Retry button")
                    }
                } else if skillProgress.isEmpty {
                    VStack {
                        ProgressView("Loading skill data...")
                            .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                            .accessibilityLabel("Loading skill data")
                        Spacer()
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                            // MARK: - Header

                            Text("📊 Skill Progress Dashboard")
                                .font(Theme.Typography.headline)
                                .foregroundColor(Theme.Colors.textPrimary)
                                .padding(.top, Theme.Spacing.large)

                            // MARK: - Chart

                            StryVrCardView(title: "Skill Growth Overview") {
                                Chart(skillProgress) { progress in
                                    BarMark(
                                        x: .value("Skill", progress.skillName),
                                        y: .value("Progress", progress.percentage * 100)
                                    )
                                    .foregroundStyle(
                                        progress.percentage > 0.8 ? .green : Theme.Colors.accent)
                                }
                                .frame(height: 240)
                                .chartYAxis {
                                    AxisMarks(position: .leading)
                                }
                                .accessibilityLabel("Skill growth chart")
                                .accessibilityHint("Displays progress for each skill")
                            }

                            // MARK: - AI Insights

                            StryVrCardView(title: "📈 AI Insights") {
                                Text(generateAIInsights(from: skillProgress))
                                    .font(Theme.Typography.body)
                                    .foregroundColor(Theme.Colors.textSecondary)
                                    .accessibilityLabel("AI insights")
                                    .accessibilityHint("Provides personalized learning insights")
                            }

                            Spacer(minLength: Theme.Spacing.large)
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                    }
                }
            }
            .navigationTitle("Skill Analytics")
            .onAppear {
                fetchSkillProgress()
            }
        }
    }

    // MARK: - Firestore Data

    private func fetchSkillProgress() {
        hasError = false
        let userID = "currentUserID"
        Firestore.firestore().collection("users").document(userID).getDocument { snapshot, error in
            DispatchQueue.main.async {
                if let error = error {
                    handleError("Error fetching skill data: \(error.localizedDescription)")
                    return
                }

                guard let data = snapshot?.data(),
                    let skills = data["progress"] as? [String: Double]
                else {
                    handleError("Invalid or missing skill data in document.")
                    return
                }

                self.skillProgress = skills.map {
                    SkillProgress(skill: $0.key, progress: $0.value)
                }
                logger.info("✅ Skill data loaded: \(self.skillProgress.count) items")
            }
        }
    }

    // MARK: - AI Insight Logic

    private func generateAIInsights(from progressData: [SkillProgress]) -> String {
        guard let topSkill = progressData.max(by: { $0.percentage < $1.percentage }) else {
            return "📘 Keep learning to unlock AI-powered progress insights."
        }

        let improvementAreas =
            progressData
            .filter { $0.percentage < 0.5 }
            .map { $0.skillName }

        let improvementText =
            improvementAreas.isEmpty
            ? "🚀 You're excelling across all areas!"
            : "🧠 Focus more on: \(improvementAreas.joined(separator: ", "))"

        return
            "🌟 Your top skill is **\(topSkill.skillName)** at \(Int(topSkill.percentage * 100))% mastery. \(improvementText)"
    }

    // MARK: - Error Handling

    private func handleError(_ message: String) {
        logger.error("❌ \(message)")
        errorMessage = message
        hasError = true
    }
}

#Preview {
    SkillVisualizationDashboards()
}
