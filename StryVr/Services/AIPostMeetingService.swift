//
//  AIPostMeetingService.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  🤖 Revolutionary AI Post-Meeting Analysis - Bridging Gaps Through Intelligence
//  ✨ Transforms conversations into actionable insights and career growth opportunities
//

import Foundation
import AVFoundation
import Speech
import OSLog

@MainActor
class AIPostMeetingService: ObservableObject {
    static let shared = AIPostMeetingService()
    
    @Published var isProcessing = false
    @Published var transcriptionProgress = 0.0
    @Published var analysisProgress = 0.0
    @Published var generatedScript: MeetingScript?
    @Published var error: PostMeetingError?
    
    private let logger = Logger(subsystem: "com.stryvr.app", category: "AIPostMeetingService")
    private let speechRecognizer = SFSpeechRecognizer()
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Processes a completed meeting and generates comprehensive insights
    func processCompletedMeeting(
        meetingId: String,
        audioURL: URL,
        participants: [CallParticipant],
        duration: TimeInterval
    ) async {
        isProcessing = true
        error = nil
        transcriptionProgress = 0.0
        analysisProgress = 0.0
        
        do {
            logger.info("🎬 Starting post-meeting processing for meeting: \(meetingId)")
            
            // Step 1: Transcribe audio with speaker recognition
            let transcription = try await transcribeAudioWithSpeakers(audioURL: audioURL, participants: participants)
            transcriptionProgress = 1.0
            
            // Step 2: Analyze conversation for insights
            let analysis = try await analyzeConversation(transcription: transcription, participants: participants)
            analysisProgress = 0.5
            
            // Step 3: Generate actionable insights and recommendations
            let insights = try await generateActionableInsights(analysis: analysis, participants: participants)
            analysisProgress = 0.8
            
            // Step 4: Create gap bridging opportunities
            let bridgingOpportunities = try await identifyBridgingOpportunities(analysis: analysis, participants: participants)
            analysisProgress = 1.0
            
            // Step 5: Compile final meeting script
            generatedScript = MeetingScript(
                meetingId: meetingId,
                transcription: transcription,
                analysis: analysis,
                actionableInsights: insights,
                bridgingOpportunities: bridgingOpportunities,
                duration: duration,
                generatedAt: Date()
            )
            
            logger.info("✅ Meeting processing completed successfully")
            
        } catch {
            logger.error("❌ Error processing meeting: \(error.localizedDescription)")
            self.error = PostMeetingError.processingFailed(error.localizedDescription)
        }
        
        isProcessing = false
    }
    
    /// Generates real-time insights during an active meeting
    func generateRealTimeInsights(currentTranscript: String, participants: [CallParticipant]) async -> [RealTimeInsight] {
        do {
            // Analyze current conversation flow
            let conversationMetrics = analyzeConversationFlow(transcript: currentTranscript)
            
            // Identify skill demonstrations
            let skillDemonstrations = identifySkillDemonstrations(transcript: currentTranscript, participants: participants)
            
            // Generate engagement insights
            let engagementInsights = analyzeEngagement(metrics: conversationMetrics, participants: participants)
            
            // Create real-time recommendations
            return createRealTimeRecommendations(
                metrics: conversationMetrics,
                skills: skillDemonstrations,
                engagement: engagementInsights
            )
            
        } catch {
            logger.error("❌ Error generating real-time insights: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Audio Transcription
    
    private func transcribeAudioWithSpeakers(audioURL: URL, participants: [CallParticipant]) async throws -> ConversationTranscript {
        logger.info("🎙️ Starting audio transcription with speaker recognition")
        
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            throw PostMeetingError.speechRecognitionUnavailable
        }
        
        // Request speech recognition permission
        let authStatus = await requestSpeechRecognitionPermission()
        guard authStatus == .authorized else {
            throw PostMeetingError.speechRecognitionDenied
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let request = SFSpeechURLRecognitionRequest(url: audioURL)
            request.shouldReportPartialResults = true
            request.requiresOnDeviceRecognition = false
            
            recognitionTask = speechRecognizer.recognitionTask(with: request) { [weak self] result, error in
                guard let self = self else { return }
                
                if let error = error {
                    continuation.resume(throwing: PostMeetingError.transcriptionFailed(error.localizedDescription))
                    return
                }
                
                if let result = result {
                    let transcript = self.processTranscriptionResult(result, participants: participants)
                    
                    if result.isFinal {
                        continuation.resume(returning: transcript)
                    } else {
                        // Update progress
                        Task { @MainActor in
                            self.transcriptionProgress = min(0.9, Double(result.bestTranscription.formattedString.count) / 1000.0)
                        }
                    }
                }
            }
        }
    }
    
    private func processTranscriptionResult(_ result: SFSpeechRecognitionResult, participants: [CallParticipant]) -> ConversationTranscript {
        let segments = result.bestTranscription.segments
        var conversationSegments: [ConversationSegment] = []
        
        // Group segments by speaker (simplified - in production would use voice recognition)
        var currentSpeaker = participants.first?.id ?? "unknown"
        var currentText = ""
        var currentStartTime: TimeInterval = 0
        
        for segment in segments {
            // Simplified speaker detection (in production, would use voice biometrics)
            let speakerId = detectSpeaker(for: segment, participants: participants)
            
            if speakerId != currentSpeaker {
                // Save previous segment
                if !currentText.isEmpty {
                    conversationSegments.append(ConversationSegment(
                        speakerId: currentSpeaker,
                        text: currentText.trimmingCharacters(in: .whitespacesAndNewlines),
                        startTime: currentStartTime,
                        endTime: segment.timestamp,
                        confidence: 0.85
                    ))
                }
                
                // Start new segment
                currentSpeaker = speakerId
                currentText = segment.substring
                currentStartTime = segment.timestamp
            } else {
                currentText += " " + segment.substring
            }
        }
        
        // Add final segment
        if !currentText.isEmpty {
            conversationSegments.append(ConversationSegment(
                speakerId: currentSpeaker,
                text: currentText.trimmingCharacters(in: .whitespacesAndNewlines),
                startTime: currentStartTime,
                endTime: result.bestTranscription.segments.last?.timestamp ?? 0,
                confidence: 0.85
            ))
        }
        
        return ConversationTranscript(
            segments: conversationSegments,
            fullText: result.bestTranscription.formattedString,
            duration: result.bestTranscription.segments.last?.timestamp ?? 0,
            confidence: calculateOverallConfidence(segments: conversationSegments)
        )
    }
    
    // MARK: - AI Analysis
    
    private func analyzeConversation(transcription: ConversationTranscript, participants: [CallParticipant]) async throws -> ConversationAnalysis {
        logger.info("🧠 Analyzing conversation patterns and dynamics")
        
        // Analyze speaking time distribution
        let speakingTimeAnalysis = analyzeSpeakingTime(transcription: transcription, participants: participants)
        
        // Identify key topics and themes
        let topicAnalysis = await identifyTopicsAndThemes(transcription: transcription)
        
        // Analyze sentiment and engagement
        let sentimentAnalysis = analyzeSentiment(transcription: transcription)
        
        // Identify decision points and action items
        let decisionAnalysis = identifyDecisionsAndActions(transcription: transcription)
        
        // Analyze team dynamics
        let dynamicsAnalysis = analyzeTeamDynamics(transcription: transcription, participants: participants)
        
        return ConversationAnalysis(
            speakingTime: speakingTimeAnalysis,
            topics: topicAnalysis,
            sentiment: sentimentAnalysis,
            decisions: decisionAnalysis,
            teamDynamics: dynamicsAnalysis,
            overallEngagement: calculateOverallEngagement(transcription: transcription)
        )
    }
    
    private func generateActionableInsights(analysis: ConversationAnalysis, participants: [CallParticipant]) async throws -> [ActionableInsight] {
        logger.info("💡 Generating actionable insights and recommendations")
        
        var insights: [ActionableInsight] = []
        
        // Communication insights
        insights.append(contentsOf: generateCommunicationInsights(analysis: analysis, participants: participants))
        
        // Skill development insights
        insights.append(contentsOf: generateSkillDevelopmentInsights(analysis: analysis, participants: participants))
        
        // Team collaboration insights
        insights.append(contentsOf: generateCollaborationInsights(analysis: analysis, participants: participants))
        
        // Leadership insights
        insights.append(contentsOf: generateLeadershipInsights(analysis: analysis, participants: participants))
        
        // Process improvement insights
        insights.append(contentsOf: generateProcessInsights(analysis: analysis))
        
        return insights.sorted { $0.priority.rawValue > $1.priority.rawValue }
    }
    
    private func identifyBridgingOpportunities(analysis: ConversationAnalysis, participants: [CallParticipant]) async throws -> [BridgingOpportunity] {
        logger.info("🌉 Identifying gap bridging opportunities")
        
        var opportunities: [BridgingOpportunity] = []
        
        // Skill gap opportunities
        opportunities.append(contentsOf: identifySkillGapBridges(analysis: analysis, participants: participants))
        
        // Communication bridge opportunities
        opportunities.append(contentsOf: identifyCommunicationBridges(analysis: analysis, participants: participants))
        
        // Knowledge transfer opportunities
        opportunities.append(contentsOf: identifyKnowledgeTransferOpportunities(analysis: analysis, participants: participants))
        
        // Cross-functional collaboration opportunities
        opportunities.append(contentsOf: identifyCrossFunctionalOpportunities(analysis: analysis, participants: participants))
        
        return opportunities
    }
    
    // MARK: - Helper Methods
    
    private func requestSpeechRecognitionPermission() async -> SFSpeechRecognizerAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
    }
    
    private func detectSpeaker(for segment: SFTranscriptionSegment, participants: [CallParticipant]) -> String {
        // Simplified speaker detection - in production would use voice biometrics
        // For now, we'll simulate based on segment timing and content patterns
        let segmentText = segment.substring.lowercased()
        
        // Look for first-person indicators or name mentions
        for participant in participants {
            let firstName = participant.name.components(separatedBy: " ").first?.lowercased() ?? ""
            if segmentText.contains(firstName) || segmentText.contains("i think") || segmentText.contains("my opinion") {
                return participant.id
            }
        }
        
        // Default to first participant (would be more sophisticated in production)
        return participants.first?.id ?? "unknown"
    }
    
    private func calculateOverallConfidence(segments: [ConversationSegment]) -> Double {
        guard !segments.isEmpty else { return 0.0 }
        return segments.map { $0.confidence }.reduce(0, +) / Double(segments.count)
    }
    
    // MARK: - Analysis Methods (Simplified implementations for demo)
    
    private func analyzeSpeakingTime(transcription: ConversationTranscript, participants: [CallParticipant]) -> SpeakingTimeAnalysis {
        var speakingTime: [String: TimeInterval] = [:]
        
        for segment in transcription.segments {
            let duration = segment.endTime - segment.startTime
            speakingTime[segment.speakerId, default: 0] += duration
        }
        
        return SpeakingTimeAnalysis(
            distribution: speakingTime,
            totalDuration: transcription.duration,
            dominantSpeaker: speakingTime.max(by: { $0.value < $1.value })?.key
        )
    }
    
    private func identifyTopicsAndThemes(transcription: ConversationTranscript) async -> TopicAnalysis {
        // Simplified topic identification using keyword analysis
        let text = transcription.fullText.lowercased()
        var topics: [String] = []
        
        let topicKeywords: [String: [String]] = [
            "Strategy": ["strategy", "planning", "roadmap", "vision", "goals"],
            "Technical": ["technical", "development", "code", "architecture", "implementation"],
            "Design": ["design", "user experience", "interface", "mockup", "prototype"],
            "Marketing": ["marketing", "campaign", "audience", "brand", "promotion"],
            "Operations": ["operations", "process", "workflow", "efficiency", "optimization"]
        ]
        
        for (topic, keywords) in topicKeywords {
            let matchCount = keywords.filter { text.contains($0) }.count
            if matchCount >= 2 {
                topics.append(topic)
            }
        }
        
        return TopicAnalysis(
            primaryTopics: Array(topics.prefix(3)),
            topicDistribution: [:], // Would implement proper topic modeling
            keyThemes: extractKeyThemes(from: text)
        )
    }
    
    private func analyzeSentiment(transcription: ConversationTranscript) -> SentimentAnalysis {
        // Simplified sentiment analysis
        let text = transcription.fullText.lowercased()
        
        let positiveWords = ["great", "excellent", "good", "positive", "agree", "love", "fantastic"]
        let negativeWords = ["bad", "terrible", "disagree", "problem", "issue", "concern", "worried"]
        
        let positiveCount = positiveWords.filter { text.contains($0) }.count
        let negativeCount = negativeWords.filter { text.contains($0) }.count
        
        let overallSentiment: SentimentType
        if positiveCount > negativeCount {
            overallSentiment = .positive
        } else if negativeCount > positiveCount {
            overallSentiment = .negative
        } else {
            overallSentiment = .neutral
        }
        
        return SentimentAnalysis(
            overall: overallSentiment,
            confidence: 0.7,
            positiveKeywords: positiveWords.filter { text.contains($0) },
            negativeKeywords: negativeWords.filter { text.contains($0) },
            emotionalTone: .professional
        )
    }
    
    private func identifyDecisionsAndActions(transcription: ConversationTranscript) -> DecisionAnalysis {
        let text = transcription.fullText
        var decisions: [String] = []
        var actionItems: [String] = []
        
        // Look for decision indicators
        let decisionPatterns = ["we decided", "let's go with", "we'll choose", "decision is"]
        let actionPatterns = ["action item", "we need to", "follow up", "next step"]
        
        let sentences = text.components(separatedBy: ".")
        
        for sentence in sentences {
            let lowercased = sentence.lowercased()
            
            if decisionPatterns.contains(where: { lowercased.contains($0) }) {
                decisions.append(sentence.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            
            if actionPatterns.contains(where: { lowercased.contains($0) }) {
                actionItems.append(sentence.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        return DecisionAnalysis(
            decisions: Array(decisions.prefix(5)),
            actionItems: Array(actionItems.prefix(5)),
            followUpRequired: !actionItems.isEmpty,
            decisionQuality: decisions.isEmpty ? .low : .high
        )
    }
    
    private func analyzeTeamDynamics(transcription: ConversationTranscript, participants: [CallParticipant]) -> TeamDynamicsAnalysis {
        // Analyze interaction patterns
        var interactionMatrix: [String: [String: Int]] = [:]
        
        for (index, segment) in transcription.segments.enumerated() {
            if index > 0 {
                let previousSpeaker = transcription.segments[index - 1].speakerId
                let currentSpeaker = segment.speakerId
                
                if previousSpeaker != currentSpeaker {
                    interactionMatrix[previousSpeaker, default: [:]][currentSpeaker, default: 0] += 1
                }
            }
        }
        
        return TeamDynamicsAnalysis(
            collaborationLevel: .high,
            leadershipPattern: .distributed,
            participationBalance: .balanced,
            interactionMatrix: interactionMatrix,
            conflictLevel: .low
        )
    }
    
    private func calculateOverallEngagement(transcription: ConversationTranscript) -> Double {
        // Simplified engagement calculation based on participation and interaction
        let uniqueSpeakers = Set(transcription.segments.map { $0.speakerId }).count
        let totalSegments = transcription.segments.count
        
        // Higher engagement = more speakers, more back-and-forth
        let speakerDiversity = Double(uniqueSpeakers) / 4.0 // Assume max 4 participants
        let interactionDensity = min(1.0, Double(totalSegments) / 50.0) // 50+ segments = high interaction
        
        return (speakerDiversity + interactionDensity) / 2.0
    }
    
    // MARK: - Insight Generation Methods
    
    private func generateCommunicationInsights(analysis: ConversationAnalysis, participants: [CallParticipant]) -> [ActionableInsight] {
        var insights: [ActionableInsight] = []
        
        if let dominantSpeaker = analysis.speakingTime.dominantSpeaker {
            insights.append(ActionableInsight(
                type: .communication,
                title: "Speaking Time Balance",
                description: "Consider encouraging more participation from quieter team members",
                recommendation: "Schedule dedicated time for each participant to share their thoughts",
                priority: .medium,
                targetParticipants: participants.filter { $0.id != dominantSpeaker }.map { $0.id },
                estimatedImpact: .medium
            ))
        }
        
        return insights
    }
    
    private func generateSkillDevelopmentInsights(analysis: ConversationAnalysis, participants: [CallParticipant]) -> [ActionableInsight] {
        var insights: [ActionableInsight] = []
        
        // Identify skill demonstration opportunities
        for participant in participants {
            if let skills = identifyDemonstratedSkills(for: participant.id, in: analysis) {
                insights.append(ActionableInsight(
                    type: .skillDevelopment,
                    title: "Skill Recognition",
                    description: "\(participant.name) demonstrated strong \(skills.joined(separator: ", ")) skills",
                    recommendation: "Consider mentoring opportunities or skill-sharing sessions",
                    priority: .high,
                    targetParticipants: [participant.id],
                    estimatedImpact: .high
                ))
            }
        }
        
        return insights
    }
    
    private func generateCollaborationInsights(analysis: ConversationAnalysis, participants: [CallParticipant]) -> [ActionableInsight] {
        // Generate insights about team collaboration patterns
        return [
            ActionableInsight(
                type: .collaboration,
                title: "Cross-Functional Synergy",
                description: "Great collaboration observed between different skill sets",
                recommendation: "Schedule regular cross-functional sessions to maintain momentum",
                priority: .high,
                targetParticipants: participants.map { $0.id },
                estimatedImpact: .high
            )
        ]
    }
    
    private func generateLeadershipInsights(analysis: ConversationAnalysis, participants: [CallParticipant]) -> [ActionableInsight] {
        // Identify leadership moments and opportunities
        return []
    }
    
    private func generateProcessInsights(analysis: ConversationAnalysis) -> [ActionableInsight] {
        // Identify process improvement opportunities
        return []
    }
    
    // MARK: - Bridging Opportunity Methods
    
    private func identifySkillGapBridges(analysis: ConversationAnalysis, participants: [CallParticipant]) -> [BridgingOpportunity] {
        return [
            BridgingOpportunity(
                type: .skillGap,
                title: "Technical-Design Bridge",
                description: "Opportunity to bridge technical implementation with design thinking",
                participants: participants.prefix(2).map { $0.id },
                suggestedActions: ["Schedule design-dev sync session", "Create shared documentation"],
                impactLevel: .high,
                estimatedTimeframe: "1-2 weeks"
            )
        ]
    }
    
    private func identifyCommunicationBridges(analysis: ConversationAnalysis, participants: [CallParticipant]) -> [BridgingOpportunity] {
        return []
    }
    
    private func identifyKnowledgeTransferOpportunities(analysis: ConversationAnalysis, participants: [CallParticipant]) -> [BridgingOpportunity] {
        return []
    }
    
    private func identifyCrossFunctionalOpportunities(analysis: ConversationAnalysis, participants: [CallParticipant]) -> [BridgingOpportunity] {
        return []
    }
    
    // MARK: - Utility Methods
    
    private func extractKeyThemes(from text: String) -> [String] {
        // Simplified theme extraction
        return ["Innovation", "Collaboration", "Growth"]
    }
    
    private func identifyDemonstratedSkills(for participantId: String, in analysis: ConversationAnalysis) -> [String]? {
        // Simplified skill identification
        return ["Leadership", "Problem Solving"]
    }
    
    // MARK: - Real-time Analysis Methods
    
    private func analyzeConversationFlow(transcript: String) -> ConversationMetrics {
        return ConversationMetrics(
            wordCount: transcript.components(separatedBy: .whitespaces).count,
            speakerChanges: 10, // Simplified
            averageResponseTime: 2.5,
            topicShifts: 3
        )
    }
    
    private func identifySkillDemonstrations(transcript: String, participants: [CallParticipant]) -> [SkillDemonstration] {
        return [
            SkillDemonstration(
                participantId: participants.first?.id ?? "",
                skill: "Strategic Thinking",
                evidence: "Demonstrated forward-thinking approach",
                confidence: 0.85,
                timestamp: Date()
            )
        ]
    }
    
    private func analyzeEngagement(metrics: ConversationMetrics, participants: [CallParticipant]) -> EngagementInsights {
        return EngagementInsights(
            overallLevel: 0.87,
            participantEngagement: participants.reduce(into: [:]) { $0[$1.id] = 0.8 },
            engagementTrend: .increasing,
            lowEngagementWarnings: []
        )
    }
    
    private func createRealTimeRecommendations(
        metrics: ConversationMetrics,
        skills: [SkillDemonstration],
        engagement: EngagementInsights
    ) -> [RealTimeInsight] {
        return [
            RealTimeInsight(
                type: .engagement,
                message: "Great team participation! Everyone is contributing.",
                priority: .info,
                actionSuggestion: nil,
                timestamp: Date()
            )
        ]
    }
}

// MARK: - Supporting Types and Enums

enum PostMeetingError: LocalizedError {
    case speechRecognitionUnavailable
    case speechRecognitionDenied
    case transcriptionFailed(String)
    case processingFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .speechRecognitionUnavailable:
            return "Speech recognition is not available on this device"
        case .speechRecognitionDenied:
            return "Speech recognition permission was denied"
        case .transcriptionFailed(let message):
            return "Transcription failed: \(message)"
        case .processingFailed(let message):
            return "Processing failed: \(message)"
        }
    }
}

struct ConversationSegment: Identifiable {
    let id = UUID()
    let speakerId: String
    let text: String
    let startTime: TimeInterval
    let endTime: TimeInterval
    let confidence: Double
}

struct ConversationTranscript {
    let segments: [ConversationSegment]
    let fullText: String
    let duration: TimeInterval
    let confidence: Double
}

struct ConversationAnalysis {
    let speakingTime: SpeakingTimeAnalysis
    let topics: TopicAnalysis
    let sentiment: SentimentAnalysis
    let decisions: DecisionAnalysis
    let teamDynamics: TeamDynamicsAnalysis
    let overallEngagement: Double
}

struct SpeakingTimeAnalysis {
    let distribution: [String: TimeInterval]
    let totalDuration: TimeInterval
    let dominantSpeaker: String?
}

struct TopicAnalysis {
    let primaryTopics: [String]
    let topicDistribution: [String: Double]
    let keyThemes: [String]
}

struct SentimentAnalysis {
    let overall: SentimentType
    let confidence: Double
    let positiveKeywords: [String]
    let negativeKeywords: [String]
    let emotionalTone: EmotionalTone
}

struct DecisionAnalysis {
    let decisions: [String]
    let actionItems: [String]
    let followUpRequired: Bool
    let decisionQuality: DecisionQuality
}

struct TeamDynamicsAnalysis {
    let collaborationLevel: CollaborationLevel
    let leadershipPattern: LeadershipPattern
    let participationBalance: ParticipationBalance
    let interactionMatrix: [String: [String: Int]]
    let conflictLevel: ConflictLevel
}

struct ActionableInsight: Identifiable {
    let id = UUID()
    let type: InsightType
    let title: String
    let description: String
    let recommendation: String
    let priority: InsightPriority
    let targetParticipants: [String]
    let estimatedImpact: ImpactLevel
}

struct BridgingOpportunity: Identifiable {
    let id = UUID()
    let type: BridgingType
    let title: String
    let description: String
    let participants: [String]
    let suggestedActions: [String]
    let impactLevel: ImpactLevel
    let estimatedTimeframe: String
}

struct MeetingScript: Identifiable {
    let id = UUID()
    let meetingId: String
    let transcription: ConversationTranscript
    let analysis: ConversationAnalysis
    let actionableInsights: [ActionableInsight]
    let bridgingOpportunities: [BridgingOpportunity]
    let duration: TimeInterval
    let generatedAt: Date
}

// MARK: - Real-time Types

struct RealTimeInsight: Identifiable {
    let id = UUID()
    let type: RealTimeInsightType
    let message: String
    let priority: InsightPriority
    let actionSuggestion: String?
    let timestamp: Date
}

struct ConversationMetrics {
    let wordCount: Int
    let speakerChanges: Int
    let averageResponseTime: TimeInterval
    let topicShifts: Int
}

struct SkillDemonstration: Identifiable {
    let id = UUID()
    let participantId: String
    let skill: String
    let evidence: String
    let confidence: Double
    let timestamp: Date
}

struct EngagementInsights {
    let overallLevel: Double
    let participantEngagement: [String: Double]
    let engagementTrend: EngagementTrend
    let lowEngagementWarnings: [String]
}

// MARK: - Enums

enum SentimentType {
    case positive, negative, neutral
}

enum EmotionalTone {
    case professional, casual, energetic, serious
}

enum DecisionQuality {
    case high, medium, low
}

enum CollaborationLevel {
    case high, medium, low
}

enum LeadershipPattern {
    case hierarchical, distributed, rotating
}

enum ParticipationBalance {
    case balanced, unbalanced, dominanted
}

enum ConflictLevel {
    case none, low, medium, high
}

enum InsightType {
    case communication, skillDevelopment, collaboration, leadership, process
}

enum InsightPriority: Int {
    case critical = 4, high = 3, medium = 2, low = 1, info = 0
}

enum ImpactLevel {
    case high, medium, low
}

enum BridgingType {
    case skillGap, communication, knowledgeTransfer, crossFunctional
}

enum RealTimeInsightType {
    case engagement, skill, communication, decision
}

enum EngagementTrend {
    case increasing, stable, decreasing
}
