//
//  HomeViewModel.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//  📈 Fully Optimized for Performance, Scalability, Robust Error Handling, and Maintainability
//

import Combine
import Foundation
import OSLog

final class HomeViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published private(set) var skills: [Skill] = []
    @Published var errorMessage: String?
    @Published private(set) var isLoading: Bool = false

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private let skillService: SkillServiceProtocol
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr.app", category: "HomeViewModel")

    // MARK: - Initialization

    init(skillService: SkillServiceProtocol = SkillService.shared) {
        self.skillService = skillService
        fetchSkills()
    }

    // MARK: - Fetch Skills from SkillService

    /// Fetches skills using `SkillService` with structured logging and error handling.
    func fetchSkills() {
        isLoading = true

        // Cast to SkillService to access the Combine method
        guard let skillService = skillService as? SkillService else {
            handleFetchError(NSError(domain: "HomeViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid skill service"]))
            return
        }

        skillService.fetchSkills()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.isLoading = false

                    switch completion {
                    case .finished:
                        self.logger.info("✅ Skills successfully fetched and loaded.")
                    case let .failure(error):
                        self.handleFetchError(error)
                    }
                },
                receiveValue: { [weak self] skills in
                    guard let self = self else { return }
                    self.skills = skills
                    self.logger.info("📦 Skills received: \(skills.count)")
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - Retry Fetch

    /// Retries fetching skills, useful for refresh actions.
    func retryFetchSkills() {
        fetchSkills()
        logger.info("♻️ Retry fetching skills triggered.")
    }

    // MARK: - Private Helper for Error Handling

    /// Handles fetch errors with detailed logging and user-facing messages.
    private func handleFetchError(_ error: Error) {
        errorMessage = "Unable to load skills. Please try again."
        logger.error("❌ Error fetching skills: \(error.localizedDescription, privacy: .public)")
    }
}
