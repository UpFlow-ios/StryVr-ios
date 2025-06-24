//
//  CompanySecurityVerificationView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/8/25.
//  🏢 Trusted Company Verification Interface – Secure & Scalable
//

import SwiftUI

struct CompanySecurityVerificationView: View {
    @State private var companyName: String = ""
    @State private var companyID: String = ""
    @State private var verificationStatus: String = "Pending"
    @State private var showError: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.large) {
                // MARK: - Header

                Text("Company Verification")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.top)
                    .accessibilityLabel("Company verification screen")
                    .accessibilityHint("Enter company details to verify")

                // MARK: - Company Name Field

                TextField("Company Name", text: $companyName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .accessibilityLabel("Company name field")
                    .accessibilityHint("Enter the name of the company")

                // MARK: - Registration ID Field

                TextField("Company Registration ID", text: $companyID)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .accessibilityLabel("Company registration ID field")
                    .accessibilityHint("Enter the registration ID of the company")

                // MARK: - Verify Button

                Button(action: verifyCompany) {
                    Text("Verify Company")
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.whiteText)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Theme.Colors.accent)
                        .cornerRadius(Theme.CornerRadius.medium)
                        .padding(.horizontal)
                        .accessibilityLabel("Verify company button")
                        .accessibilityHint("Tap to verify the company details")
                }
                .alert(isPresented: $showError) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Please fill in all fields before verifying."),
                        dismissButton: .default(Text("OK"))
                    )
                }

                // MARK: - Verification Status

                Text("Status: \(verificationStatus)")
                    .font(Theme.Typography.caption)
                    .foregroundColor(verificationStatus == "Verified ✅" ? .green : .orange)
                    .padding(.top, Theme.Spacing.small)
                    .accessibilityLabel("Verification status: \(verificationStatus)")
                    .accessibilityHint("Displays the current verification status")

                Spacer()
            }
            .padding(.vertical, Theme.Spacing.large)
        }
        .background(Theme.Colors.background.ignoresSafeArea())
        .navigationTitle("Verify Business")
    }

    // MARK: - Placeholder Verification Logic

    private func verifyCompany() {
        guard !companyName.isEmpty, !companyID.isEmpty else {
            showError = true
            return
        }
        // 🔐 Future: Connect to Crunchbase / LinkedIn API or internal backend
        verificationStatus = "Verified ✅"
        print("✅ Company '\(companyName)' verified with ID '\(companyID)'")
    }
}

#Preview {
    CompanySecurityVerificationView()
}
