//
//  CareerPathInsightsView.swift
//  StryVr
//
//  🧠 AI Career Path Insights & Recommendations
//

import Charts
import Foundation
import SwiftUI

struct CareerPathInsightsView: View {
    @State private var skillData: [SkillProgress] = []
    @State private var suggestedCareers: [String] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Spacing.large) {
                Text("AI Career Insights")
                    .font(Theme.Typography.headline)
                    .padding(.top, Theme.Spacing.medium)

                // Loading Indicator
                if isLoading {
                    ProgressView("Analyzing your skills...")
                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                        .padding()
                }

                // Error Message
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.medium)
                        .accessibilityLabel("Error: \(error)")
                }

                // Career Suggestions
                if !suggestedCareers.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: Theme.Spacing.medium) {
                            ForEach(suggestedCareers, id: \.self) { career in
                                CareerCard(title: career)
                                    .padding(.horizontal, Theme.Spacing.medium)
                            }
                        }
                        .padding(.bottom, Theme.Spacing.large)
                    }
                } else if !isLoading && errorMessage == nil {
                    Text("No career suggestions available yet.")
                        .foregroundColor(.secondary)
                        .padding()
                        .accessibilityHint("Try completing more learning paths.")
                }

                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.medium)
            .navigationTitle("Career Paths")
            .onAppear(perform: loadCareerInsights)
        }
    }

    // MARK: - AI Recommendation Fetch

    private func loadCareerInsights() {
        isLoading = true
        errorMessage = nil

        FirestoreService.shared.fetchSkillProgress { result in
            switch result {
            case let .success(skills):
                self.skillData = skills

                guard !skills.isEmpty else {
                    self.isLoading = false
                    self.errorMessage =
                        "No skill data found. Complete a few learning paths to unlock insights."
                    return
                }

                AIRecommendationService.shared.getCareerRecommendations(from: skills) {
                    result in
                    switch result {
                    case let .success(careers):
                        self.suggestedCareers = careers
                    case .failure:
                        self.errorMessage =
                            "Failed to fetch career recommendations. Please try again later."
                    }
                    self.isLoading = false
                }
            case .failure:
                self.isLoading = false
                self.errorMessage = "Failed to load skill data. Please try again later."
            }
        }
    }
}

#Preview {
    CareerPathInsightsView()
}
