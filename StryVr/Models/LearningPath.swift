import Foundation

struct LearningPath: Identifiable, Codable, Hashable {
    let id = UUID()
    let title: String
    let progress: Int
    let description: String?
    let category: String?
    let estimatedHours: Int?
    let completedModules: Int?
    let totalModules: Int?

    init(
        title: String, progress: Int, description: String? = nil, category: String? = nil,
        estimatedHours: Int? = nil, completedModules: Int? = nil, totalModules: Int? = nil
    ) {
        self.title = title
        self.progress = progress
        self.description = description
        self.category = category
        self.estimatedHours = estimatedHours
        self.completedModules = completedModules
        self.totalModules = totalModules
    }
}
