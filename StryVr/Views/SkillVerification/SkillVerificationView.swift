//
//  SkillVerificationView.swift
//  StryVr
//
//  🧠 Skill Verification Quiz – Test and Certify Learning
//

import SwiftUI

struct SkillQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: String
}

struct SkillVerificationView: View {
    @State private var questions: [SkillQuestion] = [
        SkillQuestion(
            question: "What programming language is primarily used for iOS app development?",
            options: ["Swift", "Kotlin", "JavaScript", "Python"],
            correctAnswer: "Swift"
        ),
        SkillQuestion(
            question: "Which framework is used to build declarative UIs on iOS?",
            options: ["UIKit", "SwiftUI", "AppKit", "Foundation"],
            correctAnswer: "SwiftUI"
        ),
        SkillQuestion(
            question: "Which service would you use for real-time data syncing?",
            options: ["Firebase", "Core Data", "Realm", "SQLite"],
            correctAnswer: "Firebase"
        )
    ]

    @State private var currentQuestionIndex: Int = 0
    @State private var selectedOption: String?
    @State private var showResult = false
    @State private var passedQuiz = false

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.large) {
                Spacer()

                if currentQuestionIndex < questions.count {
                    // MARK: - Display Current Question
                    VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                        Text("Skill Verification Quiz")
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)

                        ProgressView(value: Double(currentQuestionIndex), total: Double(questions.count))
                            .progressViewStyle(LinearProgressViewStyle(tint: Theme.Colors.accent))
                            .scaleEffect(x: 1, y: 2, anchor: .center)

                        Text(questions[currentQuestionIndex].question)
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .padding(.top, Theme.Spacing.medium)

                        ForEach(questions[currentQuestionIndex].options, id: \.self) { option in
                            Button(action: {
                                selectedOption = option
                            }) {
                                HStack {
                                    Text(option)
                                        .font(Theme.Typography.body)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                    Spacer()
                                    if selectedOption == option {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(Theme.Colors.accent)
                                    }
                                }
                                .padding()
                                .background(Theme.Colors.card)
                                .cornerRadius(Theme.CornerRadius.medium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                        .stroke(selectedOption == option ? Theme.Colors.accent : Theme.Colors.card, lineWidth: 2)
                                )
                            }
                        }
                    }
                    .padding()
                } else {
                    // MARK: - Quiz Result
                    VStack(spacing: Theme.Spacing.medium) {
                        if passedQuiz {
                            Text("🎉 Skill Verified!")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Theme.Colors.accent)

                            Text("You've successfully passed the skill assessment.")
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.textSecondary)

                            LottieAnimationView(animationName: "confetti", loopMode: .playOnce)
                                .frame(width: 300, height: 300)
                        } else {
                            Text("❌ Verification Failed")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.red)

                            Text("Try reviewing the learning path and attempt again.")
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }

                        Button(action: restartQuiz) {
                            Text("Retry Quiz")
                                .font(Theme.Typography.body)
                                .foregroundColor(Theme.Colors.whiteText)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Theme.Colors.accent)
                                .cornerRadius(Theme.CornerRadius.medium)
                                .padding(.horizontal)
                        }
                        .padding(.top)
                    }
                    .padding()
                }

                Spacer()

                if currentQuestionIndex < questions.count {
                    Button(action: submitAnswer) {
                        Text("Submit Answer")
                            .font(Theme.Typography.body)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedOption == nil ? Color.gray : Theme.Colors.accent)
                            .cornerRadius(Theme.CornerRadius.medium)
                    }
                    .padding(.horizontal)
                    .disabled(selectedOption == nil)
                }
            }
            .padding()
        }
        .navigationTitle("Skill Verification")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Handle Answer Submission
    private func submitAnswer() {
        guard let selectedOption = selectedOption else { return }

        if selectedOption == questions[currentQuestionIndex].correctAnswer {
            // Correct Answer
        } else {
            passedQuiz = false
            currentQuestionIndex = questions.count // Immediately end the quiz on wrong answer
            return
        }

        currentQuestionIndex += 1

        if currentQuestionIndex == questions.count {
            passedQuiz = true
        }

        self.selectedOption = nil
    }

    // MARK: - Restart Quiz
    private func restartQuiz() {
        currentQuestionIndex = 0
        passedQuiz = false
        selectedOption = nil
    }
}

#Preview {
    SkillVerificationView()
}
