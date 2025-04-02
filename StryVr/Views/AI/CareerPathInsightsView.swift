//
//  CareerPathInsightsView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/1/25.
//

import SwiftUI

struct CareerPathInsightsView: View {
    @State private var skillData: [SkillProgress] = []
    @State private var suggestedCareers: [String] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("AI Career Insights")
                    .font(.largeTitle.bold())
                    .padding(.top)

                if isLoading {
                    ProgressView("Analyzing your skills...")
                        .padding()
                }

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                if !suggestedCareers.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(suggestedCareers, id: \.self) { career in
                                CareerCard(title: career)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.bottom)
                    }
                } else if !isLoading && errorMessage == nil {
                    Text("No career suggestions available yet.")
                        .foregroundColor(.secondary)
                        .padding()
                }

                Spacer()
            }
            .navigationTitle("Career Paths")
            .onAppear(perform: loadCareerInsights)
        }
    }

    // MARK: - Data + AI Integration
    private func loadCareerInsights() {
        isLoading = true
        errorMessage = nil

        FirestoreService.shared.fetchSkillProgress { skills in
            DispatchQueue.main.async {
                self.skillData = skills

                guard !skills.isEmpty else {
                    self.isLoading = false
                    self.errorMessage = "No skill data found. Complete a few learning paths to get insights."
                    return
                }

                AIRecommendationService.shared.getCareerRecommendations(from: skills) { careers in
                    DispatchQueue.main.async {
                        self.suggestedCareers = careers
                        self.isLoading = false
                    }
                }
            }
        }
    }
}
