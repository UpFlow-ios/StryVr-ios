//
//  RealTimeSkillTrackingService.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  🎯 Revolutionary Real-Time Skill Tracking - Live AI Analysis During Video Calls
//  🧠 Advanced Pattern Recognition for Skill Demonstration Detection & Growth Tracking
//

import Foundation
import Combine
import AVFoundation

@MainActor
class RealTimeSkillTrackingService: ObservableObject {
    static let shared = RealTimeSkillTrackingService()
    
    // MARK: - Published Properties
    @Published var activeSkillTracking: [SkillTrackingSession] = []
    @Published var detectedSkillMoments: [SkillMoment] = []
    @Published var liveSkillAuras: [LiveSkillAura] = []
    @Published var skillInsights: [SkillInsight] = []
    @Published var realTimeMetrics: RealTimeMetrics = RealTimeMetrics()
    
    // MARK: - Real-Time Analysis
    @Published var currentSpeaker: String?
    @Published var activeBehaviors: [BehaviorPattern] = []
    @Published var skillDemonstrationScore: Double = 0.0
    @Published var communicationPatterns: CommunicationPatterns = CommunicationPatterns()
    @Published var leadershipIndicators: LeadershipIndicators = LeadershipIndicators()
    
    // MARK: - Live Visualization
    @Published var skillParticles: [SkillParticle] = []
    @Published var confidenceAura: ConfidenceAura = ConfidenceAura()
    @Published var expertiseHeatmap: ExpertiseHeatmap = ExpertiseHeatmap()
    
    private var cancellables = Set<AnyCancellable>()
    private let hapticManager = HapticManager.shared
    private let gamificationService = GamificationService.shared
    private let audioAnalyzer = AudioAnalyzer()
    private let speechAnalyzer = SpeechAnalyzer()
    private let behaviorAnalyzer = BehaviorAnalyzer()
    
    private init() {
        setupRealTimeTracking()
    }
    
    // MARK: - Session Management
    
    func startSkillTracking(for callId: String, participants: [CallParticipant]) {
        let session = SkillTrackingSession(
            callId: callId,
            participants: participants,
            startTime: Date(),
            trackedSkills: SkillType.allCases,
            detectionMode: .comprehensive
        )
        
        activeSkillTracking.append(session)
        initializeRealTimeAnalysis(for: session)
        
        // Start audio and behavior analysis
        audioAnalyzer.startAnalysis()
        speechAnalyzer.startListening()
        behaviorAnalyzer.startTracking()
        
        hapticManager.impact(.light)
    }
    
    func endSkillTracking(_ sessionId: String) {
        guard let sessionIndex = activeSkillTracking.firstIndex(where: { $0.id == sessionId }) else { return }
        
        var session = activeSkillTracking[sessionIndex]
        session.endTime = Date()
        session.skillMoments = detectedSkillMoments.filter { $0.sessionId == sessionId }
        session.finalMetrics = calculateSessionMetrics(for: session)
        
        // Generate comprehensive skill insights
        generateSkillInsights(for: session)
        
        // Award XP for demonstrated skills
        awardSkillXP(for: session)
        
        // Stop analysis
        audioAnalyzer.stopAnalysis()
        speechAnalyzer.stopListening()
        behaviorAnalyzer.stopTracking()
        
        activeSkillTracking.remove(at: sessionIndex)
        clearLiveVisualizations()
    }
    
    // MARK: - Real-Time Analysis
    
    func processAudioInput(_ audioData: AudioData) {
        let audioMetrics = audioAnalyzer.analyze(audioData)
        
        // Update communication patterns
        updateCommunicationPatterns(with: audioMetrics)
        
        // Detect confidence levels
        detectConfidenceLevel(from: audioMetrics)
        
        // Check for leadership vocal patterns
        detectLeadershipVocals(from: audioMetrics)
        
        // Update real-time visualizations
        updateSkillAuras(based: audioMetrics)
    }
    
    func processSpeechInput(_ speechData: SpeechData) {
        let speechAnalysis = speechAnalyzer.analyze(speechData)
        
        // Detect skill demonstrations in speech
        detectSkillDemonstrations(from: speechAnalysis)
        
        // Analyze technical expertise
        analyzeTechnicalExpertise(from: speechAnalysis)
        
        // Check for leadership language
        detectLeadershipLanguage(from: speechAnalysis)
        
        // Generate real-time skill particles
        generateSkillParticles(for: speechAnalysis.detectedSkills)
    }
    
    func processBehaviorInput(_ behaviorData: BehaviorData) {
        let behaviorAnalysis = behaviorAnalyzer.analyze(behaviorData)
        
        // Update active behaviors
        activeBehaviors = behaviorAnalysis.patterns
        
        // Detect non-verbal leadership
        detectNonVerbalLeadership(from: behaviorAnalysis)
        
        // Analyze engagement patterns
        analyzeEngagementBehavior(from: behaviorAnalysis)
        
        // Update expertise heatmap
        updateExpertiseHeatmap(with: behaviorAnalysis)
    }
    
    // MARK: - Skill Detection Logic
    
    private func detectSkillDemonstrations(from analysis: SpeechAnalysis) {
        for skill in analysis.detectedSkills {
            let moment = SkillMoment(
                sessionId: getCurrentSessionId(),
                skill: skill.type,
                confidence: skill.confidence,
                context: skill.context,
                evidence: skill.evidence,
                timestamp: Date(),
                duration: skill.duration,
                participants: [currentSpeaker ?? "Unknown"]
            )
            
            detectedSkillMoments.append(moment)
            
            // Create live skill aura
            createSkillAura(for: skill.type, confidence: skill.confidence)
            
            // Award immediate feedback
            if skill.confidence > 0.8 {
                triggerSkillMomentCelebration(skill: skill.type)
            }
        }
    }
    
    private func analyzeTechnicalExpertise(from analysis: SpeechAnalysis) {
        let technicalKeywords = analysis.extractTechnicalKeywords()
        let complexitLevel = analysis.calculateComplexityLevel()
        let explanationClarity = analysis.assessExplanationClarity()
        
        if technicalKeywords.count > 5 && complexitLevel > 0.7 && explanationClarity > 0.6 {
            let expertiseLevel = (complexitLevel + explanationClarity) / 2.0
            
            let moment = SkillMoment(
                sessionId: getCurrentSessionId(),
                skill: .technicalExpertise,
                confidence: expertiseLevel,
                context: "Technical explanation with \(technicalKeywords.count) domain-specific terms",
                evidence: technicalKeywords.joined(separator: ", "),
                timestamp: Date(),
                duration: analysis.duration,
                participants: [currentSpeaker ?? "Unknown"]
            )
            
            detectedSkillMoments.append(moment)
            updateExpertiseDisplay(level: expertiseLevel)
        }
    }
    
    private func detectLeadershipLanguage(from analysis: SpeechAnalysis) {
        let leadershipPatterns = analysis.detectLeadershipLanguage()
        
        for pattern in leadershipPatterns {
            let moment = SkillMoment(
                sessionId: getCurrentSessionId(),
                skill: .leadership,
                confidence: pattern.strength,
                context: pattern.context,
                evidence: pattern.examples.joined(separator: "; "),
                timestamp: Date(),
                duration: pattern.duration,
                participants: [currentSpeaker ?? "Unknown"]
            )
            
            detectedSkillMoments.append(moment)
            updateLeadershipIndicators(with: pattern)
        }
    }
    
    private func detectNonVerbalLeadership(from analysis: BehaviorAnalysis) {
        if analysis.containsLeadershipBehaviors() {
            let leadershipScore = analysis.calculateLeadershipScore()
            
            let moment = SkillMoment(
                sessionId: getCurrentSessionId(),
                skill: .leadership,
                confidence: leadershipScore,
                context: "Non-verbal leadership behaviors",
                evidence: analysis.leadershipBehaviors.map { $0.description }.joined(separator: ", "),
                timestamp: Date(),
                duration: 5.0, // Assume 5-second observation window
                participants: analysis.activeParticipants
            )
            
            detectedSkillMoments.append(moment)
            leadershipIndicators.nonVerbalScore = leadershipScore
        }
    }
    
    // MARK: - Live Visualizations
    
    private func createSkillAura(for skill: SkillType, confidence: Double) {
        let aura = LiveSkillAura(
            skill: skill,
            confidence: confidence,
            position: generateAuraPosition(),
            intensity: confidence,
            timestamp: Date()
        )
        
        liveSkillAuras.append(aura)
        
        // Auto-remove after display duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.liveSkillAuras.removeAll { $0.id == aura.id }
        }
    }
    
    private func generateSkillParticles(for skills: [DetectedSkill]) {
        for skill in skills {
            let particleCount = Int(skill.confidence * 10)
            
            for _ in 0..<particleCount {
                let particle = SkillParticle(
                    skill: skill.type,
                    position: generateParticlePosition(),
                    velocity: generateParticleVelocity(),
                    life: 3.0,
                    size: skill.confidence * 10
                )
                
                skillParticles.append(particle)
            }
        }
        
        // Remove expired particles
        skillParticles.removeAll { $0.life <= 0 }
    }
    
    private func updateSkillAuras(based audioMetrics: AudioMetrics) {
        confidenceAura.level = audioMetrics.confidenceScore
        confidenceAura.stability = audioMetrics.voiceStability
        confidenceAura.energy = audioMetrics.energyLevel
        
        // Update visual intensity based on confidence
        if audioMetrics.confidenceScore > 0.8 {
            confidenceAura.pulsing = true
        }
    }
    
    private func updateExpertiseHeatmap(with analysis: BehaviorAnalysis) {
        for participant in analysis.participants {
            let expertiseScore = calculateExpertiseScore(for: participant, from: analysis)
            expertiseHeatmap.updateParticipant(participant.id, score: expertiseScore)
        }
    }
    
    // MARK: - Metrics and Insights
    
    private func updateCommunicationPatterns(with metrics: AudioMetrics) {
        communicationPatterns.speakingPace = metrics.wordsPerMinute
        communicationPatterns.voiceClarity = metrics.clarityScore
        communicationPatterns.volumeConsistency = metrics.volumeStability
        communicationPatterns.pausePatterns = metrics.pauseAnalysis
    }
    
    private func calculateSessionMetrics(for session: SkillTrackingSession) -> SessionMetrics {
        let skillCounts = Dictionary(grouping: session.skillMoments) { $0.skill }
        let averageConfidence = session.skillMoments.map { $0.confidence }.average()
        let totalDuration = session.endTime?.timeIntervalSince(session.startTime) ?? 0
        
        return SessionMetrics(
            totalSkillMoments: session.skillMoments.count,
            skillBreakdown: skillCounts.mapValues { $0.count },
            averageConfidence: averageConfidence,
            sessionDuration: totalDuration,
            participationRate: calculateParticipationRate(for: session),
            topSkills: getTopSkills(from: session.skillMoments)
        )
    }
    
    private func generateSkillInsights(for session: SkillTrackingSession) {
        let insights = SkillInsightGenerator.generateInsights(from: session)
        skillInsights.append(contentsOf: insights)
        
        // Keep only recent insights
        skillInsights = Array(skillInsights.suffix(50))
    }
    
    private func awardSkillXP(for session: SkillTrackingSession) {
        for moment in session.skillMoments {
            let xpAmount = Int(moment.confidence * 50) // Up to 50 XP per skill moment
            let multiplier = moment.confidence > 0.8 ? 1.5 : 1.0 // Bonus for high confidence
            
            gamificationService.awardXP(
                for: .learnSkill,
                context: "Demonstrated \(moment.skill.displayName)",
                multiplier: multiplier
            )
        }
    }
    
    // MARK: - Celebration Effects
    
    private func triggerSkillMomentCelebration(skill: SkillType) {
        // Create celebration particle burst
        let celebrationParticles = (0..<20).map { _ in
            SkillParticle(
                skill: skill,
                position: CGPoint(x: 200, y: 300),
                velocity: CGVector(
                    dx: Double.random(in: -100...100),
                    dy: Double.random(in: -100...100)
                ),
                life: 2.0,
                size: 15
            )
        }
        
        skillParticles.append(contentsOf: celebrationParticles)
        
        // Haptic feedback
        hapticManager.impact(.heavy)
        
        // Generate skill insight
        let insight = SkillInsight(
            type: .skillDemonstrated,
            skill: skill,
            title: "Skill Demonstrated!",
            description: "You just demonstrated excellent \(skill.displayName) skills",
            confidence: 0.9,
            timestamp: Date()
        )
        
        skillInsights.append(insight)
    }
    
    // MARK: - Helper Methods
    
    private func getCurrentSessionId() -> String {
        return activeSkillTracking.first?.id ?? ""
    }
    
    private func generateAuraPosition() -> CGPoint {
        return CGPoint(
            x: Double.random(in: 100...300),
            y: Double.random(in: 200...400)
        )
    }
    
    private func generateParticlePosition() -> CGPoint {
        return CGPoint(
            x: Double.random(in: 50...350),
            y: Double.random(in: 150...450)
        )
    }
    
    private func generateParticleVelocity() -> CGVector {
        return CGVector(
            dx: Double.random(in: -50...50),
            dy: Double.random(in: -100...0)
        )
    }
    
    private func calculateExpertiseScore(for participant: BehaviorParticipant, from analysis: BehaviorAnalysis) -> Double {
        // Combine multiple factors for expertise score
        let engagementScore = participant.engagementLevel
        let contributionScore = participant.contributionQuality
        let confidenceScore = participant.displayedConfidence
        
        return (engagementScore + contributionScore + confidenceScore) / 3.0
    }
    
    private func calculateParticipationRate(for session: SkillTrackingSession) -> Double {
        let activeParticipants = Set(session.skillMoments.flatMap { $0.participants }).count
        let totalParticipants = session.participants.count
        
        return totalParticipants > 0 ? Double(activeParticipants) / Double(totalParticipants) : 0.0
    }
    
    private func getTopSkills(from moments: [SkillMoment]) -> [SkillType] {
        let skillCounts = Dictionary(grouping: moments) { $0.skill }
        return skillCounts.sorted { $0.value.count > $1.value.count }
            .prefix(5)
            .map { $0.key }
    }
    
    private func initializeRealTimeAnalysis(for session: SkillTrackingSession) {
        realTimeMetrics = RealTimeMetrics()
        detectedSkillMoments.removeAll { $0.sessionId == session.id }
        liveSkillAuras.removeAll()
        skillParticles.removeAll()
    }
    
    private func clearLiveVisualizations() {
        liveSkillAuras.removeAll()
        skillParticles.removeAll()
        confidenceAura = ConfidenceAura()
        expertiseHeatmap = ExpertiseHeatmap()
    }
    
    private func updateExpertiseDisplay(level: Double) {
        // Update real-time expertise visualization
    }
    
    private func updateLeadershipIndicators(with pattern: LeadershipPattern) {
        leadershipIndicators.verbalScore = pattern.strength
        leadershipIndicators.lastDetected = Date()
    }
    
    private func detectConfidenceLevel(from metrics: AudioMetrics) {
        confidenceAura.level = metrics.confidenceScore
    }
    
    private func detectLeadershipVocals(from metrics: AudioMetrics) {
        if metrics.commandingTone > 0.7 && metrics.voiceStability > 0.6 {
            leadershipIndicators.vocalLeadershipScore = metrics.commandingTone
        }
    }
    
    private func analyzeEngagementBehavior(from analysis: BehaviorAnalysis) {
        realTimeMetrics.engagementLevel = analysis.overallEngagement
    }
    
    // MARK: - Setup
    
    private func setupRealTimeTracking() {
        // Setup periodic updates for live visualizations
        Timer.publish(every: 0.1, on: .main, in: .common) // 10 FPS updates
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateLiveVisualizations()
            }
            .store(in: &cancellables)
    }
    
    private func updateLiveVisualizations() {
        // Update particle physics
        updateSkillParticles()
        
        // Update skill aura animations
        updateSkillAuraAnimations()
        
        // Update confidence aura pulsing
        updateConfidenceAuraPulsing()
    }
    
    private func updateSkillParticles() {
        for index in 0..<skillParticles.count {
            skillParticles[index].update()
        }
        skillParticles.removeAll { $0.life <= 0 }
    }
    
    private func updateSkillAuraAnimations() {
        for index in 0..<liveSkillAuras.count {
            liveSkillAuras[index].updateAnimation()
        }
    }
    
    private func updateConfidenceAuraPulsing() {
        confidenceAura.updatePulse()
    }
}

// MARK: - Data Models

struct SkillTrackingSession: Identifiable {
    let id = UUID().uuidString
    let callId: String
    let participants: [CallParticipant]
    let startTime: Date
    var endTime: Date?
    let trackedSkills: [SkillType]
    let detectionMode: DetectionMode
    var skillMoments: [SkillMoment] = []
    var finalMetrics: SessionMetrics?
}

struct CallParticipant: Identifiable {
    let id = UUID().uuidString
    let name: String
    let role: ParticipantRole
    let userId: String
}

enum DetectionMode {
    case basic, comprehensive, expert
}

struct SkillMoment: Identifiable {
    let id = UUID()
    let sessionId: String
    let skill: SkillType
    let confidence: Double
    let context: String
    let evidence: String
    let timestamp: Date
    let duration: Double
    let participants: [String]
}

enum SkillType: String, CaseIterable {
    case leadership = "Leadership"
    case technicalExpertise = "Technical Expertise"
    case communication = "Communication"
    case problemSolving = "Problem Solving"
    case collaboration = "Collaboration"
    case creativity = "Creativity"
    case analyticalThinking = "Analytical Thinking"
    case projectManagement = "Project Management"
    case mentoring = "Mentoring"
    case conflictResolution = "Conflict Resolution"
    
    var displayName: String { rawValue }
    
    var color: String {
        switch self {
        case .leadership: return "neonYellow"
        case .technicalExpertise: return "neonBlue"
        case .communication: return "neonGreen"
        case .problemSolving: return "neonOrange"
        case .collaboration: return "neonPink"
        case .creativity: return "neonPurple"
        case .analyticalThinking: return "neonBlue"
        case .projectManagement: return "neonGreen"
        case .mentoring: return "neonYellow"
        case .conflictResolution: return "neonOrange"
        }
    }
    
    var icon: String {
        switch self {
        case .leadership: return "crown.fill"
        case .technicalExpertise: return "gearshape.2.fill"
        case .communication: return "quote.bubble.fill"
        case .problemSolving: return "lightbulb.fill"
        case .collaboration: return "person.3.fill"
        case .creativity: return "paintbrush.fill"
        case .analyticalThinking: return "chart.bar.fill"
        case .projectManagement: return "checklist"
        case .mentoring: return "person.badge.plus"
        case .conflictResolution: return "hand.raised.fill"
        }
    }
}

struct LiveSkillAura: Identifiable {
    let id = UUID()
    let skill: SkillType
    let confidence: Double
    var position: CGPoint
    var intensity: Double
    let timestamp: Date
    var animationPhase: Double = 0
    
    mutating func updateAnimation() {
        animationPhase += 0.1
    }
}

struct SkillParticle: Identifiable {
    let id = UUID()
    let skill: SkillType
    var position: CGPoint
    var velocity: CGVector
    var life: Double
    var size: Double
    
    mutating func update() {
        position.x += velocity.dx * 0.016 // Assuming 60 FPS
        position.y += velocity.dy * 0.016
        life -= 0.016
        size *= 0.995 // Gradually shrink
    }
}

struct ConfidenceAura {
    var level: Double = 0.5
    var stability: Double = 0.5
    var energy: Double = 0.5
    var pulsing: Bool = false
    var pulsePhase: Double = 0
    
    mutating func updatePulse() {
        if pulsing {
            pulsePhase += 0.1
        }
    }
}

struct ExpertiseHeatmap {
    var participantScores: [String: Double] = [:]
    
    mutating func updateParticipant(_ id: String, score: Double) {
        participantScores[id] = score
    }
}

struct RealTimeMetrics {
    var totalSkillMoments: Int = 0
    var averageConfidence: Double = 0.0
    var engagementLevel: Double = 0.0
    var participationBalance: Double = 0.0
}

struct CommunicationPatterns {
    var speakingPace: Double = 0.0
    var voiceClarity: Double = 0.0
    var volumeConsistency: Double = 0.0
    var pausePatterns: PauseAnalysis = PauseAnalysis()
}

struct LeadershipIndicators {
    var verbalScore: Double = 0.0
    var nonVerbalScore: Double = 0.0
    var vocalLeadershipScore: Double = 0.0
    var lastDetected: Date?
}

struct SkillInsight: Identifiable {
    let id = UUID()
    let type: InsightType
    let skill: SkillType
    let title: String
    let description: String
    let confidence: Double
    let timestamp: Date
    
    enum InsightType {
        case skillDemonstrated, improvementOpportunity, strengthIdentified, patternDetected
    }
}

struct SessionMetrics {
    let totalSkillMoments: Int
    let skillBreakdown: [SkillType: Int]
    let averageConfidence: Double
    let sessionDuration: Double
    let participationRate: Double
    let topSkills: [SkillType]
}

// MARK: - Analysis Components

class AudioAnalyzer {
    func startAnalysis() {
        // Initialize audio analysis
    }
    
    func stopAnalysis() {
        // Stop audio analysis
    }
    
    func analyze(_ audioData: AudioData) -> AudioMetrics {
        // Analyze audio for confidence, clarity, etc.
        return AudioMetrics()
    }
}

class SpeechAnalyzer {
    func startListening() {
        // Initialize speech recognition
    }
    
    func stopListening() {
        // Stop speech recognition
    }
    
    func analyze(_ speechData: SpeechData) -> SpeechAnalysis {
        // Analyze speech content for skills
        return SpeechAnalysis()
    }
}

class BehaviorAnalyzer {
    func startTracking() {
        // Initialize behavior tracking
    }
    
    func stopTracking() {
        // Stop behavior tracking
    }
    
    func analyze(_ behaviorData: BehaviorData) -> BehaviorAnalysis {
        // Analyze non-verbal behaviors
        return BehaviorAnalysis()
    }
}

// MARK: - Analysis Data Types

struct AudioData {
    let samples: [Float]
    let timestamp: Date
    let duration: Double
}

struct AudioMetrics {
    let confidenceScore: Double = 0.7
    let clarityScore: Double = 0.8
    let voiceStability: Double = 0.6
    let energyLevel: Double = 0.75
    let volumeStability: Double = 0.8
    let wordsPerMinute: Double = 150
    let pauseAnalysis: PauseAnalysis = PauseAnalysis()
    let commandingTone: Double = 0.5
}

struct SpeechData {
    let text: String
    let timestamp: Date
    let speaker: String
}

struct SpeechAnalysis {
    let detectedSkills: [DetectedSkill] = []
    let duration: Double = 5.0
    
    func extractTechnicalKeywords() -> [String] {
        return ["API", "algorithm", "database", "architecture", "optimization"]
    }
    
    func calculateComplexityLevel() -> Double {
        return 0.8
    }
    
    func assessExplanationClarity() -> Double {
        return 0.7
    }
    
    func detectLeadershipLanguage() -> [LeadershipPattern] {
        return []
    }
}

struct BehaviorData {
    let gestures: [String]
    let posture: String
    let eyeContact: Double
    let timestamp: Date
}

struct BehaviorAnalysis {
    let patterns: [BehaviorPattern] = []
    let participants: [BehaviorParticipant] = []
    let overallEngagement: Double = 0.8
    let activeParticipants: [String] = []
    let leadershipBehaviors: [LeadershipBehavior] = []
    
    func containsLeadershipBehaviors() -> Bool {
        return !leadershipBehaviors.isEmpty
    }
    
    func calculateLeadershipScore() -> Double {
        return 0.7
    }
}

struct DetectedSkill {
    let type: SkillType
    let confidence: Double
    let context: String
    let evidence: String
    let duration: Double
}

struct BehaviorPattern {
    let type: String
    let confidence: Double
}

struct BehaviorParticipant {
    let id: String
    let engagementLevel: Double
    let contributionQuality: Double
    let displayedConfidence: Double
}

struct LeadershipBehavior {
    let type: String
    let description: String
}

struct LeadershipPattern {
    let strength: Double
    let context: String
    let examples: [String]
    let duration: Double
}

struct PauseAnalysis {
    let averagePauseLength: Double = 1.2
    let pauseFrequency: Double = 0.8
}

// MARK: - Helper Classes

class SkillInsightGenerator {
    static func generateInsights(from session: SkillTrackingSession) -> [SkillInsight] {
        var insights: [SkillInsight] = []
        
        // Generate insights based on detected skills
        let skillGroups = Dictionary(grouping: session.skillMoments) { $0.skill }
        
        for (skill, moments) in skillGroups {
            let averageConfidence = moments.map { $0.confidence }.average()
            
            if averageConfidence > 0.8 {
                insights.append(SkillInsight(
                    type: .strengthIdentified,
                    skill: skill,
                    title: "\(skill.displayName) Strength",
                    description: "You consistently demonstrated strong \(skill.displayName) skills with \(Int(averageConfidence * 100))% confidence",
                    confidence: averageConfidence,
                    timestamp: Date()
                ))
            }
        }
        
        return insights
    }
}

// MARK: - Helper Extensions

extension Array where Element == Double {
    func average() -> Double {
        guard !isEmpty else { return 0 }
        return reduce(0, +) / Double(count)
    }
}
