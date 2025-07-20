//
//  BehaviorFeedbackView.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25.
//  🧾 Feedback Submission View – Structured, Anonymous, Themed + Firestore Integrated
//

import OSLog
import SwiftUI

struct EmployeeBehaviorFeedbackView: View {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr.app",
        category: "BehaviorFeedbackView"
    )
    @State private var selectedCategory: FeedbackCategory = .communication
    @State private var rating: Int = 3
    @State private var comment: String = ""
    @State private var isAnonymous: Bool = false
    @State private var showConfirmation: Bool = false
    @State private var errorMessage: String?

    var employeeId: String

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    // MARK: - Title

                    Text("Submit Employee Feedback")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)

                    // MARK: - Category Picker

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(FeedbackCategory.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Theme.Colors.card)
                    .cornerRadius(Theme.CornerRadius.medium)

                    // MARK: - Rating Slider

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rating: \(rating) / 5")
                            .font(Theme.Typography.caption)
                        Slider(
                            value: Binding(
                                get: {
                                    Double(rating)
                                },
                                set: { newValue in
                                    rating = Int(newValue)
                                }), in: 1...5, step: 1)
                    }

                    // MARK: - Comment Field

                    TextField("Optional comment", text: $comment, axis: .vertical)
                        .padding()
                        .background(Theme.Colors.card)
                        .cornerRadius(Theme.CornerRadius.medium)

                    // MARK: - Anonymous Toggle

                    Toggle("Submit Anonymously", isOn: $isAnonymous)
                        .font(Theme.Typography.caption)

                    // MARK: - Error Display

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(Theme.Typography.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

                    // MARK: - Submit Button

                    Button(action: submitFeedback) {
                        Text("Submit Feedback")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.whiteText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.Colors.accent)
                            .cornerRadius(Theme.CornerRadius.medium)
                    }
                }
                .padding()
                .alert("Feedback Submitted", isPresented: $showConfirmation) {
                    Button("OK", role: .cancel) {}
                }
            }
            .navigationTitle("Behavior Feedback")
            .background(Theme.Colors.background.ignoresSafeArea())
        }
    }

    // MARK: - Submit Feedback to Firestore

    private func submitFeedback() {
        let newFeedback = BehaviorFeedback(
            employeeId: employeeId,
            reviewerId: isAnonymous ? nil : AuthViewModel.shared.currentUser?.uid,
            category: selectedCategory,
            rating: rating,
            comment: comment,
            isAnonymous: isAnonymous
        )

        Employee.Behavior.Feedback.shared.submitFeedback(newFeedback) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    logger.info("✅ Feedback submitted to Firestore.")
                    showConfirmation = true
                    resetForm()
                case let .failure(error):
                    logger.error("❌ Failed to submit feedback: \(error.localizedDescription)")
                    errorMessage = "Could not submit feedback. Please try again."
                }
            }
        }
    }

    // MARK: - Reset Form After Submission

    private func resetForm() {
        selectedCategory = .communication
        rating = 3
        comment = ""
        isAnonymous = false
        errorMessage = nil
    }
}

#Preview {
    EmployeeBehaviorFeedbackView(employeeId: "example-employee-id")
}
