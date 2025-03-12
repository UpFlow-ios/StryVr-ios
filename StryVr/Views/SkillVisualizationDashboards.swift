//
//  SkillVisualizationDashboards.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import SwiftUI
import Charts
import FirebaseFirestore
import os.log

/// Displays a user's learning progress with interactive skill visualization charts
struct SkillVisualizationDashboards: View {
    @State private var skillProgress: [SkillProgress] = []
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "SkillVisualizationDashboards")

    var body: some View {
        NavigationView {
            VStack {
                Text("📊 Skill Progress Dashboard")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                if skillProgress.isEmpty {
                    Text("Loading skill data...")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    Chart(skillProgress) { progress in
                        BarMark(
                            x: .value("Skill", progress.skillName),
                            y: .value("Progress", progress.percentage * 100)
                        )
                        .foregroundStyle(progress.percentage > 0.8 ? Color.green : Color.blue)
                    }
                    .frame(height: 300)
                    .padding()

                    VStack(alignment: .leading, spacing: 10) {
                        Text("📈 AI Insights")
                            .font(.headline)

                        Text(generateAIInsights(from: skillProgress))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .padding()
            .onAppear {
                fetchSkillProgress()
            }
        }
    }

    /// Fetches skill progress data from Firestore
    private func fetchSkillProgress() {
        let userID = "currentUserID"
        Firestore.firestore().collection("users").document(userID).getDocument { snapshot, error in
            guard let data = snapshot?.data(), let skills = data["progress"] as? [String: Double], error == nil else {
                logger.error("Error fetching skill data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.skillProgress = skills.map { SkillProgress(skillName: $0.key, percentage: $0.value) }
        }
    }

    /// Generates AI-powered insights based on skill progress data
    /// - Parameter progressData: An array of `SkillProgress` objects.
    /// - Returns: A string containing AI insights.
    private func generateAIInsights(from progressData: [SkillProgress]) -> String {
        guard let topSkill = progressData.max(by: { $0.percentage < $1.percentage }) else {
            return "Keep learning to see AI insights on your progress!"
        }

        let improvementAreas = progressData.filter { $0.percentage < 0.5 }.map { $0.skillName }
        let improvementText = improvementAreas.isEmpty ? "You're excelling across all areas!" : "Consider improving: \(improvementAreas.joined(separator: ", "))"

        return "Your top skill is **\(topSkill.skillName)** with \(Int(topSkill.percentage * 100))% mastery. \(improvementText)"
    }
}

///
