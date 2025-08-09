//
//  GenZEngagementService.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  🌟 Revolutionary Gen Z Engagement Features - Authenticity, Instant Feedback & Community
//  💫 Real-Time Reactions, Transparency Markers & Social Connection for Next-Gen Users
//

import Foundation
import Combine

@MainActor
class GenZEngagementService: ObservableObject {
    static let shared = GenZEngagementService()
    
    // MARK: - Published Properties
    @Published var authenticityScore: AuthenticityScore = AuthenticityScore()
    @Published var recentReactions: [InstantReaction] = []
    @Published var communityFeed: [CommunityPost] = []
    @Published var transparencyInsights: [TransparencyInsight] = []
    @Published var socialConnections: [SocialConnection] = []
    @Published var vibeCheck: VibeCheck = VibeCheck()
    
    // MARK: - Real-Time Features
    @Published var liveReactions: [LiveReaction] = []
    @Published var currentMood: UserMood = .neutral
    @Published var energyLevel: Double = 0.7
    @Published var authenticityLevel: Double = 0.85
    
    // MARK: - Community Features
    @Published var trendingTopics: [TrendingTopic] = []
    @Published var hotTakes: [HotTake] = []
    @Published var weeklyVibes: WeeklyVibes = WeeklyVibes()
    
    private var cancellables = Set<AnyCancellable>()
    private let hapticManager = HapticManager.shared
    
    private init() {
        setupGenZFeatures()
        loadCommunityContent()
    }
    
    // MARK: - Authenticity System
    
    func updateAuthenticity(action: AuthenticityAction, context: String = "") {
        let previousScore = authenticityScore.score
        
        switch action {
        case .sharePersonalStory:
            authenticityScore.score += 15
            authenticityScore.personalStoryCount += 1
        case .admitMistake:
            authenticityScore.score += 20
            authenticityScore.vulnerabilityCount += 1
        case .askForHelp:
            authenticityScore.score += 10
            authenticityScore.helpRequestCount += 1
        case .giveBrutalHonestFeedback:
            authenticityScore.score += 25
            authenticityScore.honestFeedbackCount += 1
        case .showVulnerability:
            authenticityScore.score += 30
            authenticityScore.vulnerabilityCount += 1
        case .shareFailure:
            authenticityScore.score += 35
            authenticityScore.failureStoryCount += 1
        case .beTransparentAboutStruggles:
            authenticityScore.score += 20
            authenticityScore.transparencyCount += 1
        }
        
        // Cap at 100
        authenticityScore.score = min(100, authenticityScore.score)
        
        // Update level based on score
        authenticityScore.level = getAuthenticityLevel(authenticityScore.score)
        
        // Create transparency insight
        if authenticityScore.score > previousScore {
            let insight = TransparencyInsight(
                type: .authenticityGain,
                title: "Authenticity Boost",
                description: "Your \(action.description) increased your authenticity score by \(authenticityScore.score - previousScore) points",
                impact: authenticityScore.score - previousScore,
                timestamp: Date()
            )
            transparencyInsights.insert(insight, at: 0)
        }
        
        hapticManager.impact(.light)
    }
    
    private func getAuthenticityLevel(_ score: Int) -> AuthenticityLevel {
        switch score {
        case 0...20: return .keepingItReal
        case 21...40: return .gettingVulnerable
        case 41...60: return .openBook
        case 61...80: return .radicallyHonest
        case 81...100: return .authenticityIcon
        default: return .keepingItReal
        }
    }
    
    // MARK: - Instant Reactions System
    
    func sendReaction(_ reactionType: ReactionType, to targetId: String, context: String = "") {
        let reaction = InstantReaction(
            type: reactionType,
            targetId: targetId,
            context: context,
            timestamp: Date()
        )
        
        recentReactions.insert(reaction, at: 0)
        
        // Add to live reactions for real-time display
        let liveReaction = LiveReaction(
            type: reactionType,
            position: CGPoint(x: Double.random(in: 50...300), y: Double.random(in: 100...400)),
            timestamp: Date()
        )
        liveReactions.append(liveReaction)
        
        // Auto-remove live reaction after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.liveReactions.removeAll { $0.id == liveReaction.id }
        }
        
        // Award authenticity for genuine reactions
        if reactionType.isAuthentic {
            updateAuthenticity(action: .beTransparentAboutStruggles, context: "Authentic reaction")
        }
        
        hapticManager.impact(.medium)
    }
    
    func sendVibeUpdate(_ vibe: VibeType, intensity: Double = 1.0) {
        vibeCheck.currentVibe = vibe
        vibeCheck.intensity = intensity
        vibeCheck.lastUpdate = Date()
        
        // Update community with vibe
        let post = CommunityPost(
            type: .vibeUpdate,
            author: "You",
            content: "Currently vibing: \(vibe.emoji) \(vibe.description)",
            timestamp: Date(),
            reactions: [],
            isAuthentic: true
        )
        
        communityFeed.insert(post, at: 0)
        hapticManager.impact(.light)
    }
    
    // MARK: - Community Building
    
    func shareToFeed(_ content: String, type: CommunityPostType = .update, includeVibeCheck: Bool = false) {
        var finalContent = content
        
        if includeVibeCheck {
            finalContent += " \(vibeCheck.currentVibe.emoji)"
        }
        
        let post = CommunityPost(
            type: type,
            author: "You",
            content: finalContent,
            timestamp: Date(),
            reactions: [],
            isAuthentic: type.isAuthentic
        )
        
        communityFeed.insert(post, at: 0)
        
        // Award authenticity for sharing personal content
        if type.isAuthentic {
            updateAuthenticity(action: .sharePersonalStory, context: "Community post")
        }
        
        // Keep feed manageable
        if communityFeed.count > 50 {
            communityFeed = Array(communityFeed.prefix(50))
        }
        
        hapticManager.impact(.medium)
    }
    
    func reactToPost(_ postId: String, reaction: ReactionType) {
        guard let postIndex = communityFeed.firstIndex(where: { $0.id == postId }) else { return }
        
        // Add reaction to post
        let userReaction = UserReaction(
            userId: "current_user",
            type: reaction,
            timestamp: Date()
        )
        
        communityFeed[postIndex].reactions.append(userReaction)
        
        // Send instant reaction
        sendReaction(reaction, to: postId, context: "Community post reaction")
    }
    
    // MARK: - Hot Takes & Trending
    
    func submitHotTake(_ content: String, category: HotTakeCategory) {
        let hotTake = HotTake(
            content: content,
            category: category,
            author: "You",
            votes: 0,
            timestamp: Date()
        )
        
        hotTakes.insert(hotTake, at: 0)
        
        // Award major authenticity for controversial opinions
        updateAuthenticity(action: .giveBrutalHonestFeedback, context: "Hot take submission")
        
        hapticManager.impact(.heavy)
    }
    
    func voteOnHotTake(_ hotTakeId: String, vote: VoteType) {
        guard let index = hotTakes.firstIndex(where: { $0.id == hotTakeId }) else { return }
        
        switch vote {
        case .fire:
            hotTakes[index].votes += 1
        case .ice:
            hotTakes[index].votes -= 1
        case .facts:
            hotTakes[index].votes += 2
        }
        
        hapticManager.impact(.light)
    }
    
    // MARK: - Real-Time Mood & Energy
    
    func updateMood(_ mood: UserMood) {
        currentMood = mood
        
        // Update energy based on mood
        switch mood {
        case .pumped, .inspired:
            energyLevel = min(1.0, energyLevel + 0.2)
        case .focused, .confident:
            energyLevel = min(1.0, energyLevel + 0.1)
        case .tired, .stressed:
            energyLevel = max(0.0, energyLevel - 0.2)
        case .frustrated, .overwhelmed:
            energyLevel = max(0.0, energyLevel - 0.3)
        default:
            break
        }
        
        // Share mood to community if significant change
        if abs(energyLevel - 0.5) > 0.3 {
            shareToFeed("Feeling \(mood.emoji) \(mood.description) right now", type: .moodUpdate)
        }
        
        hapticManager.impact(.light)
    }
    
    func boostEnergy(_ amount: Double = 0.1) {
        energyLevel = min(1.0, energyLevel + amount)
        
        // Create energy boost effect
        let reaction = LiveReaction(
            type: .fire,
            position: CGPoint(x: 200, y: 300),
            timestamp: Date()
        )
        liveReactions.append(reaction)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.liveReactions.removeAll { $0.id == reaction.id }
        }
        
        hapticManager.impact(.medium)
    }
    
    // MARK: - Social Connections
    
    func connectWithUser(_ userId: String, connectionType: ConnectionType) {
        let connection = SocialConnection(
            userId: userId,
            type: connectionType,
            strength: 1,
            timestamp: Date()
        )
        
        socialConnections.append(connection)
        
        // Share connection to feed
        let connectionMessage = connectionType.getMessage()
        shareToFeed(connectionMessage, type: .socialUpdate)
        
        hapticManager.impact(.medium)
    }
    
    func strengthenConnection(_ userId: String) {
        guard let index = socialConnections.firstIndex(where: { $0.userId == userId }) else { return }
        
        socialConnections[index].strength += 1
        socialConnections[index].lastInteraction = Date()
        
        if socialConnections[index].strength >= 5 {
            // Unlock close connection achievements
            updateAuthenticity(action: .sharePersonalStory, context: "Close connection formed")
        }
    }
    
    // MARK: - Transparency Features
    
    func shareTransparencyInsight(_ type: TransparencyType, details: String) {
        let insight = TransparencyInsight(
            type: type,
            title: type.title,
            description: details,
            impact: type.impactScore,
            timestamp: Date()
        )
        
        transparencyInsights.insert(insight, at: 0)
        
        // Award authenticity for transparency
        updateAuthenticity(action: .beTransparentAboutStruggles, context: "Transparency share")
        
        // Share to community if appropriate
        if type.shouldShareToCommunity {
            shareToFeed("Just shared: \(insight.title) - \(details)", type: .transparency)
        }
    }
    
    // MARK: - Weekly Vibes Summary
    
    func generateWeeklyVibes() {
        let weeklyMoods = recentReactions.filter { Calendar.current.isDate($0.timestamp, equalTo: Date(), toGranularity: .weekOfYear) }
        
        let dominantMood = UserMood.allCases.max { mood1, mood2 in
            let count1 = weeklyMoods.filter { $0.type.associatedMood == mood1 }.count
            let count2 = weeklyMoods.filter { $0.type.associatedMood == mood2 }.count
            return count1 < count2
        } ?? .neutral
        
        weeklyVibes = WeeklyVibes(
            dominantMood: dominantMood,
            energyAverage: energyLevel,
            authenticityGrowth: max(0, authenticityScore.score - 50), // Mock previous week score
            topMoments: getTopMoments(),
            insights: generateWeeklyInsights()
        )
    }
    
    private func getTopMoments() -> [String] {
        return [
            "Shared vulnerable moment in team meeting",
            "Asked for help with project challenges",
            "Gave honest feedback to colleague",
            "Celebrated team success authentically"
        ]
    }
    
    private func generateWeeklyInsights() -> [String] {
        return [
            "Your authenticity score increased by \(authenticityScore.score - 50) points this week",
            "You connected with \(socialConnections.count) new people",
            "Most common vibe: \(vibeCheck.currentVibe.description)",
            "Energy level has been \(energyLevel > 0.7 ? "high" : energyLevel > 0.4 ? "moderate" : "low") this week"
        ]
    }
    
    // MARK: - Setup & Loading
    
    private func setupGenZFeatures() {
        // Setup real-time updates
        Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTrendingTopics()
            }
            .store(in: &cancellables)
        
        // Load initial data
        loadInitialAuthenticityScore()
        loadTrendingTopics()
    }
    
    private func loadCommunityContent() {
        // Load mock community posts
        communityFeed = [
            CommunityPost(
                type: .update,
                author: "Sarah K.",
                content: "Just had the most awkward meeting ever 😅 but somehow landed the project!",
                timestamp: Date().addingTimeInterval(-3600),
                reactions: [
                    UserReaction(userId: "user1", type: .lowkeyFire, timestamp: Date().addingTimeInterval(-3500)),
                    UserReaction(userId: "user2", type: .bigMood, timestamp: Date().addingTimeInterval(-3400))
                ],
                isAuthentic: true
            ),
            CommunityPost(
                type: .vibeUpdate,
                author: "Marcus R.",
                content: "Monday energy is NOT it today ☕️💀",
                timestamp: Date().addingTimeInterval(-7200),
                reactions: [
                    UserReaction(userId: "user3", type: .bigMood, timestamp: Date().addingTimeInterval(-7000))
                ],
                isAuthentic: true
            )
        ]
    }
    
    private func loadInitialAuthenticityScore() {
        authenticityScore = AuthenticityScore(
            score: 67,
            level: .openBook,
            personalStoryCount: 3,
            vulnerabilityCount: 2,
            helpRequestCount: 5,
            honestFeedbackCount: 1,
            failureStoryCount: 1,
            transparencyCount: 4
        )
    }
    
    private func loadTrendingTopics() {
        trendingTopics = [
            TrendingTopic(name: "work-life balance", posts: 127, sentiment: .positive),
            TrendingTopic(name: "imposter syndrome", posts: 89, sentiment: .mixed),
            TrendingTopic(name: "remote work struggles", posts: 156, sentiment: .negative),
            TrendingTopic(name: "career pivots", posts: 78, sentiment: .positive),
            TrendingTopic(name: "burnout recovery", posts: 234, sentiment: .mixed)
        ]
    }
    
    private func updateTrendingTopics() {
        // Update trending topics based on recent activity
        for topicIndex in 0..<trendingTopics.count {
            trendingTopics[topicIndex].posts += Int.random(in: 1...5)
        }
    }
}

// MARK: - Data Models

struct AuthenticityScore {
    var score: Int = 0
    var level: AuthenticityLevel = .keepingItReal
    var personalStoryCount: Int = 0
    var vulnerabilityCount: Int = 0
    var helpRequestCount: Int = 0
    var honestFeedbackCount: Int = 0
    var failureStoryCount: Int = 0
    var transparencyCount: Int = 0
}

enum AuthenticityLevel: String, CaseIterable {
    case keepingItReal = "Keeping It Real"
    case gettingVulnerable = "Getting Vulnerable"
    case openBook = "Open Book"
    case radicallyHonest = "Radically Honest"
    case authenticityIcon = "Authenticity Icon"
    
    var emoji: String {
        switch self {
        case .keepingItReal: return "😊"
        case .gettingVulnerable: return "🙏"
        case .openBook: return "📖"
        case .radicallyHonest: return "💯"
        case .authenticityIcon: return "👑"
        }
    }
    
    var color: String {
        switch self {
        case .keepingItReal: return "neonBlue"
        case .gettingVulnerable: return "neonGreen"
        case .openBook: return "neonOrange"
        case .radicallyHonest: return "neonPink"
        case .authenticityIcon: return "neonYellow"
        }
    }
}

enum AuthenticityAction {
    case sharePersonalStory, admitMistake, askForHelp, giveBrutalHonestFeedback
    case showVulnerability, shareFailure, beTransparentAboutStruggles
    
    var description: String {
        switch self {
        case .sharePersonalStory: return "sharing personal story"
        case .admitMistake: return "admitting mistake"
        case .askForHelp: return "asking for help"
        case .giveBrutalHonestFeedback: return "giving honest feedback"
        case .showVulnerability: return "showing vulnerability"
        case .shareFailure: return "sharing failure"
        case .beTransparentAboutStruggles: return "being transparent about struggles"
        }
    }
}

struct InstantReaction: Identifiable {
    let id = UUID()
    let type: ReactionType
    let targetId: String
    let context: String
    let timestamp: Date
}

enum ReactionType: String, CaseIterable {
    case fire = "🔥"
    case lowkeyFire = "🔥💯"
    case bigMood = "😌✨"
    case noThanks = "😬"
    case periodt = "💅"
    case facts = "📠"
    case crying = "😭"
    case slaps = "👋"
    case bussin = "🤌"
    case understood = "✨"
    
    var description: String {
        switch self {
        case .fire: return "Fire"
        case .lowkeyFire: return "Lowkey Fire"
        case .bigMood: return "Big Mood"
        case .noThanks: return "No Thanks"
        case .periodt: return "Periodt"
        case .facts: return "Facts"
        case .crying: return "Crying"
        case .slaps: return "Slaps"
        case .bussin: return "Bussin"
        case .understood: return "Understood"
        }
    }
    
    var isAuthentic: Bool {
        switch self {
        case .bigMood, .crying, .understood: return true
        default: return false
        }
    }
    
    var associatedMood: UserMood {
        switch self {
        case .fire, .lowkeyFire, .slaps, .bussin: return .pumped
        case .bigMood, .understood: return .focused
        case .crying: return .overwhelmed
        case .noThanks: return .frustrated
        case .facts: return .confident
        case .periodt: return .sassy
        }
    }
}

struct LiveReaction: Identifiable {
    let id = UUID()
    let type: ReactionType
    let position: CGPoint
    let timestamp: Date
}

enum UserMood: String, CaseIterable {
    case pumped, focused, tired, stressed, confident, frustrated, inspired, overwhelmed, neutral, sassy
    
    var emoji: String {
        switch self {
        case .pumped: return "🚀"
        case .focused: return "🎯"
        case .tired: return "😴"
        case .stressed: return "😰"
        case .confident: return "💪"
        case .frustrated: return "😤"
        case .inspired: return "✨"
        case .overwhelmed: return "🤯"
        case .neutral: return "😐"
        case .sassy: return "💅"
        }
    }
    
    var description: String {
        switch self {
        case .pumped: return "pumped up"
        case .focused: return "locked in"
        case .tired: return "drained"
        case .stressed: return "stressed"
        case .confident: return "confident"
        case .frustrated: return "frustrated"
        case .inspired: return "inspired"
        case .overwhelmed: return "overwhelmed"
        case .neutral: return "neutral"
        case .sassy: return "feeling myself"
        }
    }
}

struct VibeCheck {
    var currentVibe: VibeType = .neutral
    var intensity: Double = 0.5
    var lastUpdate: Date = Date()
}

enum VibeType: String, CaseIterable {
    case immaculate, questionable, chaotic, serene, intense, playful, determined, neutral
    
    var emoji: String {
        switch self {
        case .immaculate: return "✨"
        case .questionable: return "🤔"
        case .chaotic: return "🌪️"
        case .serene: return "🧘"
        case .intense: return "🔥"
        case .playful: return "🎉"
        case .determined: return "💪"
        case .neutral: return "😐"
        }
    }
    
    var description: String { rawValue }
}

struct CommunityPost: Identifiable {
    let id = UUID()
    let type: CommunityPostType
    let author: String
    let content: String
    let timestamp: Date
    var reactions: [UserReaction]
    let isAuthentic: Bool
}

enum CommunityPostType {
    case update, vibeUpdate, moodUpdate, transparency, socialUpdate, hotTake
    
    var isAuthentic: Bool {
        switch self {
        case .transparency, .vibeUpdate, .moodUpdate: return true
        default: return false
        }
    }
}

struct UserReaction: Identifiable {
    let id = UUID()
    let userId: String
    let type: ReactionType
    let timestamp: Date
}

struct TransparencyInsight: Identifiable {
    let id = UUID()
    let type: TransparencyType
    let title: String
    let description: String
    let impact: Int
    let timestamp: Date
}

enum TransparencyType {
    case authenticityGain, vulnerabilityShare, helpRequest, honestFeedback
    
    var title: String {
        switch self {
        case .authenticityGain: return "Authenticity Boost"
        case .vulnerabilityShare: return "Vulnerability Shared"
        case .helpRequest: return "Asked for Help"
        case .honestFeedback: return "Honest Feedback Given"
        }
    }
    
    var impactScore: Int {
        switch self {
        case .authenticityGain: return 5
        case .vulnerabilityShare: return 20
        case .helpRequest: return 10
        case .honestFeedback: return 25
        }
    }
    
    var shouldShareToCommunity: Bool {
        switch self {
        case .vulnerabilityShare, .helpRequest: return true
        default: return false
        }
    }
}

struct SocialConnection: Identifiable {
    let id = UUID()
    let userId: String
    let type: ConnectionType
    var strength: Int
    let timestamp: Date
    var lastInteraction: Date = Date()
}

enum ConnectionType {
    case mentor, peer, mentee, collaborator, friend
    
    func getMessage() -> String {
        switch self {
        case .mentor: return "Connected with a new mentor 🌟"
        case .peer: return "Made a new peer connection 🤝"
        case .mentee: return "Started mentoring someone new 📚"
        case .collaborator: return "Found a new collaboration partner 🚀"
        case .friend: return "Made a genuine work friend 💫"
        }
    }
}

struct HotTake: Identifiable {
    let id = UUID()
    let content: String
    let category: HotTakeCategory
    let author: String
    var votes: Int
    let timestamp: Date
}

enum HotTakeCategory: String, CaseIterable {
    case workCulture = "Work Culture"
    case leadership = "Leadership"
    case technology = "Technology"
    case careerAdvice = "Career Advice"
    case industryTrends = "Industry Trends"
}

enum VoteType {
    case fire, ice, facts
}

struct TrendingTopic: Identifiable {
    let id = UUID()
    let name: String
    var posts: Int
    let sentiment: TopicSentiment
}

enum TopicSentiment {
    case positive, negative, mixed
    
    var color: String {
        switch self {
        case .positive: return "neonGreen"
        case .negative: return "neonOrange"
        case .mixed: return "neonBlue"
        }
    }
}

struct WeeklyVibes {
    let dominantMood: UserMood = .neutral
    let energyAverage: Double = 0.5
    let authenticityGrowth: Int = 0
    let topMoments: [String] = []
    let insights: [String] = []
}
