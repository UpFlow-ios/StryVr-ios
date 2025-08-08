//
//  AICoachingService.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  🎯 Revolutionary AI-Powered 1:1 Coaching System
//  🚀 Real-Time Performance Tracking & Career Path Mapping
//

import Foundation
import Combine

@MainActor
class AICoachingService: ObservableObject {
    static let shared = AICoachingService()
    
    @Published var activeCoachingSessions: [CoachingSession] = []
    @Published var coachingInsights: [CoachingInsight] = []
    @Published var careerPathRecommendations: [CareerPathRecommendation] = []
    @Published var performanceMetrics: PerformanceMetrics = PerformanceMetrics()
    @Published var currentCoachingPrompts: [CoachingPrompt] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupRealtimeCoaching()
    }
    
    // MARK: - Real-Time Coaching During Calls
    
    func startCoachingSession(for callId: String, participantRole: ParticipantRole) {
        let session = CoachingSession(
            callId: callId,
            participantRole: participantRole,
            startTime: Date(),
            coachingFocus: determineCoachingFocus(for: participantRole),
            realTimePrompts: []
        )
        
        activeCoachingSessions.append(session)
        generateInitialCoachingPrompts(for: session)
    }
    
    func endCoachingSession(_ sessionId: String) {
        guard let sessionIndex = activeCoachingSessions.firstIndex(where: { $0.id == sessionId }) else { return }
        
        var session = activeCoachingSessions[sessionIndex]
        session.endTime = Date()
        session.performanceScore = calculatePerformanceScore(for: session)
        
        // Generate post-session insights
        generatePostSessionInsights(for: session)
        
        // Update career path recommendations
        updateCareerPathRecommendations(based: session)
        
        activeCoachingSessions.remove(at: sessionIndex)
    }
    
    func processRealTimeInput(_ input: RealTimeCoachingInput) {
        guard let sessionIndex = activeCoachingSessions.firstIndex(where: { $0.callId == input.callId }) else { return }
        
        // Analyze communication patterns
        let communicationAnalysis = analyzeCommunicationPatterns(input)
        
        // Generate contextual coaching prompts
        let newPrompts = generateContextualPrompts(
            based: communicationAnalysis,
            for: activeCoachingSessions[sessionIndex]
        )
        
        // Update session with real-time data
        activeCoachingSessions[sessionIndex].realTimePrompts.append(contentsOf: newPrompts)
        activeCoachingSessions[sessionIndex].communicationMetrics.append(communicationAnalysis)
        
        // Publish new prompts
        currentCoachingPrompts = newPrompts
    }
    
    // MARK: - Performance Tracking
    
    func trackPerformanceMetric(_ metric: PerformanceMetricType, value: Double, context: String) {
        let entry = PerformanceEntry(
            metric: metric,
            value: value,
            timestamp: Date(),
            context: context
        )
        
        performanceMetrics.addEntry(entry)
        
        // Check for improvement patterns
        if let improvement = detectImprovement(for: metric) {
            generateImprovementInsight(improvement)
        }
    }
    
    func getPerformanceHistory(for metric: PerformanceMetricType, days: Int = 30) -> [PerformanceEntry] {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        
        return performanceMetrics.entries
            .filter { $0.metric == metric && $0.timestamp >= cutoffDate }
            .sorted { $0.timestamp < $1.timestamp }
    }
    
    // MARK: - Career Path Mapping
    
    func generateCareerPathRecommendations() {
        // Analyze current performance and skills
        let currentSkills = analyzeCurrentSkills()
        let performancePatterns = analyzePerformancePatterns()
        
        // Generate career path options
        let recommendations = CareerPathGenerator.generatePaths(
            currentSkills: currentSkills,
            performance: performancePatterns,
            userGoals: getUserGoals()
        )
        
        careerPathRecommendations = recommendations
    }
    
    func updateProgressOnCareerPath(_ pathId: String, milestone: CareerMilestone) {
        guard let pathIndex = careerPathRecommendations.firstIndex(where: { $0.id == pathId }) else { return }
        
        careerPathRecommendations[pathIndex].completedMilestones.append(milestone)
        careerPathRecommendations[pathIndex].progressPercentage = calculatePathProgress(careerPathRecommendations[pathIndex])
        
        // Generate celebration insight
        generateMilestoneAchievementInsight(milestone)
    }
    
    // MARK: - AI Coaching Prompts Generation
    
    private func determineCoachingFocus(for role: ParticipantRole) -> CoachingFocus {
        switch role {
        case .presenter:
            return .presentationSkills
        case .facilitator:
            return .meetingFacilitation
        case .participant:
            return .activeParticipation
        case .observer:
            return .observationalLearning
        }
    }
    
    private func generateInitialCoachingPrompts(for session: CoachingSession) {
        let prompts: [CoachingPrompt]
        
        switch session.coachingFocus {
        case .presentationSkills:
            prompts = [
                CoachingPrompt(
                    type: .preparation,
                    title: "Pre-Presentation Check",
                    message: "Take a deep breath. Remember your key points and maintain eye contact with your audience.",
                    actionItems: ["Review main objectives", "Check tech setup", "Prepare for Q&A"],
                    timing: .beforeSpeaking
                ),
                CoachingPrompt(
                    type: .realTime,
                    title: "Engagement Reminder",
                    message: "Great start! Remember to pause for questions and engage your audience.",
                    actionItems: ["Ask engaging questions", "Use inclusive language", "Monitor body language"],
                    timing: .duringPresentation
                )
            ]
        case .meetingFacilitation:
            prompts = [
                CoachingPrompt(
                    type: .preparation,
                    title: "Facilitation Setup",
                    message: "Set clear objectives and create an inclusive environment for all participants.",
                    actionItems: ["State meeting goals", "Establish ground rules", "Encourage participation"],
                    timing: .meetingStart
                )
            ]
        case .activeParticipation:
            prompts = [
                CoachingPrompt(
                    type: .encouragement,
                    title: "Participation Boost",
                    message: "Your insights are valuable! Don't hesitate to share your perspective.",
                    actionItems: ["Ask clarifying questions", "Share relevant experiences", "Build on others' ideas"],
                    timing: .whenQuiet
                )
            ]
        case .observationalLearning:
            prompts = [
                CoachingPrompt(
                    type: .guidance,
                    title: "Active Observation",
                    message: "Focus on communication patterns and decision-making processes.",
                    actionItems: ["Note effective techniques", "Identify improvement areas", "Prepare thoughtful questions"],
                    timing: .continuous
                )
            ]
        }
        
        currentCoachingPrompts = prompts
    }
    
    private func generateContextualPrompts(based analysis: CommunicationAnalysis, for session: CoachingSession) -> [CoachingPrompt] {
        var prompts: [CoachingPrompt] = []
        
        // Analyze speaking patterns
        if analysis.speakingTimeRatio < 0.2 {
            prompts.append(CoachingPrompt(
                type: .encouragement,
                title: "Increase Participation",
                message: "You're being a great listener! Consider sharing your thoughts on this topic.",
                actionItems: ["Ask a follow-up question", "Share a related experience", "Offer your perspective"],
                timing: .realTime
            ))
        } else if analysis.speakingTimeRatio > 0.6 {
            prompts.append(CoachingPrompt(
                type: .guidance,
                title: "Balance Speaking Time",
                message: "Great insights! Now let's hear from others to gather diverse perspectives.",
                actionItems: ["Ask others for input", "Pause for responses", "Summarize key points"],
                timing: .realTime
            ))
        }
        
        // Analyze engagement patterns
        if analysis.questionAskedCount > 3 {
            prompts.append(CoachingPrompt(
                type: .positive,
                title: "Excellent Engagement!",
                message: "Your questions are driving great discussions. Keep this energy!",
                actionItems: ["Continue active listening", "Build on responses", "Synthesize insights"],
                timing: .realTime
            ))
        }
        
        // Analyze confidence indicators
        if analysis.confidenceScore < 0.4 {
            prompts.append(CoachingPrompt(
                type: .confidence,
                title: "Confidence Boost",
                message: "Remember, your expertise brought you here. Speak with confidence!",
                actionItems: ["Speak clearly and slowly", "Use assertive language", "Maintain good posture"],
                timing: .realTime
            ))
        }
        
        return prompts
    }
    
    // MARK: - Analysis Methods
    
    private func analyzeCommunicationPatterns(_ input: RealTimeCoachingInput) -> CommunicationAnalysis {
        // In a real implementation, this would use ML models to analyze:
        // - Voice tone and confidence
        // - Speaking pace and clarity
        // - Word choice and professionalism
        // - Engagement patterns
        
        return CommunicationAnalysis(
            speakingTimeRatio: input.speakingTimeRatio,
            questionAskedCount: input.questionAskedCount,
            confidenceScore: input.confidenceScore,
            clarityScore: input.clarityScore,
            engagementLevel: input.engagementLevel,
            professionalismScore: input.professionalismScore
        )
    }
    
    private func calculatePerformanceScore(for session: CoachingSession) -> Double {
        let communicationAverage = session.communicationMetrics.map { $0.overallScore }.average()
        let promptCompletionRate = Double(session.completedPrompts) / Double(session.totalPrompts)
        let engagementScore = session.communicationMetrics.map { $0.engagementLevel }.average()
        
        return (communicationAverage * 0.4) + (promptCompletionRate * 0.3) + (engagementScore * 0.3)
    }
    
    private func analyzeCurrentSkills() -> [Skill] {
        // Analyze performance history to determine current skill levels
        return performanceMetrics.getSkillAssessment()
    }
    
    private func analyzePerformancePatterns() -> PerformancePatterns {
        return PerformancePatterns(metrics: performanceMetrics)
    }
    
    private func getUserGoals() -> [CareerGoal] {
        // In a real implementation, this would fetch user-defined career goals
        return []
    }
    
    // MARK: - Insight Generation
    
    private func generatePostSessionInsights(for session: CoachingSession) {
        let insights = CoachingInsightGenerator.generateInsights(from: session)
        coachingInsights.append(contentsOf: insights)
    }
    
    private func generateImprovementInsight(_ improvement: PerformanceImprovement) {
        let insight = CoachingInsight(
            type: .improvement,
            title: "Great Progress in \(improvement.metric.displayName)!",
            description: "You've improved by \(Int(improvement.improvementPercentage))% over the last \(improvement.timeframe) days.",
            actionItems: improvement.nextSteps,
            priority: .medium,
            category: .performance
        )
        
        coachingInsights.append(insight)
    }
    
    private func generateMilestoneAchievementInsight(_ milestone: CareerMilestone) {
        let insight = CoachingInsight(
            type: .achievement,
            title: "Milestone Achieved: \(milestone.title)",
            description: milestone.celebrationMessage,
            actionItems: milestone.nextSteps,
            priority: .high,
            category: .careerProgress
        )
        
        coachingInsights.append(insight)
    }
    
    private func detectImprovement(for metric: PerformanceMetricType) -> PerformanceImprovement? {
        let recentEntries = getPerformanceHistory(for: metric, days: 7)
        let previousEntries = getPerformanceHistory(for: metric, days: 14).dropLast(recentEntries.count)
        
        guard !recentEntries.isEmpty && !previousEntries.isEmpty else { return nil }
        
        let recentAverage = recentEntries.map { $0.value }.average()
        let previousAverage = previousEntries.map { $0.value }.average()
        
        let improvementPercentage = ((recentAverage - previousAverage) / previousAverage) * 100
        
        if improvementPercentage > 10 { // 10% improvement threshold
            return PerformanceImprovement(
                metric: metric,
                improvementPercentage: improvementPercentage,
                timeframe: 7,
                nextSteps: generateNextSteps(for: metric)
            )
        }
        
        return nil
    }
    
    private func generateNextSteps(for metric: PerformanceMetricType) -> [String] {
        switch metric {
        case .communicationClarity:
            return ["Practice speaking exercises", "Record yourself presenting", "Ask for feedback"]
        case .meetingParticipation:
            return ["Prepare questions beforehand", "Set speaking goals", "Practice active listening"]
        case .leadershipPresence:
            return ["Take on facilitation roles", "Practice confident body language", "Seek leadership opportunities"]
        case .technicalExplanation:
            return ["Practice explaining complex concepts simply", "Use more analogies", "Create visual aids"]
        }
    }
    
    private func updateCareerPathRecommendations(based session: CoachingSession) {
        // Update recommendations based on latest performance
        generateCareerPathRecommendations()
    }
    
    private func calculatePathProgress(_ path: CareerPathRecommendation) -> Double {
        guard !path.milestones.isEmpty else { return 0 }
        return Double(path.completedMilestones.count) / Double(path.milestones.count) * 100
    }
    
    private func setupRealtimeCoaching() {
        // Setup real-time coaching system
        Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateActiveCoachingSessions()
            }
            .store(in: &cancellables)
    }
    
    private func updateActiveCoachingSessions() {
        // Update active coaching sessions with new prompts and insights
        for session in activeCoachingSessions {
            // Generate time-based coaching prompts if needed
        }
    }
}

// MARK: - Supporting Data Models

struct CoachingSession: Identifiable {
    let id = UUID().uuidString
    let callId: String
    let participantRole: ParticipantRole
    let startTime: Date
    var endTime: Date?
    let coachingFocus: CoachingFocus
    var realTimePrompts: [CoachingPrompt]
    var communicationMetrics: [CommunicationAnalysis] = []
    var performanceScore: Double = 0.0
    var completedPrompts: Int = 0
    var totalPrompts: Int = 0
}

enum ParticipantRole {
    case presenter, facilitator, participant, observer
}

enum CoachingFocus {
    case presentationSkills, meetingFacilitation, activeParticipation, observationalLearning
}

struct CoachingPrompt: Identifiable {
    let id = UUID()
    let type: PromptType
    let title: String
    let message: String
    let actionItems: [String]
    let timing: PromptTiming
    let priority: PromptPriority = .medium
    
    enum PromptType {
        case preparation, realTime, encouragement, guidance, positive, confidence
        
        var icon: String {
            switch self {
            case .preparation: return "checklist"
            case .realTime: return "dot.radiowaves.left.and.right"
            case .encouragement: return "hand.thumbsup.fill"
            case .guidance: return "lightbulb.fill"
            case .positive: return "star.fill"
            case .confidence: return "bolt.fill"
            }
        }
        
        var color: String {
            switch self {
            case .preparation: return "neonBlue"
            case .realTime: return "neonGreen"
            case .encouragement: return "neonYellow"
            case .guidance: return "neonOrange"
            case .positive: return "neonPink"
            case .confidence: return "neonPurple"
            }
        }
    }
    
    enum PromptTiming {
        case beforeSpeaking, duringPresentation, meetingStart, whenQuiet, continuous, realTime
    }
    
    enum PromptPriority {
        case low, medium, high, urgent
    }
}

struct RealTimeCoachingInput {
    let callId: String
    let speakingTimeRatio: Double
    let questionAskedCount: Int
    let confidenceScore: Double
    let clarityScore: Double
    let engagementLevel: Double
    let professionalismScore: Double
}

struct CommunicationAnalysis {
    let speakingTimeRatio: Double
    let questionAskedCount: Int
    let confidenceScore: Double
    let clarityScore: Double
    let engagementLevel: Double
    let professionalismScore: Double
    
    var overallScore: Double {
        return (confidenceScore + clarityScore + engagementLevel + professionalismScore) / 4.0
    }
}

struct PerformanceMetrics {
    var entries: [PerformanceEntry] = []
    
    mutating func addEntry(_ entry: PerformanceEntry) {
        entries.append(entry)
    }
    
    func getSkillAssessment() -> [Skill] {
        // Generate skill assessment based on performance data
        return []
    }
}

struct PerformanceEntry {
    let metric: PerformanceMetricType
    let value: Double
    let timestamp: Date
    let context: String
}

enum PerformanceMetricType {
    case communicationClarity, meetingParticipation, leadershipPresence, technicalExplanation
    
    var displayName: String {
        switch self {
        case .communicationClarity: return "Communication Clarity"
        case .meetingParticipation: return "Meeting Participation"
        case .leadershipPresence: return "Leadership Presence"
        case .technicalExplanation: return "Technical Explanation"
        }
    }
}

struct PerformanceImprovement {
    let metric: PerformanceMetricType
    let improvementPercentage: Double
    let timeframe: Int
    let nextSteps: [String]
}

struct PerformancePatterns {
    let metrics: PerformanceMetrics
    
    // Add pattern analysis methods
}

struct CareerPathRecommendation: Identifiable {
    let id = UUID().uuidString
    let title: String
    let description: String
    let milestones: [CareerMilestone]
    var completedMilestones: [CareerMilestone] = []
    var progressPercentage: Double = 0.0
    let estimatedTimeframe: String
    let requiredSkills: [Skill]
    let growthOpportunities: [String]
}

struct CareerMilestone: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let celebrationMessage: String
    let nextSteps: [String]
    let skillsGained: [Skill]
}

struct CareerGoal: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let targetDate: Date
}

struct Skill: Identifiable {
    let id = UUID()
    let name: String
    let level: SkillLevel
    let category: SkillCategory
}

enum SkillLevel {
    case beginner, intermediate, advanced, expert
}

enum SkillCategory {
    case technical, communication, leadership, creative
}

struct CoachingInsight: Identifiable {
    let id = UUID()
    let type: InsightType
    let title: String
    let description: String
    let actionItems: [String]
    let priority: Priority
    let category: InsightCategory
    let timestamp: Date = Date()
    
    enum InsightType {
        case improvement, achievement, recommendation, warning
    }
    
    enum Priority {
        case low, medium, high
    }
    
    enum InsightCategory {
        case performance, careerProgress, skillDevelopment, communication
    }
}

// MARK: - Helper Classes

class CareerPathGenerator {
    static func generatePaths(currentSkills: [Skill], performance: PerformancePatterns, userGoals: [CareerGoal]) -> [CareerPathRecommendation] {
        // Implementation for generating career paths based on current state
        return []
    }
}

class CoachingInsightGenerator {
    static func generateInsights(from session: CoachingSession) -> [CoachingInsight] {
        // Implementation for generating insights from completed sessions
        return []
    }
}

// MARK: - Helper Extensions

extension Array where Element == Double {
    func average() -> Double {
        guard !isEmpty else { return 0 }
        return reduce(0, +) / Double(count)
    }
}
