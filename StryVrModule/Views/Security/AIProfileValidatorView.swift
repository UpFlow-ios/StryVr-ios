//
//  AIProfileValidatorView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//  🤖 AI Profile Validation Screen – Authenticity Check with Real-Time Feedback
//

import SwiftUI

/// StryVr's AI-powered profile authenticity validator
struct AIProfileValidatorView: View {
    @StateObject private var viewModel = ProfileValidatorViewModel()

    var body: some View {
        VStack(spacing: Theme.Spacing.large) {
            // MARK: - Title

            Text("AI Profile Validator")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
                .accessibilityLabel("AI profile validator")
                .accessibilityHint("Displays the AI profile validation screen")

            // MARK: - Validation State

            if viewModel.isValidating {
                ProgressView("Validating...")
                    .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                    .padding()
                    .transition(.opacity)
                    .accessibilityLabel("Validation in progress")
            } else if let result = viewModel.validationResult {
                Text(result)
                    .font(Theme.Typography.body)
                    .foregroundColor(result.localizedCaseInsensitiveContains("valid") ? .green : .red)
                    .multilineTextAlignment(.center)
                    .padding()
                    .transition(.opacity)
                    .accessibilityLabel("Validation result: \(result)")
                    .accessibilityHint("Displays the result of the profile validation")
            } else if let error = viewModel.validationError {
                Text(error)
                    .font(Theme.Typography.body)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                    .transition(.opacity)
                    .accessibilityLabel("Validation error: \(error)")
                    .accessibilityHint("Displays an error message if validation fails")
            } else {
                Text("No validation result available")
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding()
                    .accessibilityLabel("No validation result")
                    .accessibilityHint("Indicates that no validation result is currently available")
            }

            // MARK: - Trigger Button

            Button(action: viewModel.validateProfile) {
                Text("Validate Profile")
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.whiteText)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.Colors.accent)
                    .cornerRadius(Theme.CornerRadius.medium)
                    .accessibilityLabel("Validate profile button")
                    .accessibilityHint("Starts the profile validation process")
            }

            Spacer()
        }
        .padding(.horizontal, Theme.Spacing.large)
        .padding(.top, Theme.Spacing.large)
        .background(Theme.Colors.background.ignoresSafeArea())
        .animation(.easeInOut, value: viewModel.isValidating)
    }
}

#Preview {
    AIProfileValidatorView()
}
