//
//  AISkillCoachView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import SwiftUI

/// AI-powered skill coach that provides learning recommendations and progress insights
struct AISkillCoachView: View {
    @State private var recommendedSkills: [String] = []
    @State private var progressInsights: String = "Loading insights..."
    @State private var isLoading: Bool = true
    @State private var hasError: Bool = false

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.large) {
                    
                    // MARK: - Title
                    Text("AI Skill Coach")
                        .font(FontStyle.title)
                        .foregroundColor(.whiteText)
                        .padding(.top, Spacing.large)
                        .accessibilityLabel("AI Skill Coach")

                    // MARK: - Skill Recommendations
                    StryVrCardView(title: "🔍 Personalized Skill Recommendations") {
                        if hasError {
                            Text("Failed to load recommendations. Please try again later.")
                                .font(FontStyle.caption)
                                .foregroundColor(.red)
                                .accessibilityLabel("Error: Failed to load recommendations")
                        } else if recommendedSkills.isEmpty {
                            Text("No recommendations yet.")
                                .font(FontStyle.caption)
                                .foregroundColor(.lightGray)
                                .accessibilityLabel("No recommendations yet")
                        } else {
                            VStack(alignment: .leading, spacing: Spacing.small) {
                                ForEach(recommendedSkills, id: \.self) { skill in
                                    SkillTagView(skill: skill)
                                        .accessibilityLabel("Recommended skill: \(skill)")
                                }
                            }
                        }
                    }

                    // MARK: - Growth Insights
                    StryVrCardView(title: "📈 Growth Insights") {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .neonBlue))
                                .accessibilityLabel("Loading progress insights")
                        } else {
                            Text(progressInsights)
                                .font(FontStyle.body)
                                .foregroundColor(.lightGray)
                                .accessibilityLabel("Progress insight: \(progressInsights)")
                        }
                    }

                    Spacer(minLength: Spacing.large)
                }
                .padding(.horizontal, Spacing.large)
            }
        }
        .onAppear {
            fetchSkillRecommendations()
        }
            fetchProgressInsights()
    }

    /// Fetch AI-powered skill recommendations
    private func fetchSkillRecommendations() {
        AIRecommendationService.shared.fetchSkillRecommendations(for: "currentUserID") { result in
            DispatchQueue.main.async {
                switch result {
                    withAnimation {
                case .success(let skills):
                        recommendedSkills = skills
                        hasError = false
                    }
                case .failure(let error):
                    print("🔴 Error fetching skill recommendations: \(error.localizedDescription)")
                    withAnimation {
                        hasError = true
                    }
                }
            }
        }
    }

    /// Fetch AI-generated learning progress insights
    private func fetchProgressInsights() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                progressInsights = "Your coding efficiency has improved by 18% this month. Keep up the great work!"
                isLoading = false
            }
        }
    }
}
