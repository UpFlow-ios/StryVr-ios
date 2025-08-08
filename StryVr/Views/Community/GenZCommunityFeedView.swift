//
//  GenZCommunityFeedView.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  🌟 Revolutionary Gen Z Community Feed - Authenticity, Instant Reactions & Real Vibes
//  💫 Real-Time Social Features with Transparency Markers & Authentic Connections
//

import SwiftUI

struct GenZCommunityFeedView: View {
    @StateObject private var genZService = GenZEngagementService.shared
    @State private var selectedTab: CommunityTab = .feed
    @State private var showingVibeCheck = false
    @State private var showingHotTakeComposer = false
    @State private var showingAuthenticityDetail = false
    @State private var newPostText = ""
    @Namespace private var communityNamespace
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.LiquidGlass.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Authenticity & Vibe Header
                    authenticityVibeHeader
                    
                    // Community tabs
                    communityTabs
                    
                    // Main content
                    mainContentView
                }
                
                // Live reactions overlay
                liveReactionsOverlay
                
                // Floating action button
                floatingActionButton
            }
            .navigationTitle("Community")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingVibeCheck = true
                    }) {
                        Text(genZService.vibeCheck.currentVibe.emoji)
                            .font(.title2)
                            .scaleEffect(1.2)
                            .animation(.spring(), value: genZService.vibeCheck.currentVibe)
                    }
                }
            }
        }
        .sheet(isPresented: $showingVibeCheck) {
            VibeCheckView()
        }
        .sheet(isPresented: $showingHotTakeComposer) {
            HotTakeComposerView()
        }
        .sheet(isPresented: $showingAuthenticityDetail) {
            AuthenticityDetailView()
        }
    }
    
    // MARK: - Authenticity & Vibe Header
    private var authenticityVibeHeader: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                // Authenticity Score
                Button(action: {
                    showingAuthenticityDetail = true
                }) {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Theme.Colors.fromString(genZService.authenticityScore.level.color).opacity(0.3))
                                .frame(width: 40, height: 40)
                            
                            Text(genZService.authenticityScore.level.emoji)
                                .font(.title3)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Authenticity")
                                .font(.caption2)
                                .foregroundColor(Theme.Colors.textSecondary)
                            
                            Text(genZService.authenticityScore.level.rawValue)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.Colors.fromString(genZService.authenticityScore.level.color))
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                // Energy Level
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Energy")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5, id: \.self) { index in
                            Circle()
                                .fill(index < Int(genZService.energyLevel * 5) ? Theme.Colors.neonYellow : Theme.Colors.glassPrimary)
                                .frame(width: 6, height: 6)
                                .scaleEffect(index < Int(genZService.energyLevel * 5) ? 1.2 : 1.0)
                                .animation(.spring().delay(Double(index) * 0.1), value: genZService.energyLevel)
                        }
                        
                        Text("\(Int(genZService.energyLevel * 100))%")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.Colors.neonYellow)
                    }
                }
            }
            
            // Current mood & vibe
            HStack(spacing: Theme.Spacing.medium) {
                HStack(spacing: 6) {
                    Text(genZService.currentMood.emoji)
                        .font(.title3)
                    
                    Text(genZService.currentMood.description)
                        .font(.caption)
                        .foregroundColor(Theme.Colors.textPrimary)
                }
                
                Spacer()
                
                Button(action: {
                    genZService.boostEnergy()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(Theme.Colors.neonYellow)
                            .font(.caption2)
                        
                        Text("Boost")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.Colors.neonYellow)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.Colors.neonYellow.opacity(0.2), in: Capsule())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .liquidGlassCard()
        .padding(.horizontal, Theme.Spacing.large)
        .padding(.top, Theme.Spacing.medium)
    }
    
    // MARK: - Community Tabs
    private var communityTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.medium) {
                ForEach(CommunityTab.allCases, id: \.self) { tab in
                    CommunityTabButton(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        action: {
                            withAnimation(.spring()) {
                                selectedTab = tab
                            }
                        }
                    )
                    .matchedGeometryEffect(id: "tab-\(tab.rawValue)", in: communityNamespace)
                }
            }
            .padding(.horizontal, Theme.Spacing.large)
        }
        .padding(.vertical, Theme.Spacing.medium)
    }
    
    // MARK: - Main Content
    private var mainContentView: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.large) {
                switch selectedTab {
                case .feed:
                    feedContent
                case .trending:
                    trendingContent
                case .hotTakes:
                    hotTakesContent
                case .vibes:
                    vibesContent
                }
            }
            .padding(.horizontal, Theme.Spacing.large)
            .padding(.bottom, 100) // Space for floating button
        }
    }
    
    // MARK: - Feed Content
    private var feedContent: some View {
        VStack(spacing: Theme.Spacing.large) {
            // Quick post composer
            quickPostComposer
            
            // Community posts
            ForEach(genZService.communityFeed) { post in
                CommunityPostCard(post: post) { reaction in
                    genZService.reactToPost(post.id.uuidString, reaction: reaction)
                }
            }
            
            if genZService.communityFeed.isEmpty {
                EmptyCommunityView()
            }
        }
    }
    
    private var quickPostComposer: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "quote.bubble.fill")
                    .foregroundColor(Theme.Colors.neonBlue)
                    .font(.title3)
                    .neonGlow(color: Theme.Colors.neonBlue, pulse: true)
                
                Text("Share your vibe")
                    .font(Theme.Typography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
            }
            
            HStack {
                TextField("What's the vibe? Keep it real...", text: $newPostText, axis: .vertical)
                    .font(.caption)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .lineLimit(3)
                
                if !newPostText.isEmpty {
                    Button(action: sharePost) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(Theme.Colors.neonBlue)
                            .font(.title3)
                    }
                }
            }
            
            // Quick reaction buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.small) {
                    ForEach([UserMood.pumped, .focused, .tired, .confident, .sassy], id: \.self) { mood in
                        Button(action: {
                            genZService.updateMood(mood)
                        }) {
                            HStack(spacing: 4) {
                                Text(mood.emoji)
                                    .font(.caption)
                                
                                Text(mood.description)
                                    .font(.caption2)
                                    .foregroundColor(Theme.Colors.textSecondary)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                genZService.currentMood == mood ? Theme.Colors.neonBlue.opacity(0.3) : Theme.Colors.glassPrimary,
                                in: Capsule()
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Trending Content
    private var trendingContent: some View {
        VStack(spacing: Theme.Spacing.large) {
            ForEach(genZService.trendingTopics) { topic in
                TrendingTopicCard(topic: topic)
            }
        }
    }
    
    // MARK: - Hot Takes Content
    private var hotTakesContent: some View {
        VStack(spacing: Theme.Spacing.large) {
            // Hot takes header
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(Theme.Colors.neonOrange)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonOrange, pulse: true)
                
                Text("Hot Takes")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Button("Add Take") {
                    showingHotTakeComposer = true
                }
                .font(.caption)
                .foregroundColor(Theme.Colors.neonOrange)
            }
            
            ForEach(genZService.hotTakes) { hotTake in
                HotTakeCard(hotTake: hotTake) { vote in
                    genZService.voteOnHotTake(hotTake.id.uuidString, vote: vote)
                }
            }
        }
    }
    
    // MARK: - Vibes Content
    private var vibesContent: some View {
        VStack(spacing: Theme.Spacing.large) {
            // Weekly vibes summary
            WeeklyVibesCard(weeklyVibes: genZService.weeklyVibes)
            
            // Vibe selector
            vibeSelector
            
            // Recent vibe updates
            recentVibeUpdates
        }
    }
    
    private var vibeSelector: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Current Vibe")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: Theme.Spacing.medium) {
                ForEach(VibeType.allCases, id: \.self) { vibe in
                    Button(action: {
                        genZService.sendVibeUpdate(vibe)
                    }) {
                        VStack(spacing: 6) {
                            Text(vibe.emoji)
                                .font(.title2)
                                .scaleEffect(genZService.vibeCheck.currentVibe == vibe ? 1.3 : 1.0)
                                .animation(.spring(), value: genZService.vibeCheck.currentVibe)
                            
                            Text(vibe.description)
                                .font(.caption2)
                                .foregroundColor(
                                    genZService.vibeCheck.currentVibe == vibe ? Theme.Colors.neonBlue : Theme.Colors.textSecondary
                                )
                                .fontWeight(genZService.vibeCheck.currentVibe == vibe ? .semibold : .regular)
                        }
                        .padding()
                        .background(
                            genZService.vibeCheck.currentVibe == vibe ? Theme.Colors.neonBlue.opacity(0.2) : Theme.Colors.glassPrimary,
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(genZService.vibeCheck.currentVibe == vibe ? Theme.Colors.neonBlue : Color.clear, lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    private var recentVibeUpdates: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Recent Vibe Updates")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ForEach(genZService.communityFeed.filter { $0.type == .vibeUpdate }.prefix(5)) { post in
                VibeUpdateCard(post: post)
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Live Reactions Overlay
    private var liveReactionsOverlay: some View {
        ZStack {
            ForEach(genZService.liveReactions) { reaction in
                Text(reaction.type.rawValue)
                    .font(.title)
                    .position(reaction.position)
                    .scaleEffect(2.0)
                    .opacity(0.8)
                    .animation(.easeOut(duration: 3), value: reaction.timestamp)
            }
        }
        .allowsHitTesting(false)
    }
    
    // MARK: - Floating Action Button
    private var floatingActionButton: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: {
                    showingHotTakeComposer = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(
                            LinearGradient(
                                colors: [Theme.Colors.neonPink, Theme.Colors.neonOrange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            in: Circle()
                        )
                        .liquidGlassGlow(color: Theme.Colors.neonPink, radius: 12, intensity: 1.0)
                        .shadow(color: Theme.Colors.neonPink.opacity(0.5), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.trailing, Theme.Spacing.large)
            .padding(.bottom, 100)
        }
    }
    
    // MARK: - Helper Methods
    
    private func sharePost() {
        genZService.shareToFeed(newPostText, type: .update, includeVibeCheck: true)
        newPostText = ""
        HapticManager.shared.impact(.medium)
    }
}

// MARK: - Supporting Views

struct CommunityTabButton: View {
    let tab: CommunityTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.caption)
                    .foregroundColor(isSelected ? tab.color : Theme.Colors.textSecondary)
                
                Text(tab.title)
                    .font(Theme.Typography.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? Theme.Colors.textPrimary : Theme.Colors.textSecondary)
            }
            .padding(.horizontal, Theme.Spacing.medium)
            .padding(.vertical, Theme.Spacing.small)
            .background(
                isSelected ? tab.color.opacity(0.2) : Theme.Colors.glassPrimary,
                in: Capsule()
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? tab.color : Color.clear, lineWidth: 1)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CommunityPostCard: View {
    let post: CommunityPost
    let onReaction: (ReactionType) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            // Post header
            HStack {
                Text(post.author)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                if post.isAuthentic {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(Theme.Colors.neonGreen)
                        .font(.caption2)
                }
                
                Spacer()
                
                Text(post.timestamp, style: .relative)
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textTertiary)
            }
            
            // Post content
            Text(post.content)
                .font(.caption)
                .foregroundColor(Theme.Colors.textPrimary)
                .lineSpacing(4)
            
            // Reactions
            if !post.reactions.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Theme.Spacing.small) {
                        ForEach(post.reactions) { reaction in
                            Text(reaction.type.rawValue)
                                .font(.caption)
                        }
                    }
                }
            }
            
            // Quick reactions
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.small) {
                    ForEach([ReactionType.fire, .bigMood, .facts, .crying], id: \.self) { reactionType in
                        Button(action: {
                            onReaction(reactionType)
                        }) {
                            Text(reactionType.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Theme.Colors.glassPrimary, in: Capsule())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding()
        .liquidGlassCard()
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(post.isAuthentic ? Theme.Colors.neonGreen.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}

struct TrendingTopicCard: View {
    let topic: TrendingTopic
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            VStack(alignment: .leading, spacing: 4) {
                Text("#\(topic.name)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text("\(topic.posts) posts")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            Spacer()
            
            Circle()
                .fill(Theme.Colors.fromString(topic.sentiment.color))
                .frame(width: 8, height: 8)
        }
        .padding()
        .liquidGlassCard()
    }
}

struct HotTakeCard: View {
    let hotTake: HotTake
    let onVote: (VoteType) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Text(hotTake.category.rawValue)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.neonOrange)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Theme.Colors.neonOrange.opacity(0.2), in: Capsule())
                
                Spacer()
                
                Text(hotTake.timestamp, style: .relative)
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textTertiary)
            }
            
            Text(hotTake.content)
                .font(.caption)
                .foregroundColor(Theme.Colors.textPrimary)
                .lineSpacing(4)
            
            HStack {
                Text("by \(hotTake.author)")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
                
                Spacer()
                
                HStack(spacing: Theme.Spacing.medium) {
                    Button("🔥") { onVote(.fire) }
                    Button("🧊") { onVote(.ice) }
                    Button("📠") { onVote(.facts) }
                }
                .font(.caption)
                
                Text("\(hotTake.votes)")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(hotTake.votes > 0 ? Theme.Colors.neonGreen : Theme.Colors.neonOrange)
            }
        }
        .padding()
        .liquidGlassCard()
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.Colors.neonOrange.opacity(0.3), lineWidth: 1)
        )
    }
}

struct WeeklyVibesCard: View {
    let weeklyVibes: WeeklyVibes
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundColor(Theme.Colors.neonBlue)
                    .font(.title3)
                    .neonGlow(color: Theme.Colors.neonBlue, pulse: true)
                
                Text("This Week's Vibes")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
            }
            
            HStack(spacing: Theme.Spacing.large) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Dominant Mood")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                    
                    HStack(spacing: 6) {
                        Text(weeklyVibes.dominantMood.emoji)
                            .font(.title3)
                        
                        Text(weeklyVibes.dominantMood.description)
                            .font(.caption)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Energy")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                    
                    Text("\(Int(weeklyVibes.energyAverage * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.neonYellow)
                }
            }
            
            if weeklyVibes.authenticityGrowth > 0 {
                HStack {
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(Theme.Colors.neonGreen)
                        .font(.caption2)
                    
                    Text("Authenticity grew by \(weeklyVibes.authenticityGrowth) points this week")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.neonGreen)
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
}

struct VibeUpdateCard: View {
    let post: CommunityPost
    
    var body: some View {
        HStack {
            Text(post.content)
                .font(.caption)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Spacer()
            
            Text(post.timestamp, style: .relative)
                .font(.caption2)
                .foregroundColor(Theme.Colors.textTertiary)
        }
        .padding()
        .background(Theme.Colors.glassPrimary.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct EmptyCommunityView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("✨")
                .font(.system(size: 60))
            
            Text("The vibe is quiet")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Text("Be the first to share what's on your mind")
                .font(.caption)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, Theme.Spacing.xLarge)
    }
}

// MARK: - Supporting Types

enum CommunityTab: String, CaseIterable {
    case feed = "Feed"
    case trending = "Trending"
    case hotTakes = "Hot Takes"
    case vibes = "Vibes"
    
    var title: String { rawValue }
    
    var icon: String {
        switch self {
        case .feed: return "rectangle.stack.fill"
        case .trending: return "chart.line.uptrend.xyaxis"
        case .hotTakes: return "flame.fill"
        case .vibes: return "heart.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .feed: return Theme.Colors.neonBlue
        case .trending: return Theme.Colors.neonGreen
        case .hotTakes: return Theme.Colors.neonOrange
        case .vibes: return Theme.Colors.neonPink
        }
    }
}

// MARK: - Placeholder Views (to be implemented)

struct VibeCheckView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("Vibe Check")
                .navigationTitle("How's the vibe?")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

struct HotTakeComposerView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("Hot Take Composer")
                .navigationTitle("Drop a Hot Take")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Post") { dismiss() }
                    }
                }
        }
    }
}

struct AuthenticityDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("Authenticity Details")
                .navigationTitle("Your Authenticity")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

#Preview {
    GenZCommunityFeedView()
}
