//
//  SkillVerificationView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/5/25.
//  ✅ AI Skill Validation UI – Scalable Verification & Feedback Layer
//

import SwiftUI

// MARK: - ViewModel
class SkillVerificationViewModel: ObservableObject {
    @Published var skillName: String = ""
    @Published var isVerifying = false
    @Published var verificationResult: String?

    func verifySkill() {
        guard !skillName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        isVerifying = true

        // 🔐 Future: Replace with AI/HuggingFace or Firestore call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.verificationResult = Bool.random() ? "✅ Skill Verified" : "❌ Verification Failed"
            self.isVerifying = false
        }
    }
}

// MARK: - View
struct SkillVerificationView: View {
    @StateObject private var viewModel = SkillVerificationViewModel()

    var body: some View {
        VStack(spacing: Theme.Spacing.large) {

            // MARK: - Title
            Text("Skill Verification")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
                .accessibilityLabel("Skill verification title")
                .accessibilityHint("Enter a skill to verify its authenticity")

            // MARK: - Input Field
            TextField("Enter skill to verify", text: $viewModel.skillName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .accessibilityLabel("Skill name input")
                .accessibilityHint("Enter the name of the skill you want to verify")

            // MARK: - Action Button
            Button(action: viewModel.verifySkill) {
                Text("Verify Skill")
                    .font(Theme.Typography.body)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.Colors.accent)
                    .foregroundColor(Theme.Colors.whiteText)
                    .cornerRadius(Theme.CornerRadius.medium)
                    .padding(.horizontal)
            }
            .disabled(viewModel.skillName.trimmingCharacters(in: .whitespaces).isEmpty)
            .accessibilityLabel("Verify skill button")
            .accessibilityHint("Tap to verify the entered skill")

            // MARK: - Feedback
            if viewModel.isVerifying {
                ProgressView("Verifying...")
                    .padding()
                    .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                    .accessibilityLabel("Verifying skill")
            } else if let result = viewModel.verificationResult {
                Text(result)
                    .font(Theme.Typography.caption)
                    .foregroundColor(result.contains("Verified") ? .green : .red)
                    .padding()
                    .accessibilityLabel("Verification result: \(result)")
                    .accessibilityHint("Displays the result of the skill verification")
            }

            Spacer()
        }
        .padding(.top, Theme.Spacing.large)
        .background(Theme.Colors.background.ignoresSafeArea())
    }
}

// MARK: - Preview
#Preview {
    SkillVerificationView()
}
