import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var skills: [Skill] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchSkills()
    }
    
    func fetchSkills() {
        SkillService.shared.fetchSkills()
            .sink(receiveCompletion: { _ in }, receiveValue: { skills in
                self.skills = skills
            })
            .store(in: &cancellables)
    }
}
