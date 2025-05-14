//
//  AIProfileValidator.swift
//  StryVr
//
//  Created by Joe Dormond on 3/5/25.
//
import Foundation
import Combine

/// Handles AI-powered profile validation
final class ProfileValidatorViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isValidating = false
    @Published var validationResult: String?
    @Published var validationError: String?

    // MARK: - Dependencies
    private let validationService: ProfileValidationServiceProtocol

    // MARK: - Initialization
    init(validationService: ProfileValidationServiceProtocol = MockProfileValidationService()) {
        self.validationService = validationService
    }

    // MARK: - Methods
    /// Validates the profile using the provided validation service
    func validateProfile() {
        isValidating = true
        validationError = nil
        validationService.validate { [weak self] result in
            DispatchQueue.main.async {
                self?.isValidating = false
                switch result {
                case .success(let isValid):
                    self?.validationResult = isValid ? "✅ Profile is Valid" : "❌ Profile is Suspicious"
                case .failure(let error):
                    self?.validationError = "⚠️ Validation failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

// MARK: - Protocol for Validation Service
protocol ProfileValidationServiceProtocol {
    func validate(completion: @escaping (Result<Bool, Error>) -> Void)
}

// MARK: - Mock Validation Service (for testing)
struct MockProfileValidationService: ProfileValidationServiceProtocol {
    func validate(completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            completion(.success(Bool.random()))
        }
    }
}
