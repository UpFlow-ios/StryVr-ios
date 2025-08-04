//
//  WorkplaceBehaviorFeedbackView.swift
//  StryVr
//
//  📋 Structured Workplace Behavior Feedback System with iOS 18 Liquid Glass
//

import SwiftUI

struct WorkplaceBehaviorFeedbackView: View {
    @State private var collaborationRating: Int = 0
    @State private var punctualityRating: Int = 0
    @State private var problemSolvingRating: Int = 0
    @State private var comments: String = ""
    @State private var isAnonymous: Bool = true
    @State private var submissionSuccess: Bool = false
    @Namespace private var glassNamespace

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    if #available(iOS 18.0, *) {
                        Text("🧠 Worplace Behavior Feedback")
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .padding(.top)
                            .glassEffect(.regular.tint(Theme.Colors.textPrimary.opacity(0.05)), in: RoundedRectangle(cornerRadius: 8))
                            .glassEffectID("feedback-title", in: glassNamespace)
                    } else {
                        Text("🧠 Worplace Behavior Feedback")
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .padding(.top)
                    }

                    Group {
                        behaviorRatingRow(title: "Collaboration", rating: $collaborationRating)
                        behaviorRatingRow(title: "Punctuality", rating: $punctualityRating)
                        behaviorRatingRow(title: "Problem-Solving", rating: $problemSolvingRating)
                    }

                    VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                        Text("Additional Comments")
                            .font(Theme.Typography.body)
                        TextEditor(text: $comments)
                            .frame(height: 120)
                            .padding(8)
                            .applyCommentsGlassEffect()
                    }

                    Toggle(isOn: $isAnonymous) {
                        Text("Submit as Anonymous")
                            .font(Theme.Typography.caption)
                    }
                    .padding(.horizontal)

                    Button(action: submitFeedback) {
                        CustomButton(title: "Submit Feedback")
                    }
                    .padding(.top)

                    if submissionSuccess {
                        if #available(iOS 18.0, *) {
                            Text("✅ Feedback submitted successfully!")
                                .font(Theme.Typography.caption)
                                .foregroundColor(.green)
                                .glassEffect(.regular.tint(.green.opacity(0.1)), in: RoundedRectangle(cornerRadius: 8))
                                .glassEffectID("success-message", in: glassNamespace)
                                .transition(.opacity)
                        } else {
                            Text("✅ Feedback submitted successfully!")
                                .font(Theme.Typography.caption)
                                .foregroundColor(.green)
                                .transition(.opacity)
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .background(Theme.Colors.background)
            .navigationTitle("Behavior Feedback")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Workplace Behavior Rating Row

    private func behaviorRatingRow(title: String, rating: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textPrimary)
            HStack(spacing: 8) {
                ForEach(1 ... 5, id: \ .self) { value in
                    if #available(iOS 18.0, *) {
                        Image(systemName: value <= rating.wrappedValue ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(value <= rating.wrappedValue ? .yellow : .gray)
                            .glassEffect(.regular.tint(value <= rating.wrappedValue ? .yellow.opacity(0.2) : .gray.opacity(0.1)), in: Circle())
                            .glassEffectID("star-\(value)", in: glassNamespace)
                            .onTapGesture {
                                rating.wrappedValue = value
                            }
                    } else {
                        Image(systemName: value <= rating.wrappedValue ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(value <= rating.wrappedValue ? .yellow : .gray)
                            .onTapGesture {
                                rating.wrappedValue = value
                            }
                    }
                }
            }
        }
    }

    // MARK: - Submit Feedback Action

    private func submitFeedback() {
        // Placeholder logic: In production, connect to FirestoreService
        withAnimation {
            submissionSuccess = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            submissionSuccess = false
        }
        // 🔐 Optional: log to FirestoreService.submitBehaviorFeedback(...)
    }
}

#Preview {
    WorkplaceBehaviorFeedbackView()
}

// MARK: - iOS 18 Liquid Glass Helper Extensions

extension View {
    /// Apply comments glass effect with iOS 18 Liquid Glass
    func applyCommentsGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(Theme.Colors.card.opacity(0.3)), in: RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
        } else {
            return self.background(Theme.Colors.card)
                .cornerRadius(Theme.CornerRadius.medium)
        }
    }
}
