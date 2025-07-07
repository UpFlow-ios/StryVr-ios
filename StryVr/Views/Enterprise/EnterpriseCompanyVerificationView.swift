//
//  EnterpriseCompanyVerificationView.swift
//  StryVr
//
//  🏢 Verified Company Onboarding – Secure Access to Enterprise Features
//

import SwiftUI

struct EnterpriseCompanyVerificationView: View {
    @State private var companyName: String = ""
    @State private var companyWebsite: String = ""
    @State private var linkedInURL: String = ""
    @State private var businessEmail: String = ""
    @State private var verificationSubmitted = false
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    // MARK: - Header
                    Text("Company Verification")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .padding(.top, Theme.Spacing.large)

                    Text(
                        "Apply to verify your organization and unlock enterprise tools like recruiting dashboards, top learner access"
                    )
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.leading)

                    // MARK: - Form Fields
                    Group {
                        customField("Company Name", text: $companyName)
                        customField("Official Website", text: $companyWebsite)
                        customField("LinkedIn URL", text: $linkedInURL)
                        customField("Business Email", text: $businessEmail)
                    }

                    // MARK: - Submit Button
                    Button(action: submitApplication) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(
                                    CircularProgressViewStyle(tint: Theme.Colors.accent))
                        } else {
                            Text("Submit Verification Request")
                                .font(Theme.Typography.body)
                                .foregroundColor(Theme.Colors.whiteText)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Theme.Colors.accent)
                                .cornerRadius(Theme.CornerRadius.medium)
                        }
                    }
                    .disabled(isLoading || !formValid())

                    if verificationSubmitted {
                        Text("✅ Your request has been submitted for review.")
                            .font(Theme.Typography.caption)
                            .foregroundColor(.green)
                            .padding(.top, Theme.Spacing.medium)
                    }

                    Spacer()
                }
                .padding()
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Verify Company")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Input Field Generator
    private func customField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .textContentType(.URL)
            .keyboardType(.URL)
            .autocapitalization(.none)
            .padding()
            .background(Theme.Colors.card)
            .cornerRadius(Theme.CornerRadius.medium)
            .foregroundColor(Theme.Colors.textPrimary)
            .accessibilityLabel(placeholder)
    }

    // MARK: - Form Validation
    private func formValid() -> Bool {
        return !companyName.isEmpty && !companyWebsite.isEmpty && !linkedInURL.isEmpty
            && !businessEmail.isEmpty
    }

    // MARK: - Submit Logic (Mock Logic for Now)
    private func submitApplication() {
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            verificationSubmitted = true
            isLoading = false

            // In production: send data to Firestore / Admin Review Queue
        }
    }
}

#Preview {
    EnterpriseCompanyVerificationView()
}
