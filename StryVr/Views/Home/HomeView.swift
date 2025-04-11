import SwiftUI
import os.log

/// Main home screen for StryVr, displaying learning paths, mentor suggestions, and community updates
struct HomeView: View {
    @State private var recommendedMentors: [MentorModel] = []
    private let recommendationService: AIRecommendationService
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "HomeView")

    init(recommendationService: AIRecommendationService = .shared) {
        self.recommendationService = recommendationService
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to StryVr")
                    .font(.largeTitle)
                    .bold()
                
                if !recommendedMentors.isEmpty {
                    MentorListView(mentors: recommendedMentors)
                        .transition(.opacity) // Apply fade transition
                }

                Spacer()
            }
            .padding()
            .onAppear {
                fetchMentorRecommendations()
            }
            .navigationBarHidden(true)
        }
    }

    /// Fetches mentor recommendations and updates the state
    private func fetchMentorRecommendations() {
        recommendationService.fetchMentorRecommendations(for: "currentUserID") { [weak self] mentors in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if mentors.isEmpty {
                    self.logger.error("No mentors found or an error occurred")
                }
                withAnimation { // Animate the state change
                    self.recommendedMentors = mentors
                }
            }
        }
    }
}
