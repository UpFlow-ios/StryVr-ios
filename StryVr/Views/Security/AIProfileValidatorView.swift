//
//  AIProfileValidatorView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//

import SwiftUI

/// StryVr's AI-powered profile authenticity validator
struct AIProfileValidatorView: View {
    @StateObject private var viewModel = ProfileValidatorViewModel()

    var body: some View {
        VStack(spacing: Spacing.large) {
            Text("AI Profile Validator")
                .font(FontStyle.title)
                .foregroundColor(.whiteText)

            if viewModel.isValidating {
                ProgressView("Validating...")
                    .padding()
                    .progressViewStyle(CircularProgressViewStyle(tint: .neonBlue))
                    .transition(.opacity)
            } else if let result = viewModel.validationResult {
                Text(result)
                    .font(FontStyle.body)
                    .foregroundColor(result.contains("Valid") ? .green : .red)
                    .padding()
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
            } else if let error = viewModel.validationError {
                Text(error)
                    .font(FontStyle.body)
                    .foregroundColor(.red)
                    .padding()
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
            }

            Button(action: viewModel.validateProfile) {
                Text("Validate Profile")
                    .font(FontStyle.body)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.neonBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .accessibilityLabel("Validate Profile Button")
        }
        .padding(.horizontal, Spacing.large)
        .padding(.top, Spacing.large)
        .background(Color.background.ignoresSafeArea())
        .animation(.easeInOut, value: viewModel.isValidating)
    }
}
