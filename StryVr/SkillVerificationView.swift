//
//  SkillVerificationView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/5/25.
//
import SwiftUI

class SkillVerificationViewModel: ObservableObject {
    @Published var skillName: String = ""
    @Published var isVerifying = false
    @Published var verificationResult: String?

    func verifySkill() {
        isVerifying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.verificationResult = Bool.random() ? "Skill Verified ✅" : "Verification Failed ❌"
            self.isVerifying = false
        }
    }
}

struct SkillVerificationView: View {
    @StateObject private var viewModel = SkillVerificationViewModel()

    var body: some View {
        VStack {
            Text("Skill Verification")
                .font(.title)
                .fontWeight(.bold)
                .accessibilityLabel("Skill Verification Title")

            TextField("Enter skill to verify", text: $viewModel.skillName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .accessibilityLabel("Skill Name TextField")

            Button(action: viewModel.verifySkill) {
                Text("Verify Skill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .accessibilityLabel("Verify Skill Button")
            }
            .padding()

            if viewModel.isVerifying {
                ProgressView("Verifying...")
                    .padding()
                    .accessibilityLabel("Verifying ProgressView")
            } else if let result = viewModel.verificationResult {
                Text(result)
                    .foregroundColor(result.contains("Verified") ? .green : .red)
                    .padding()
                    .accessibilityLabel("Verification Result Text")
            }
        }
        .padding()
    }
}

    static var previews: some View {
struct SkillVerificationView_Previews: PreviewProvider {
        SkillVerificationView()
    }
}
