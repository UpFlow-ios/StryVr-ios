//
//  CertificationView.swift
//  StryVr
//
//  🏆 Certification Screen – Award Certificate Upon Learning Path Completion
//

import SwiftUI

struct CertificationView: View {
    let userName: String
    let learningPathName: String
    let completionDate: Date

    @State private var showConfetti = true

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: completionDate)
    }

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.large) {
                Spacer()

                // MARK: - Certification Card
                VStack(spacing: Theme.Spacing.medium) {
                    Text("🎉 Congratulations!")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.accent)

                    Text("This certifies that")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)

                    Text(userName)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text("has successfully completed")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)

                    Text(learningPathName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Theme.Colors.accent)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.large)

                    Text("on \(formattedDate)")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Theme.Colors.card)
                .cornerRadius(Theme.CornerRadius.large)
                .shadow(color: Theme.Colors.accent.opacity(0.08), radius: 10, x: 0, y: 5)

                Spacer()

                // MARK: - Done Button
                Button(action: {
                    withAnimation {
                        showConfetti = false
                    }
                }) {
                    Text("Done")
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.whiteText)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Theme.Colors.accent)
                        .cornerRadius(Theme.CornerRadius.medium)
                }
                .padding(.bottom, Theme.Spacing.large)
                .padding(.horizontal, Theme.Spacing.large)
            }
            .padding()

            // MARK: - Confetti Animation
            if showConfetti {
                LottieAnimationView(animationName: "confetti", loopMode: .playOnce)
                    .frame(width: 300, height: 300)
                    .transition(.scale)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                showConfetti = false
                            }
                        }
                    }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    CertificationView(
        userName: "Joe Dormond",
        learningPathName: "iOS Developer Path",
        completionDate: Date()
    )
}
