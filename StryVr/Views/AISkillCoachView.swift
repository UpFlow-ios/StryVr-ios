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
    
    var body: some View {
        VStack {
            Text("AI Skill Coach")
                .font(.largeTitle)
                .bold()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("🔍 Personalized Skill Recommendations")
                    .font(.headline)
                
                ForEach(recommendedSkills, id: \.self) { skill in
                    SkillTagView(skill: skill)
                }
                
                Spacer()
                
                Text("📈 Growth Insights")
                    .font(.headline)
                
                if isLoading {
                    ProgressView()
                } else {
                    Text(progressInsights)
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .onAppear {
            fetchSkillRecommendations()
            fetchProgressInsights()
        }
    }
    
    /// Fetch AI-powered skill recommendations
    private func fetchSkillRecommendations() {
        AIRecommendationService.shared.fetchSkillRecommendations(for: "currentUserID") { result in
            switch result {
            case .success(let skills):
                recommendedSkills = skills
            case .failure(let error):
                print("🔴 Error fetching skill recommendations: \(error.localizedDescription)")
            }
        }
    }
    
    /// Fetch AI-generated learning progress insights
    private func fetchProgressInsights() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            progressInsights = "Your coding efficiency has improved by 18% this month. Keep up the great work!"
            isLoading = false
        }
    }
}
