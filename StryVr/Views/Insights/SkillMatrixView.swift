//  SkillMatrixView.swift
//  StryVr
//
//  🧠 Skill Matrix – Visualize Team Skill Distribution & Strengths
//

import Charts
import SwiftUI

struct SkillMatrixView: View {
    @State private var skillMatrix: [SkillMatrixEntry] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    // MARK: - Title

                    Text("🧠 Team Skill Matrix")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)

                    // MARK: - Chart or Message

                    if isLoading {
                        ProgressView("Loading matrix...")
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    } else if skillMatrix.isEmpty {
                        Text("No skill data available.")
                            .foregroundColor(.secondary)
                    } else {
                        Chart(skillMatrix) { entry in
                            BarMark(
                                x: .value("Skill", entry.skillName),
                                y: .value("Average", entry.averageScore)
                            )
                            .foregroundStyle(by: .value("Skill", entry.skillName))
                        }
                        .frame(height: 280)
                        .padding()
                        .background(Theme.Colors.card)
                        .cornerRadius(Theme.CornerRadius.medium)
                        .shadow(radius: 2)
                        .accessibilityLabel("Skill matrix bar chart")
                    }
                }
                .padding()
            }
            .navigationTitle("Skill Matrix")
            .background(Theme.Colors.background.ignoresSafeArea())
            .onAppear(perform: loadMatrix)
        }
    }

    // MARK: - Load Skill Matrix Data

    private func loadMatrix() {
        SkillMatrixService.shared.fetchMatrix { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case let .success(data):
                    self.skillMatrix = data
                case .failure:
                    self.errorMessage = "Failed to load skill matrix."
                }
            }
        }
    }
}

#Preview {
    SkillMatrixView()
}
