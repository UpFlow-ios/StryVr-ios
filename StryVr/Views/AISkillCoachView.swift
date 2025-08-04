//
//  AISkillCoachView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//  🤖 AI-Powered Skill Coach – Learning Insights + Personalized Suggestions with iOS 18 Liquid Glass
//

import SwiftUI

struct AISkillCoachView: View {
    @State private var recommendedSkills: [String] = []
    @State private var progressInsights: String = "Loading insights..."
    @State private var hasError: Bool = false
    @State private var isLoading: Bool = true
    @Namespace private var glassNamespace

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    // MARK: - Header

                    HStack(spacing: 8) {
                        if #available(iOS 18.0, *) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                                .font(.title2)
                                .animateSymbol(true, type: "variableColor")
                                .glassEffect(.regular.tint(.yellow.opacity(0.3)), in: Circle())
                                .glassEffectID("ai-coach-icon", in: glassNamespace)
                                .shadow(color: .yellow.opacity(0.5), radius: 8)
                        } else {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                                .font(.title2)
                                .animateSymbol(true, type: "variableColor")
                                .shadow(color: .yellow.opacity(0.5), radius: 8)
                        }
                        
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
                                    .applyErrorGlassEffect()
                                    .accessibilityLabel("Error: Failed to load recommendations")
                                Button("Retry") {
                                    fetchSkillRecommendations()
                                }
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.accent)
                                .applyRetryButtonGlassEffect()
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
                            if #available(iOS 18.0, *) {
                                ProgressView()
                                    .progressViewStyle(
                                        CircularProgressViewStyle(tint: Theme.Colors.accent)
                                    )
                                    .glassEffect(.regular.tint(Theme.Colors.accent.opacity(0.2)), in: Circle())
                                    .glassEffectID("progress-loader", in: glassNamespace)
                                    .accessibilityLabel("Loading progress insights")
                            } else {
                                ProgressView()
                                    .progressViewStyle(
                                        CircularProgressViewStyle(tint: Theme.Colors.accent)
                                    )
                                    .accessibilityLabel("Loading progress insights")
                            }
                        } else {
                            Text(progressInsights)
                                .font(Theme.Typography.body)
                                .foregroundColor(Theme.Colors.textSecondary)
                                .applyInsightTextGlassEffect()
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
            Task { @MainActor in
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

// MARK: - iOS 18 Liquid Glass Helper Extensions

extension View {
    /// Apply error glass effect with iOS 18 Liquid Glass
    func applyErrorGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(.red.opacity(0.1)), in: RoundedRectangle(cornerRadius: 8))
        } else {
            return self
        }
    }
    
    /// Apply retry button glass effect with iOS 18 Liquid Glass
    func applyRetryButtonGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(Theme.Colors.accent.opacity(0.1)), in: RoundedRectangle(cornerRadius: 6))
        } else {
            return self
        }
    }
    
    /// Apply insight text glass effect with iOS 18 Liquid Glass
    func applyInsightTextGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(Theme.Colors.textSecondary.opacity(0.05)), in: RoundedRectangle(cornerRadius: 8))
        } else {
            return self
        }
    }
}
