//
//  ReportsView.swift
//  StryVr
//
//  📊 Reports Dashboard – Comprehensive analytics and insights
//

import SwiftUI

struct ReportsView: View {
    @StateObject private var reportsViewModel = ReportsViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    // Header
                    VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                        Text("Performance Analytics")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.text)

                        Text("Track your progress and identify growth opportunities")
                            .font(Theme.Fonts.body)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Reports Content
                    if reportsViewModel.isLoading {
                        ProgressView("Loading reports...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        VStack(spacing: Theme.Spacing.large) {
                            // Performance Card
                            StryVrCardView {
                                VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                                    Text("Performance Overview")
                                        .font(Theme.Fonts.headline)
                                        .foregroundColor(Theme.Colors.text)

                                    Text("Your performance metrics and trends")
                                        .font(Theme.Fonts.body)
                                        .foregroundColor(Theme.Colors.textSecondary)
                                }
                            }

                            // Skills Card
                            StryVrCardView {
                                VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                                    Text("Skills Assessment")
                                        .font(Theme.Fonts.headline)
                                        .foregroundColor(Theme.Colors.text)

                                    Text("Current skill levels and progress")
                                        .font(Theme.Fonts.body)
                                        .foregroundColor(Theme.Colors.textSecondary)
                                }
                            }

                            // Goals Card
                            StryVrCardView {
                                VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                                    Text("Goals Progress")
                                        .font(Theme.Fonts.headline)
                                        .foregroundColor(Theme.Colors.text)

                                    Text("Track your goal completion")
                                        .font(Theme.Fonts.body)
                                        .foregroundColor(Theme.Colors.textSecondary)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Theme.Colors.background)
            .navigationTitle("Reports")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            reportsViewModel.loadReports()
        }
    }
}

// MARK: - ViewModel

class ReportsViewModel: ObservableObject {
    @Published var isLoading = false

    func loadReports() {
        isLoading = true

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
        }
    }
}

#Preview {
    ReportsView()
}
