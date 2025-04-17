//
//  HomeView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/8/25.
//  🧠 AI-Powered Home Dashboard for Mentor Discovery & Engagement
//

import SwiftUI
import os.log

/// Main home screen for StryVr, displaying learning paths, mentor suggestions, and community updates
struct HomeView: View {
    @State private var recommendedMentors: [MentorModel] = []
    @State private var isLoading: Bool = false
    private let recommendationService: AIRecommendationService
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "HomeView")

    init(recommendationService: AIRecommendationService = .shared) {
        self.recommendationService = recommendationService
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {

                    // MARK: - Greeting
                    Text("Welcome to StryVr")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .accessibilityLabel("Welcome to StryVr")

                    // MARK: - Mentor Recommendations
                    if isLoading {
                        ProgressView("Loading mentors...")
                            .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                            .accessibilityLabel("Loading mentors")
                    } else if recommendedMentors.isEmpty {
                        Text("No mentor matches found.")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .accessibilityLabel("No mentor matches found")
                    } else {
                        MentorListView(mentors: recommendedMentors)
                            .transition(.opacity)
                            .accessibilityLabel("Recommended mentors list")
                    }

                    Spacer()
                }
                .padding(.horizontal, Theme.Spacing.large)
                .padding(.top, Theme.Spacing.medium)
            }
            .background(Theme.Colors.background)
            .navigationBarHidden(true)
            .onAppear(perform: fetchMentorRecommendations)
        }
    }

    /// Fetches mentor recommendations using AI and updates state
    private func fetchMentorRecommendations() {
        isLoading = true
        recommendationService.fetchMentorRecommendations(for: "currentUserID") { [weak self] mentors in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                if mentors.isEmpty {
                    self.logger.error("❌ No mentors returned from AIRecommendationService.")
                }
                withAnimation {
                    self.recommendedMentors = mentors
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
