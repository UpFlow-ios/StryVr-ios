//
//  CollaborationSpaceView.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  🏢 Revolutionary Team Collaboration Spaces - Virtual Rooms for Project Excellence
//  🌉 AI-Powered Skill Matching & Gap Bridging in Real-Time
//

import SwiftUI

struct CollaborationSpaceView: View {
    let space: CollaborationSpace
    @StateObject private var viewModel = CollaborationSpaceViewModel()
    @State private var selectedTab: CollaborationTab = .overview
    @State private var showingMemberProfile = false
    @State private var selectedMember: TeamMember?
    @State private var showingSkillMatcher = false
    @Namespace private var spaceNamespace
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.LiquidGlass.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Space Header with Live Activity
                    spaceHeader
                    
                    // Collaboration Tabs
                    collaborationTabs
                    
                    // Main Content Area
                    ScrollView {
                        VStack(spacing: Theme.Spacing.large) {
                            switch selectedTab {
                            case .overview:
                                overviewSection
                            case .projects:
                                projectsSection
                            case .skills:
                                skillsSection
                            case .bridges:
                                bridgesSection
                            case .insights:
                                insightsSection
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        .padding(.top, Theme.Spacing.medium)
                    }
                }
            }
            .navigationTitle(space.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: Theme.Spacing.medium) {
                        // AI Skill Matcher
                        Button(action: {
                            showingSkillMatcher = true
                        }) {
                            Image(systemName: "brain.head.profile")
                                .foregroundColor(Theme.Colors.neonPink)
                                .neonGlow(color: Theme.Colors.neonPink, pulse: true)
                        }
                        
                        // Join Space Button
                        if !viewModel.isUserInSpace {
                            Button(action: {
                                viewModel.joinSpace(space.id)
                            }) {
                                Text("Join")
                                    .font(Theme.Typography.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(space.color.opacity(0.8), in: Capsule())
                                    .liquidGlassGlow(color: space.color, radius: 6)
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingMemberProfile) {
            if let member = selectedMember {
                MemberProfileView(member: member)
            }
        }
        .sheet(isPresented: $showingSkillMatcher) {
            AISkillMatcherView(space: space)
        }
        .onAppear {
            viewModel.loadSpace(space)
        }
    }
    
    // MARK: - Space Header
    private var spaceHeader: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                // Space icon and info
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(space.color.opacity(0.3))
                            .frame(width: 60, height: 60)
                            .liquidGlassGlow(color: space.color, radius: 8)
                        
                        Image(systemName: space.icon)
                            .font(.title2)
                            .foregroundColor(space.color)
                            .neonGlow(color: space.color, pulse: true)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(space.name)
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        Text("\(space.activeMembers) active • \(viewModel.projects.count) projects")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }
                
                Spacer()
                
                // Live activity indicator
                if viewModel.hasLiveActivity {
                    LiveActivityIndicator()
                }
            }
            
            // Quick stats grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: Theme.Spacing.medium) {
                QuickStatCard(
                    title: "Members",
                    value: "\(viewModel.members.count)",
                    icon: "person.3.fill",
                    color: Theme.Colors.neonBlue
                )
                
                QuickStatCard(
                    title: "Skills",
                    value: "\(space.skillsBeingShared.count)",
                    icon: "brain.head.profile",
                    color: Theme.Colors.neonPink
                )
                
                QuickStatCard(
                    title: "Bridges",
                    value: "\(viewModel.activeBridges)",
                    icon: "arrow.triangle.merge",
                    color: Theme.Colors.neonGreen
                )
                
                QuickStatCard(
                    title: "Progress",
                    value: "\(viewModel.overallProgress)%",
                    icon: "chart.line.uptrend.xyaxis",
                    color: Theme.Colors.neonOrange
                )
            }
        }
        .padding()
        .liquidGlassCard()
        .padding(.horizontal, Theme.Spacing.large)
        .padding(.top, Theme.Spacing.medium)
    }
    
    // MARK: - Collaboration Tabs
    private var collaborationTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.medium) {
                ForEach(CollaborationTab.allCases, id: \.self) { tab in
                    CollaborationTabButton(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        badgeCount: getBadgeCount(for: tab),
                        action: {
                            withAnimation(.spring()) {
                                selectedTab = tab
                            }
                        }
                    )
                    .matchedGeometryEffect(id: "tab-\(tab.rawValue)", in: spaceNamespace)
                }
            }
            .padding(.horizontal, Theme.Spacing.large)
        }
        .padding(.vertical, Theme.Spacing.medium)
    }
    
    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large) {
            // Live collaboration feed
            liveCollaborationFeed
            
            // Active members
            activeMembersSection
            
            // Recent achievements
            recentAchievements
            
            // Skill exchange opportunities
            skillExchangeOpportunities
        }
    }
    
    private var liveCollaborationFeed: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "dot.radiowaves.left.and.right")
                    .foregroundColor(Theme.Colors.neonGreen)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonGreen, pulse: true)
                
                Text("Live Activity")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                if viewModel.liveActivities.isEmpty {
                    Text("All caught up")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                } else {
                    Text("\(viewModel.liveActivities.count) active")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.neonGreen)
                }
            }
            
            if viewModel.liveActivities.isEmpty {
                EmptyActivityView()
            } else {
                ForEach(viewModel.liveActivities) { activity in
                    LiveActivityCard(activity: activity)
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    private var activeMembersSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "person.3.sequence.fill")
                    .foregroundColor(Theme.Colors.neonBlue)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonBlue, pulse: true)
                
                Text("Active Members")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(viewModel.members.filter { $0.isOnline }.count) online")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.neonGreen)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Theme.Spacing.medium) {
                    ForEach(viewModel.members) { member in
                        MemberCard(member: member) {
                            selectedMember = member
                            showingMemberProfile = true
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    private var recentAchievements: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundColor(Theme.Colors.neonYellow)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonYellow, pulse: true)
                
                Text("Recent Achievements")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
            }
            
            ForEach(viewModel.recentAchievements) { achievement in
                AchievementCard(achievement: achievement)
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    private var skillExchangeOpportunities: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "arrow.2.squarepath")
                    .foregroundColor(Theme.Colors.neonOrange)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonOrange, pulse: true)
                
                Text("Skill Exchange")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Button("View All") {
                    selectedTab = .skills
                }
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.neonOrange)
            }
            
            ForEach(viewModel.skillExchangeOpportunities.prefix(3)) { opportunity in
                SkillExchangeCard(opportunity: opportunity)
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Projects Section
    private var projectsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large) {
            // Active projects
            ForEach(viewModel.projects) { project in
                ProjectCard(project: project)
            }
            
            // Create new project button
            CreateProjectButton {
                // Handle create project
            }
        }
    }
    
    // MARK: - Skills Section
    private var skillsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large) {
            // Skill map visualization
            skillMapSection
            
            // Available skills
            availableSkillsSection
            
            // Skill requests
            skillRequestsSection
        }
    }
    
    private var skillMapSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(Theme.Colors.neonPink)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonPink, pulse: true)
                
                Text("Skill Map")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Button("AI Match") {
                    showingSkillMatcher = true
                }
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.neonPink)
            }
            
            // Skill visualization component
            SkillMapVisualization(skills: space.skillsBeingShared, members: viewModel.members)
        }
        .padding()
        .liquidGlassCard()
    }
    
    private var availableSkillsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Available Skills")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            FlowLayout(spacing: 8) {
                ForEach(space.skillsBeingShared, id: \.self) { skill in
                    SkillChip(
                        skill: skill,
                        expertCount: getExpertCount(for: skill),
                        color: getSkillColor(for: skill)
                    )
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    private var skillRequestsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Text("Skill Requests")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Button("Request Skill") {
                    // Handle skill request
                }
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.neonBlue)
            }
            
            ForEach(viewModel.skillRequests) { request in
                SkillRequestCard(request: request)
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Bridges Section
    private var bridgesSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large) {
            // Active bridges
            ForEach(viewModel.activeBridges(from: viewModel.bridgingOpportunities)) { bridge in
                BridgeCard(bridge: bridge)
            }
            
            // Potential bridges
            potentialBridgesSection
        }
    }
    
    private var potentialBridgesSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(Theme.Colors.neonYellow)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonYellow, pulse: true)
                
                Text("AI-Suggested Bridges")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
            }
            
            ForEach(viewModel.suggestedBridges) { bridge in
                SuggestedBridgeCard(bridge: bridge) {
                    viewModel.createBridge(from: bridge)
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Insights Section
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large) {
            // Collaboration analytics
            collaborationAnalytics
            
            // Performance insights
            performanceInsights
            
            // Growth recommendations
            growthRecommendations
        }
    }
    
    private var collaborationAnalytics: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(Theme.Colors.neonBlue)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonBlue, pulse: true)
                
                Text("Collaboration Analytics")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
            }
            
            // Analytics charts and metrics
            CollaborationAnalyticsChart(data: viewModel.analyticsData)
        }
        .padding()
        .liquidGlassCard()
    }
    
    private var performanceInsights: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Performance Insights")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ForEach(viewModel.performanceInsights) { insight in
                PerformanceInsightCard(insight: insight)
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    private var growthRecommendations: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Growth Recommendations")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ForEach(viewModel.growthRecommendations) { recommendation in
                GrowthRecommendationCard(recommendation: recommendation)
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Helper Methods
    
    private func getBadgeCount(for tab: CollaborationTab) -> Int {
        switch tab {
        case .overview: return 0
        case .projects: return viewModel.projects.filter { $0.needsAttention }.count
        case .skills: return viewModel.skillRequests.count
        case .bridges: return viewModel.suggestedBridges.count
        case .insights: return viewModel.newInsights
        }
    }
    
    private func getExpertCount(for skill: String) -> Int {
        return viewModel.members.filter { $0.skills.contains(skill) }.count
    }
    
    private func getSkillColor(for skill: String) -> Color {
        let colors = [Theme.Colors.neonBlue, Theme.Colors.neonGreen, Theme.Colors.neonOrange, Theme.Colors.neonPink, Theme.Colors.neonYellow]
        let index = abs(skill.hashValue) % colors.count
        return colors[index]
    }
}

// MARK: - Supporting Views

struct LiveActivityIndicator: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Theme.Colors.neonGreen)
                .frame(width: 8, height: 8)
                .scaleEffect(isAnimating ? 1.2 : 0.8)
                .animation(.easeInOut(duration: 1).repeatForever(), value: isAnimating)
            
            Text("Live")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(Theme.Colors.neonGreen)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .neonGlow(color: color, pulse: true)
            
            Text(value)
                .font(Theme.Typography.caption)
                .fontWeight(.bold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.small)
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct CollaborationTabButton: View {
    let tab: CollaborationTab
    let isSelected: Bool
    let badgeCount: Int
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
                
                if badgeCount > 0 {
                    Text("\(badgeCount)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red, in: Capsule())
                }
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

struct EmptyActivityView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "zzz")
                .font(.title)
                .foregroundColor(Theme.Colors.textTertiary)
            
            Text("All quiet for now")
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            
            Text("When team members are active, you'll see their activity here")
                .font(.caption2)
                .foregroundColor(Theme.Colors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.Colors.glassPrimary.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct LiveActivityCard: View {
    let activity: LiveActivity
    
    var body: some View {
        HStack(spacing: 12) {
            // Activity type icon
            Image(systemName: activity.type.icon)
                .foregroundColor(activity.type.color)
                .font(.title3)
                .neonGlow(color: activity.type.color, pulse: true)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.description)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                HStack {
                    Text(activity.memberName)
                        .font(.caption2)
                        .foregroundColor(activity.type.color)
                        .fontWeight(.semibold)
                    
                    Text("•")
                        .foregroundColor(Theme.Colors.textTertiary)
                    
                    Text(activity.timestamp, style: .relative)
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textTertiary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(activity.type.color.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(activity.type.color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct MemberCard: View {
    let member: TeamMember
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(member.avatarColor)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(member.isOnline ? Theme.Colors.neonGreen : Color.clear, lineWidth: 2)
                        )
                    
                    Text(member.initials)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 2) {
                    Text(member.name)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .lineLimit(1)
                    
                    Text(member.role)
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .lineLimit(1)
                }
                
                // Top skill
                if let topSkill = member.skills.first {
                    Text(topSkill)
                        .font(.caption2)
                        .foregroundColor(member.avatarColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(member.avatarColor.opacity(0.2), in: Capsule())
                }
            }
            .frame(width: 80)
            .padding()
            .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Supporting Types and Enums

enum CollaborationTab: String, CaseIterable {
    case overview = "Overview"
    case projects = "Projects"
    case skills = "Skills"
    case bridges = "Bridges"
    case insights = "Insights"
    
    var title: String { rawValue }
    
    var icon: String {
        switch self {
        case .overview: return "rectangle.grid.1x2.fill"
        case .projects: return "folder.fill"
        case .skills: return "brain.head.profile"
        case .bridges: return "arrow.triangle.merge"
        case .insights: return "chart.bar.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .overview: return Theme.Colors.neonBlue
        case .projects: return Theme.Colors.neonGreen
        case .skills: return Theme.Colors.neonPink
        case .bridges: return Theme.Colors.neonOrange
        case .insights: return Theme.Colors.neonYellow
        }
    }
}

struct LiveActivity: Identifiable {
    let id = UUID()
    let type: ActivityType
    let description: String
    let memberName: String
    let timestamp: Date
}

enum ActivityType {
    case skillShare, projectUpdate, bridge, achievement
    
    var icon: String {
        switch self {
        case .skillShare: return "arrow.2.squarepath"
        case .projectUpdate: return "doc.text"
        case .bridge: return "arrow.triangle.merge"
        case .achievement: return "trophy.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .skillShare: return Theme.Colors.neonOrange
        case .projectUpdate: return Theme.Colors.neonBlue
        case .bridge: return Theme.Colors.neonGreen
        case .achievement: return Theme.Colors.neonYellow
        }
    }
}

struct TeamMember: Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let skills: [String]
    let isOnline: Bool
    let avatarColor: Color
    
    var initials: String {
        name.components(separatedBy: " ")
            .compactMap { $0.first }
            .prefix(2)
            .map { String($0) }
            .joined()
    }
}

// MARK: - View Model

class CollaborationSpaceViewModel: ObservableObject {
    @Published var members: [TeamMember] = []
    @Published var projects: [CollaborationProject] = []
    @Published var liveActivities: [LiveActivity] = []
    @Published var recentAchievements: [SpaceAchievement] = []
    @Published var skillExchangeOpportunities: [SkillExchange] = []
    @Published var skillRequests: [SkillRequest] = []
    @Published var bridgingOpportunities: [BridgeOpportunity] = []
    @Published var suggestedBridges: [SuggestedBridge] = []
    @Published var performanceInsights: [PerformanceInsight] = []
    @Published var growthRecommendations: [GrowthRecommendation] = []
    @Published var analyticsData: CollaborationAnalytics = CollaborationAnalytics()
    
    @Published var isUserInSpace = false
    @Published var hasLiveActivity = false
    @Published var activeBridges = 0
    @Published var overallProgress = 0
    @Published var newInsights = 0
    
    func loadSpace(_ space: CollaborationSpace) {
        // Load mock data
        loadMockData()
    }
    
    func joinSpace(_ spaceId: String) {
        isUserInSpace = true
        HapticManager.shared.impact(.medium)
    }
    
    func createBridge(from suggestion: SuggestedBridge) {
        // Implementation for creating bridge
        HapticManager.shared.impact(.medium)
    }
    
    func activeBridges(from opportunities: [BridgeOpportunity]) -> [ActiveBridge] {
        // Return active bridges
        return []
    }
    
    private func loadMockData() {
        members = [
            TeamMember(name: "Sarah Chen", role: "Product Manager", skills: ["Strategy", "UX Design"], isOnline: true, avatarColor: Theme.Colors.neonBlue),
            TeamMember(name: "Marcus Rodriguez", role: "Senior Engineer", skills: ["iOS Development", "Backend"], isOnline: true, avatarColor: Theme.Colors.neonGreen),
            TeamMember(name: "Elena Popov", role: "Design Lead", skills: ["UI/UX", "Research"], isOnline: false, avatarColor: Theme.Colors.neonOrange),
            TeamMember(name: "James Wilson", role: "Marketing", skills: ["Growth", "Analytics"], isOnline: true, avatarColor: Theme.Colors.neonPink)
        ]
        
        liveActivities = [
            LiveActivity(type: .skillShare, description: "Shared iOS development insights", memberName: "Marcus", timestamp: Date().addingTimeInterval(-300)),
            LiveActivity(type: .projectUpdate, description: "Updated mobile app wireframes", memberName: "Elena", timestamp: Date().addingTimeInterval(-600))
        ]
        
        hasLiveActivity = !liveActivities.isEmpty
        activeBridges = 3
        overallProgress = 87
        newInsights = 5
    }
}

// MARK: - Placeholder Types (to be implemented)

struct CollaborationProject: Identifiable {
    let id = UUID()
    let name: String
    let needsAttention: Bool = false
}

struct SpaceAchievement: Identifiable {
    let id = UUID()
}

struct SkillExchange: Identifiable {
    let id = UUID()
}

struct SkillRequest: Identifiable {
    let id = UUID()
}

struct BridgeOpportunity: Identifiable {
    let id = UUID()
}

struct SuggestedBridge: Identifiable {
    let id = UUID()
}

struct ActiveBridge: Identifiable {
    let id = UUID()
}

struct PerformanceInsight: Identifiable {
    let id = UUID()
}

struct GrowthRecommendation: Identifiable {
    let id = UUID()
}

struct CollaborationAnalytics {
    // Analytics data structure
}

// MARK: - Placeholder View Components

struct AchievementCard: View {
    let achievement: SpaceAchievement
    
    var body: some View {
        Text("Achievement Card")
            .padding()
            .liquidGlassCard()
    }
}

struct SkillExchangeCard: View {
    let opportunity: SkillExchange
    
    var body: some View {
        Text("Skill Exchange Card")
            .padding()
            .liquidGlassCard()
    }
}

struct ProjectCard: View {
    let project: CollaborationProject
    
    var body: some View {
        Text("Project Card")
            .padding()
            .liquidGlassCard()
    }
}

struct CreateProjectButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Create Project")
                .padding()
        }
        .liquidGlassCard()
    }
}

struct SkillMapVisualization: View {
    let skills: [String]
    let members: [TeamMember]
    
    var body: some View {
        Text("Skill Map Visualization")
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct SkillChip: View {
    let skill: String
    let expertCount: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Text(skill)
                .font(.caption2)
            
            Text("\(expertCount)")
                .font(.caption2)
                .fontWeight(.bold)
        }
        .foregroundColor(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.2), in: Capsule())
    }
}

struct SkillRequestCard: View {
    let request: SkillRequest
    
    var body: some View {
        Text("Skill Request Card")
            .padding()
            .liquidGlassCard()
    }
}

struct BridgeCard: View {
    let bridge: ActiveBridge
    
    var body: some View {
        Text("Bridge Card")
            .padding()
            .liquidGlassCard()
    }
}

struct SuggestedBridgeCard: View {
    let bridge: SuggestedBridge
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Suggested Bridge Card")
                .padding()
        }
        .liquidGlassCard()
    }
}

struct CollaborationAnalyticsChart: View {
    let data: CollaborationAnalytics
    
    var body: some View {
        Text("Analytics Chart")
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct PerformanceInsightCard: View {
    let insight: PerformanceInsight
    
    var body: some View {
        Text("Performance Insight Card")
            .padding()
            .liquidGlassCard()
    }
}

struct GrowthRecommendationCard: View {
    let recommendation: GrowthRecommendation
    
    var body: some View {
        Text("Growth Recommendation Card")
            .padding()
            .liquidGlassCard()
    }
}

struct MemberProfileView: View {
    let member: TeamMember
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Member Profile: \(member.name)")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct AISkillMatcherView: View {
    let space: CollaborationSpace
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("AI Skill Matcher")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            .navigationTitle("Skill Matcher")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    CollaborationSpaceView(space: CollaborationSpace(
        name: "Innovation Hub",
        activeMembers: 12,
        skillsBeingShared: ["AI/ML", "Product Design", "Strategy"],
        icon: "lightbulb.2.fill",
        color: Theme.Colors.neonYellow
    ))
}
