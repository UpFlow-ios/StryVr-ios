//
//  CompanyVerificationView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/8/25.
//
import SwiftUI

struct CompanyVerificationView: View {
    @State private var companyName: String = ""
    @State private var companyID: String = ""
    @State private var verificationStatus: String = "Pending"

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Company Verification")
                    .font(.largeTitle)
                    .bold()

                TextField("Company Name", text: $companyName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .accessibilityLabel("Company Name TextField")

                TextField("Company Registration ID", text: $companyID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .accessibilityLabel("Company Registration ID TextField")

                Button(action: verifyCompany) {
                    Text("Verify Company")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .accessibilityLabel("Verify Company Button")

                Text("Status: \(verificationStatus)")
                    .font(.headline)
                    .accessibilityLabel("Verification Status: \(verificationStatus)")
            }
            .padding()
        }
    }

    private func verifyCompany() {
        verificationStatus = "Verified ✅"
        print("Company \(companyName) verified!")
    }
}

struct CompanyVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyVerificationView()
    }
}
