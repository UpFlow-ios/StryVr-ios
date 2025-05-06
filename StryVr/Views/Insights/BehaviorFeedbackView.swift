//
//  BehaviorFeedbackView.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25.
//  🧾 Feedback Submission View – Structured, Anonymous, Themed
//

import SwiftUI

struct BehaviorFeedbackView: View {
    @State private var selectedCategory: FeedbackCategory = .communication
    @State private var rating: Int = 3
    @State private var comment: String = ""
    @State private var isAnonymous: Bool = false
    @State private var showConfirmation: Bool = false

    var employeeId: String

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {

                    // MARK: - Title
                    Text("Submit Feedback")
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
                        Slider(value: Binding(get: {
                            Double(rating)
                        }, set: { newValue in
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

    // MARK: - Submission Logic
    private func submitFeedback() {
        let newFeedback = BehaviorFeedback(
            employeeId: employeeId,
            reviewerId: isAnonymous ? nil : "currentUserId", // Replace with actual user ID logic
            category: selectedCategory,
            rating: rating,
            comment: comment,
            isAnonymous: isAnonymous
        )

        // 🚀 Replace with Firestore or Server call
        print("🔐 Feedback submitted: \(newFeedback)")
        showConfirmation = true
        resetForm()
    }

    private func resetForm() {
        selectedCategory = .communication
        rating = 3
        comment = ""
        isAnonymous = false
    }
}

#Preview {
    BehaviorFeedbackView(employeeId: "12345")
}

