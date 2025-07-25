//
//  AISkillCoachView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//  🤖 AI-Powered Skill Coach – Learning Insights + Personalized Suggestions
//

import SwiftUI
import SymbolAnimator

struct AISkillCoachView: View {
    @State private var recommendedSkills: [String] = []
    @State private var progressInsights: String = "Loading insights..."
    @State private var hasError: Bool = false

    @State private var isLoading: Bool = true
    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    // MARK: - Header

                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                            .font(.title2)
                            .animateSymbol(true, type: .variableColor)
                            .shadow(color: .yellow.opacity(0.5), radius: 8)
                        Text("AI Skill Coach")
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                    .padding(.top, Theme.Spacing.large)
                    .accessibilityLabel("AI Skill Coach")
                    .accessibilityHint(
                        "Provides personalized skill recommendations and growth insights")

                    // MARK: - Recommendations

                    StryVrCardView(title: "🔍 Personalized Skill Recommendations") {
                        if hasError {
                            VStack(spacing: Theme.Spacing.small) {
                                Text("Failed to load recommendations. Please try again later.")
                                    .font(Theme.Typography.caption)
                                    .foregroundColor(.red)
                                    .accessibilityLabel("Error: Failed to load recommendations")
                                Button("Retry") {
                                    fetchSkillRecommendations()
                                }
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.accent)
                                .accessibilityLabel("Retry button")
                            }
                        } else if recommendedSkills.isEmpty {
                            Text("No recommendations yet.")
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.textSecondary)
                                .accessibilityLabel("No recommendations available")
                        } else {
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                ForEach(recommendedSkills, id: \.self) { skill in
                                    SkillTagView(skill: .constant(skill))
                                        .accessibilityLabel("Recommended skill: \(skill)")
                                }
                            }
                        }
                    }

                    // MARK: - Insights

                    StryVrCardView(title: "📈 Growth Insights") {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(
                                    CircularProgressViewStyle(tint: Theme.Colors.accent)
                                )
                                .accessibilityLabel("Loading progress insights")
                        } else {
                            Text(progressInsights)
                                .font(Theme.Typography.body)
                                .foregroundColor(Theme.Colors.textSecondary)
                                .accessibilityLabel("Progress insight: \(progressInsights)")
                        }
                    }

                    Spacer(minLength: Theme.Spacing.large)
                }
                .padding(.horizontal, Theme.Spacing.large)
            }
        }
        .onAppear {
            fetchSkillRecommendations()
            fetchProgressInsights()
        }
    }

    // MARK: - AI Skill Recommendation

    private func fetchSkillRecommendations() {
        AIRecommendationService.shared.fetchSkillRecommendations(for: "currentUserID") { result in
            DispatchQueue.main.async {
                withAnimation {
                    switch result {
                    case let .success(skills):
                        self.recommendedSkills = skills
                        self.hasError = false
                    case let .failure(error):
                        print(
                            "🔴 Error fetching skill recommendations: \(error.localizedDescription)")
                        self.hasError = true
                    }
                }
            }
        }
    }

    // MARK: - Progress Insights (Simulated)

    private func fetchProgressInsights() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.progressInsights =
                    "Your coding efficiency has improved by 18% this month. Keep up the great work!"
                self.isLoading = false
            }
        }
    }
}
