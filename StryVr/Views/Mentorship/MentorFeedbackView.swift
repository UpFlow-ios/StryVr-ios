//
//  MentorFeedbackView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/25/25.
//  🧑‍🏫 Mentor Feedback System – Ratings + Commenting + Analytics-Ready
//

import SwiftUI
import os.log

/// Allows users to submit feedback on a mentor session
struct MentorFeedbackView: View {
    @State private var feedback: String = ""
    @State private var rating: Double = 4.0
    @State private var submitted: Bool = false
    @State private var errorMessage: String?

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "MentorFeedbackView")

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                VStack(alignment: .leading, spacing: Theme.Spacing.large) {

                    Text("Rate Your Mentor")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .accessibilityLabel("Rate your mentor")

                    // MARK: - Rating Slider
                    VStack(alignment: .leading) {
                        Slider(value: $rating, in: 1...5, step: 1)
                            .accentColor(Theme.Colors.accent)
                        Text("Rating: \(Int(rating)) ⭐️")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .accessibilityLabel("Rating: \(Int(rating)) stars")
                    }

                    // MARK: - Feedback Text
                    TextField("Leave a comment...", text: $feedback, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .padding(.top, Theme.Spacing.small)
                        .accessibilityLabel("Feedback comment field")
                        .accessibilityHint("Enter your feedback about the mentor session")

                    // MARK: - Error Message
                    if let error = errorMessage {
                        Text(error)
                            .font(Theme.Typography.caption)
                            .foregroundColor(.red)
                            .accessibilityLabel("Error: \(error)")
                    }

                    // MARK: - Submit Button
                    Button(action: submitFeedback) {
                        Text("Submit Feedback")
                            .font(Theme.Typography.body)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.Colors.accent)
                            .foregroundColor(Theme.Colors.whiteText)
                            .cornerRadius(Theme.CornerRadius.medium)
                            .accessibilityLabel("Submit mentor feedback")
                            .accessibilityHint("Tap to submit your feedback")
                    }

                    // MARK: - Submission Confirmation
                    if submitted {
                        Text("✅ Feedback submitted successfully!")
                            .foregroundColor(.green)
                            .font(Theme.Typography.caption)
                            .accessibilityLabel("Feedback submitted")

                        Button("Submit Another Feedback") {
                            resetForm()
                        }
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.accent)
                        .padding(.top, Theme.Spacing.small)
                        .accessibilityLabel("Submit another feedback")
                    }

                    Spacer()
                }
                .padding(.horizontal, Theme.Spacing.large)
            }
            .navigationTitle("Mentor Feedback")
        }
    }

    // MARK: - Feedback Submission Logic
    private func submitFeedback() {
        guard !feedback.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Feedback cannot be empty."
            logger.error("❌ Mentor feedback cannot be empty.")
            return
        }

        // 🚀 Log locally or send to Firebase
        logger.info("✅ Feedback Submitted – Rating: \(rating), Comment: \(feedback)")
        submitted = true
        errorMessage = nil
    }

    // MARK: - Reset Form
    private func resetForm() {
        feedback = ""
        rating = 4.0
        submitted = false
        errorMessage = nil
    }
}

#Preview {
    MentorFeedbackView()
}
