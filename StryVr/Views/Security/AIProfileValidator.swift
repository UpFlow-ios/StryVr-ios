//
//  AIProfileValidator.swift
//  StryVr
//
//  Created by Joe Dormond on 3/5/25.
//
import SwiftUI

class ProfileValidatorViewModel: ObservableObject {
    @Published var isValidating = false
    @Published var validationResult: String?

    func validateProfile() {
        isValidating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.validationResult = Bool.random() ? "Profile is Valid ✅" : "Profile is Suspicious ❌"
            self.isValidating = false
        }
    }
}

struct AIProfileValidatorView: View {
    @StateObject private var viewModel = ProfileValidatorViewModel()

    var body: some View {
        VStack {
            Text("AI Profile Validator")
                .font(.title)
                .fontWeight(.bold)

            if viewModel.isValidating {
                ProgressView("Validating...")
                    .padding()
            } else if let result = viewModel.validationResult {
                Text(result)
                    .foregroundColor(result.contains("Valid") ? .green : .red)
                    .padding()
            }

            Button(action: viewModel.validateProfile) {
                Text("Validate Profile")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .accessibilityLabel("Validate Profile Button")
        }
        .padding()
    }
}

struct AIProfileValidatorView_Previews: PreviewProvider {
    static var previews: some View {
        AIProfileValidatorView()
    }
}
