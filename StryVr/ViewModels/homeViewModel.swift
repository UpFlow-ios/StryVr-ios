//
//  HomeViewModel.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//  📈 Optimized for Performance, Scalability, and Maintainability
//

import Combine
import Foundation
import os.log

final class HomeViewModel: ObservableObject {
    
    @Published private(set) var skills: [Skill] = []
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchSkills()
    }

    // MARK: - Fetch Skills from SkillService
    /// Fetches skills from the `SkillService` and updates the `skills` property.
    func fetchSkills() {
        SkillService.shared.fetchSkills()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.handleFetchError(error)
                }
            }, receiveValue: { [weak self] skills in
                self?.skills = skills
                os_log("✅ HomeViewModel - Skills fetched successfully: %{public}d items", skills.count)
            })
            .store(in: &cancellables)
    }

    // MARK: - Private Helper for Error Handling
    /// Handles errors during the fetch operation and updates the `errorMessage`.
    /// - Parameter error: The error encountered during the fetch operation.
    private func handleFetchError(_ error: Error) {
        self.errorMessage = "Failed to fetch skills: \(error.localizedDescription)"
        os_log("❌ HomeViewModel - Error fetching skills: %{public}@", log: .default, type: .error, error.localizedDescription)
    }
}
