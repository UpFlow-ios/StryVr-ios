//
//  SkillStreaksView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  🔥 Skill Streaks View – Track Learning Consistency & Motivation
//

import Foundation
import Lottie
import SwiftUI

struct SkillStreaksView: View {
    @State private var currentStreak: Int = 5
    @State private var bestStreak: Int = 12
    @State private var dailyGoalCompleted: Bool = false
    @State private var showConfetti: Bool = false

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.large) {
                // MARK: - Streak Stats

                VStack(spacing: Theme.Spacing.small) {
                    Text("Current Streak")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)

                    Text("\(currentStreak) Days 🔥")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.accent)

                    Text("Best Streak: \(bestStreak) Days 🏆")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Divider()

                // MARK: - Today's Goal

                VStack(spacing: Theme.Spacing.medium) {
                    Text("Today's Goal")
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text("✅ Complete 1 Learning Module")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)

                    Button(action: completeDailyGoal) {
                        Text(dailyGoalCompleted ? "Goal Completed!" : "Mark as Done")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.whiteText)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(dailyGoalCompleted ? Color.green : Theme.Colors.accent)
                            .cornerRadius(Theme.CornerRadius.medium)
                            .animation(.easeInOut, value: dailyGoalCompleted)
                    }
                    .disabled(dailyGoalCompleted)
                }
                .padding()

                Spacer()
            }
            .padding()

            // MARK: - Confetti Celebration

            if showConfetti {
                LottieAnimationView(animationName: "confetti", loopMode: .playOnce)
                    .frame(width: 300, height: 300)
                    .transition(.scale)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showConfetti = false
                            }
                        }
                    }
            }
        }
        .navigationTitle("Skill Streaks")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Handle Daily Goal Completion

    private func completeDailyGoal() {
        dailyGoalCompleted = true
        currentStreak += 1

        if currentStreak > bestStreak {
            bestStreak = currentStreak
        }

        withAnimation {
            showConfetti = true
        }
    }
}

#Preview {
    SkillStreaksView()
}
