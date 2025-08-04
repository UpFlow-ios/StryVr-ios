import FirebaseFirestore
import Foundation
import OSLog

@MainActor
class UserAlgorithmService: ObservableObject {
    private let logger = Logger(subsystem: "com.stryvr.app", category: "UserAlgorithmService")

    @Published var userInsights: UserInsights?
    @Published var personalizedRecommendations: [Recommendation] = []
    @Published var careerPathSuggestions: [CareerPath] = []
    @Published var skillGapAnalysis: SkillGapAnalysis?

    private let db = Firestore.firestore()
    private let subscriptionService: SubscriptionService

    init(subscriptionService: SubscriptionService) {
        self.subscriptionService = subscriptionService
        Task {
            await loadUserInsights()
            await generateRecommendations()
        }
    }

    // MARK: - User Behavior Tracking
    func trackUserAction(_ action: UserAction) async {
        logger.info("Tracking user action: \(action.type.rawValue)")

        // Update subscription service behavior tracking
        switch action.type {
        case .featureUsed:
            if let feature = action.feature {
                subscriptionService.trackFeatureUsage(feature)
            }
        case .goalProgress:
            if let progress = action.progress {
                subscriptionService.trackGoalProgress(action.goalType ?? "", progress: progress)
            }
        case .skillInteraction:
            if let timeSpent = action.timeSpent {
                subscriptionService.trackSkillInteraction(
                    action.skillName ?? "", timeSpent: timeSpent)
            }
        case .careerPathExplored:
            if let path = action.careerPath {
                subscriptionService.trackCareerPathExploration(path)
            }
        case .feedbackGiven:
            if let feedback = action.feedback, let rating = action.rating {
                subscriptionService.trackFeedbackGiven(feedback, rating: rating)
            }
        }

        // Save behavior data
        await saveUserBehavior()

        // Regenerate insights and recommendations
        await loadUserInsights()
        await generateRecommendations()
    }

    // MARK: - Algorithm Insights
    private func loadUserInsights() async {
        userInsights = subscriptionService.getUserInsights()
        logger.info("Loaded user insights")
    }

    private func generateRecommendations() async {
        guard let insights = userInsights else { return }

        // Generate personalized recommendations based on user behavior
        var recommendations: [Recommendation] = []

        // Skill-based recommendations
        if let topSkill = insights.topSkills.first {
            recommendations.append(
                Recommendation(
                    type: .skillDevelopment,
                    title: "Master \(topSkill)",
                    description:
                        "Based on your interest in \(topSkill), here are advanced techniques to excel.",
                    priority: .high,
                    estimatedTime: "2-3 hours/week",
                    difficulty: .intermediate
                ))
        }

        // Feature-based recommendations
        if let mostUsedFeature = insights.mostUsedFeature {
            recommendations.append(
                Recommendation(
                    type: .featureOptimization,
                    title: "Optimize \(mostUsedFeature)",
                    description:
                        "You're already using this feature frequently. Here's how to get even more value.",
                    priority: .medium,
                    estimatedTime: "30 minutes",
                    difficulty: .beginner
                ))
        }

        // Goal-based recommendations
        if insights.goalsCompleted > 0 {
            recommendations.append(
                Recommendation(
                    type: .goalSetting,
                    title: "Set Your Next Milestone",
                    description:
                        "You've completed \(insights.goalsCompleted) goals. Time to challenge yourself further.",
                    priority: .high,
                    estimatedTime: "15 minutes",
                    difficulty: .beginner
                ))
        }

        // Career path recommendations
        if !insights.careerPathsExplored.isEmpty {
            recommendations.append(
                Recommendation(
                    type: .careerGrowth,
                    title: "Explore New Career Paths",
                    description: "Based on your interests, here are emerging career opportunities.",
                    priority: .medium,
                    estimatedTime: "1 hour",
                    difficulty: .beginner
                ))
        }

        personalizedRecommendations = recommendations

        // Generate career path suggestions
        await generateCareerPathSuggestions(insights: insights)

        // Generate skill gap analysis
        await generateSkillGapAnalysis(insights: insights)
    }

    private func generateCareerPathSuggestions(insights: UserInsights) async {
        var suggestions: [CareerPath] = []

        // Analyze user preferences and skills
        let hasTechnicalSkills = insights.topSkills.contains { skill in
            ["Programming", "Data Analysis", "AI/ML", "Cybersecurity"].contains(skill)
        }

        let hasLeadershipSkills = insights.topSkills.contains { skill in
            ["Leadership", "Management", "Communication", "Team Building"].contains(skill)
        }

        let hasCreativeSkills = insights.topSkills.contains { skill in
            ["Design", "Marketing", "Content Creation", "Branding"].contains(skill)
        }

        // Generate career paths based on skills and preferences
        if hasTechnicalSkills {
            suggestions.append(
                CareerPath(
                    title: "Technical Leadership",
                    description: "Combine your technical skills with leadership abilities",
                    skills: ["Technical Architecture", "Team Leadership", "Project Management"],
                    estimatedGrowth: "25% salary increase potential",
                    timeToAchieve: "2-3 years",
                    difficulty: .advanced
                ))
        }

        if hasLeadershipSkills {
            suggestions.append(
                CareerPath(
                    title: "Executive Leadership",
                    description: "Move into senior management and executive roles",
                    skills: [
                        "Strategic Planning", "Business Development", "Executive Communication"
                    ],
                    estimatedGrowth: "40% salary increase potential",
                    timeToAchieve: "3-5 years",
                    difficulty: .advanced
                ))
        }

        if hasCreativeSkills {
            suggestions.append(
                CareerPath(
                    title: "Creative Director",
                    description: "Lead creative teams and drive innovation",
                    skills: ["Creative Strategy", "Team Management", "Brand Development"],
                    estimatedGrowth: "30% salary increase potential",
                    timeToAchieve: "2-4 years",
                    difficulty: .intermediate
                ))
        }

        careerPathSuggestions = suggestions
    }

    private func generateSkillGapAnalysis(insights: UserInsights) async {
        // Analyze current skills vs. desired career paths
        let currentSkills = Set(insights.topSkills)
        let targetSkills = Set(careerPathSuggestions.flatMap { $0.skills })
        let missingSkills = targetSkills.subtracting(currentSkills)

        skillGapAnalysis = SkillGapAnalysis(
            currentSkills: Array(currentSkills),
            targetSkills: Array(targetSkills),
            missingSkills: Array(missingSkills),
            prioritySkills: Array(missingSkills.prefix(3)),
            estimatedTimeToAcquire: "6-12 months",
            recommendedLearningPath: generateLearningPath(missingSkills: Array(missingSkills))
        )
    }

    private func generateLearningPath(missingSkills: [String]) -> [LearningStep] {
        return missingSkills.enumerated().map { index, skill in
            LearningStep(
                order: index + 1,
                skill: skill,
                estimatedTime: "2-4 weeks",
                resources: ["Online courses", "Practice projects", "Mentorship"],
                difficulty: .intermediate
            )
        }
    }

    // MARK: - Data Persistence
    private func saveUserBehavior() async {
        guard let userId = AuthService.shared.currentUser?.uid else { return }

        do {
            let behaviorData = subscriptionService.userBehavior
            try await db.collection("userBehavior").document(userId).setData(from: behaviorData)
            logger.info("Saved user behavior data")
        } catch {
            logger.error("Failed to save user behavior: \(error.localizedDescription)")
        }
    }

    // MARK: - Public API
    func refreshInsights() async {
        await loadUserInsights()
        await generateRecommendations()
    }

    func getPersonalizedContent() -> PersonalizedContent {
        return PersonalizedContent(
            recommendations: personalizedRecommendations,
            careerPaths: careerPathSuggestions,
            skillGapAnalysis: skillGapAnalysis,
            userInsights: userInsights
        )
    }
}

// MARK: - User Action Model
struct UserAction {
    let type: UserActionType
    let feature: SubscriptionFeature?
    let goalType: String?
    let progress: Double?
    let skillName: String?
    let timeSpent: TimeInterval?
    let careerPath: String?
    let feedback: String?
    let rating: Int?
    let timestamp: Date

    init(
        type: UserActionType, feature: SubscriptionFeature? = nil, goalType: String? = nil,
        progress: Double? = nil, skillName: String? = nil, timeSpent: TimeInterval? = nil,
        careerPath: String? = nil, feedback: String? = nil, rating: Int? = nil
    ) {
        self.type = type
        self.feature = feature
        self.goalType = goalType
        self.progress = progress
        self.skillName = skillName
        self.timeSpent = timeSpent
        self.careerPath = careerPath
        self.feedback = feedback
        self.rating = rating
        self.timestamp = Date()
    }
}

enum UserActionType: String, CaseIterable {
    case featureUsed = "feature_used"
    case goalProgress = "goal_progress"
    case skillInteraction = "skill_interaction"
    case careerPathExplored = "career_path_explored"
    case feedbackGiven = "feedback_given"
}

// MARK: - Recommendation Model
struct Recommendation: Identifiable, Codable {
    let id = UUID()
    let type: RecommendationType
    let title: String
    let description: String
    let priority: Priority
    let estimatedTime: String
    let difficulty: Difficulty

    enum RecommendationType: String, CaseIterable, Codable {
        case skillDevelopment = "skill_development"
        case featureOptimization = "feature_optimization"
        case goalSetting = "goal_setting"
        case careerGrowth = "career_growth"
        case networking = "networking"
        case certification = "certification"
    }

    enum Priority: String, CaseIterable, Codable {
        case low
        case medium
        case high
        case critical
    }

    enum Difficulty: String, CaseIterable, Codable {
        case beginner
        case intermediate
        case advanced
        case expert
    }
}

// MARK: - Career Path Model
struct CareerPath: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let skills: [String]
    let estimatedGrowth: String
    let timeToAchieve: String
    let difficulty: Recommendation.Difficulty
}

// MARK: - Skill Gap Analysis Model
struct SkillGapAnalysis: Codable {
    let currentSkills: [String]
    let targetSkills: [String]
    let missingSkills: [String]
    let prioritySkills: [String]
    let estimatedTimeToAcquire: String
    let recommendedLearningPath: [LearningStep]
}

struct LearningStep: Identifiable, Codable {
    let id = UUID()
    let order: Int
    let skill: String
    let estimatedTime: String
    let resources: [String]
    let difficulty: Recommendation.Difficulty
}

// MARK: - Personalized Content Model
struct PersonalizedContent {
    let recommendations: [Recommendation]
    let careerPaths: [CareerPath]
    let skillGapAnalysis: SkillGapAnalysis?
    let userInsights: UserInsights?
}
