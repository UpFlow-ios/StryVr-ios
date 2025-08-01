//
//  FeedbackHistoryView.swift
//  StryVr
//
//  📈 Structured List of Feedback with Filtering and Trends
//

import SwiftUI

struct FeedbackHistoryView: View {
    @State private var feedbacks: [BehaviorFeedback] = []
    @State private var selectedCategory: FeedbackCategory?
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?

    var employeeId: String

    private var filteredFeedbacks: [BehaviorFeedback] {
        if let category = selectedCategory {
            return feedbacks.filter { $0.category == category }
        } else {
            return feedbacks
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Spacing.medium) {
                // MARK: - Filter Menu
                Picker("Filter by Category", selection: $selectedCategory) {
                    Text("All").tag(FeedbackCategory?.none)
                    ForEach(FeedbackCategory.allCases) { category in
                        Text(category.displayName).tag(FeedbackCategory?.some(category))
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // MARK: - Feedback List
                if isLoading {
                    ProgressView("Loading Feedback...")
                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if filteredFeedbacks.isEmpty {
                    Text("No feedback found.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List(filteredFeedbacks) { feedback in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(feedback.category.displayName)
                                    .font(.subheadline)
                                    .foregroundColor(.accentColor)
                                Spacer()
                                Text("Rating: \(feedback.rating)/5")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            if let comment = feedback.comment, !comment.isEmpty {
                                Text(comment)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            if feedback.isAnonymous {
                                Text("Anonymous")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                }

                Spacer()
            }
            .navigationTitle("Feedback History")
            .background(Theme.Colors.background.ignoresSafeArea())
            .onAppear(perform: loadFeedbacks)
        }
    }

    // MARK: - Load from Firestore
    private func loadFeedbacks() {
        BehaviorFeedbackService.shared.fetchFeedback(for: employeeId) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let data):
                    feedbacks = data
                case .failure(let error):
                    errorMessage = "Failed to load feedback: \(error.localizedDescription)"
                }
            }
        }
    }
}

#Preview {
    FeedbackHistoryView(employeeI
