//
//  MeetingListView.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  📅 Revolutionary Meeting Management - Team Collaboration Spaces
//  🌟 Bridging Gaps Through Smart Meeting Organization
//

import SwiftUI

struct MeetingListView: View {
    @StateObject private var viewModel = MeetingListViewModel()
    @State private var showingNewMeeting = false
    @State private var selectedMeetingType: MeetingType = .collaboration
    @Namespace private var meetingNamespace
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.LiquidGlass.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Theme.Spacing.large) {
                        // Header with AI-powered insights
                        meetingInsightsHeader
                        
                        // Quick Actions for Gap Bridging
                        quickBridgingActions
                        
                        // Meeting Categories
                        meetingCategories
                        
                        // Upcoming Meetings
                        upcomingMeetings
                        
                        // Team Collaboration Spaces
                        collaborationSpaces
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.top, Theme.Spacing.medium)
                }
            }
            .navigationTitle("Meetings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewMeeting = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(Theme.Colors.textPrimary)
                            .neonGlow(color: Theme.Colors.neonBlue, pulse: true)
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewMeeting) {
            NewMeetingView()
        }
        .onAppear {
            viewModel.loadMeetings()
        }
    }
    
    // MARK: - Meeting Insights Header
    private var meetingInsightsHeader: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(Theme.Colors.neonPink)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonPink, pulse: true)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("AI Meeting Insights")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text("Optimizing collaboration efficiency")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                
                Spacer()
            }
            
            // Weekly insights grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: Theme.Spacing.medium) {
                InsightCard(
                    title: "Team Alignment",
                    value: "87%",
                    trend: .up,
                    color: Theme.Colors.neonGreen,
                    icon: "arrow.triangle.merge"
                )
                
                InsightCard(
                    title: "Cross-Dept Bridges",
                    value: "12",
                    trend: .up,
                    color: Theme.Colors.neonBlue,
                    icon: "network"
                )
                
                InsightCard(
                    title: "Skill Exchanges",
                    value: "24",
                    trend: .up,
                    color: Theme.Colors.neonOrange,
                    icon: "arrow.2.squarepath"
                )
                
                InsightCard(
                    title: "Innovation Ideas",
                    value: "8",
                    trend: .up,
                    color: Theme.Colors.neonYellow,
                    icon: "lightbulb.fill"
                )
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Quick Bridging Actions
    private var quickBridgingActions: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "figure.2.and.child.holdinghands")
                    .foregroundColor(Theme.Colors.neonBlue)
                    .font(.title3)
                
                Text("Bridge Gaps")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Theme.Spacing.medium) {
                    BridgingActionCard(
                        title: "1:1 Coaching",
                        subtitle: "Skill development",
                        icon: "person.badge.plus",
                        color: Theme.Colors.neonGreen,
                        action: { createCoachingSession() }
                    )
                    
                    BridgingActionCard(
                        title: "Cross-Team Sync",
                        subtitle: "Department bridge",
                        icon: "arrow.triangle.branch",
                        color: Theme.Colors.neonBlue,
                        action: { createCrossTeamMeeting() }
                    )
                    
                    BridgingActionCard(
                        title: "Skill Exchange",
                        subtitle: "Peer learning",
                        icon: "arrow.2.squarepath",
                        color: Theme.Colors.neonOrange,
                        action: { createSkillExchange() }
                    )
                    
                    BridgingActionCard(
                        title: "Innovation Lab",
                        subtitle: "Creative session",
                        icon: "lightbulb.2.fill",
                        color: Theme.Colors.neonPink,
                        action: { createInnovationSession() }
                    )
                }
                .padding(.horizontal, 2)
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Meeting Categories
    private var meetingCategories: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Meeting Types")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Theme.Spacing.medium) {
                    ForEach(MeetingType.allCases, id: \.self) { type in
                        CategoryCard(
                            type: type,
                            isSelected: selectedMeetingType == type,
                            action: { selectedMeetingType = type }
                        )
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }
    
    // MARK: - Upcoming Meetings
    private var upcomingMeetings: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Text("Upcoming")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(viewModel.upcomingMeetings.count) meetings")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            ForEach(viewModel.upcomingMeetings) { meeting in
                MeetingCard(meeting: meeting)
                    .matchedGeometryEffect(id: "meeting-\(meeting.id)", in: meetingNamespace)
            }
        }
    }
    
    // MARK: - Collaboration Spaces
    private var collaborationSpaces: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "building.2.crop.circle")
                    .foregroundColor(Theme.Colors.neonBlue)
                    .font(.title3)
                
                Text("Team Spaces")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
            }
            
            ForEach(viewModel.collaborationSpaces) { space in
                CollaborationSpaceCard(space: space)
            }
        }
    }
    
    // MARK: - Actions
    private func createCoachingSession() {
        HapticManager.shared.impact(.medium)
        // Create 1:1 coaching session
    }
    
    private func createCrossTeamMeeting() {
        HapticManager.shared.impact(.medium)
        // Create cross-team bridge meeting
    }
    
    private func createSkillExchange() {
        HapticManager.shared.impact(.medium)
        // Create skill exchange session
    }
    
    private func createInnovationSession() {
        HapticManager.shared.impact(.medium)
        // Create innovation lab session
    }
}

// MARK: - Supporting Views

struct InsightCard: View {
    let title: String
    let value: String
    let trend: TrendDirection
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Spacer()
                
                Image(systemName: trend == .up ? "arrow.up.right" : "arrow.down.right")
                    .foregroundColor(trend == .up ? Theme.Colors.neonGreen : Color.red)
                    .font(.caption)
            }
            
            Text(value)
                .font(Theme.Typography.title2)
                .fontWeight(.bold)
                .foregroundColor(Theme.Colors.textPrimary)
                .neonGlow(color: color, pulse: true)
            
            Text(title)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding()
        .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 16))
        .liquidGlassGlow(color: color, radius: 8, intensity: 0.6)
    }
}

struct BridgingActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .neonGlow(color: color, pulse: true)
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(Theme.Typography.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text(subtitle)
                        .font(Theme.Typography.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }
            .padding()
            .frame(width: 100, height: 80)
            .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 16))
            .liquidGlassGlow(color: color, radius: 6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategoryCard: View {
    let type: MeetingType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: type.icon)
                    .foregroundColor(isSelected ? type.color : Theme.Colors.textSecondary)
                    .font(.title3)
                
                Text(type.rawValue)
                    .font(Theme.Typography.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? Theme.Colors.textPrimary : Theme.Colors.textSecondary)
            }
            .padding(.horizontal, Theme.Spacing.medium)
            .padding(.vertical, Theme.Spacing.small)
            .background(
                isSelected ? type.color.opacity(0.2) : Theme.Colors.glassPrimary,
                in: Capsule()
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? type.color : Color.clear, lineWidth: 1)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MeetingCard: View {
    let meeting: Meeting
    
    var body: some View {
        NavigationLink(destination: ConferenceCallView()) {
            HStack(spacing: Theme.Spacing.medium) {
                // Meeting type indicator
                Circle()
                    .fill(meeting.type.color)
                    .frame(width: 12, height: 12)
                    .neonGlow(color: meeting.type.color, pulse: true)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(meeting.title)
                        .font(Theme.Typography.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    HStack {
                        Text(meeting.formattedTime)
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                        
                        Text("•")
                            .foregroundColor(Theme.Colors.textSecondary)
                        
                        Text("\(meeting.participants.count) participants")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }
                
                Spacer()
                
                // Skill bridging indicator
                if meeting.isBridgingMeeting {
                    Image(systemName: "arrow.triangle.merge")
                        .foregroundColor(Theme.Colors.neonBlue)
                        .font(.caption)
                        .neonGlow(color: Theme.Colors.neonBlue, pulse: true)
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.Colors.textTertiary)
                    .font(.caption)
            }
            .padding()
            .liquidGlassCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CollaborationSpaceCard: View {
    let space: CollaborationSpace
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            // Space avatar/icon
            ZStack {
                Circle()
                    .fill(space.color.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Image(systemName: space.icon)
                    .foregroundColor(space.color)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(space.name)
                    .font(Theme.Typography.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text("\(space.activeMembers) active • \(space.skillsBeingShared.count) skills shared")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                
                // Skills being shared
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(space.skillsBeingShared.prefix(3), id: \.self) { skill in
                            Text(skill)
                                .font(.caption2)
                                .foregroundColor(Theme.Colors.textPrimary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(space.color.opacity(0.3), in: Capsule())
                        }
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                // Join collaboration space
            }) {
                Text("Join")
                    .font(Theme.Typography.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.horizontal, Theme.Spacing.medium)
                    .padding(.vertical, Theme.Spacing.small)
                    .background(space.color.opacity(0.3), in: Capsule())
                    .liquidGlassGlow(color: space.color, radius: 4)
            }
        }
        .padding()
        .liquidGlassCard()
    }
}

// MARK: - Supporting Models and Enums

enum MeetingType: String, CaseIterable {
    case collaboration = "Collaboration"
    case oneOnOne = "1:1 Coaching"
    case skillExchange = "Skill Exchange"
    case crossTeam = "Cross-Team"
    case innovation = "Innovation"
    
    var icon: String {
        switch self {
        case .collaboration: return "person.3.fill"
        case .oneOnOne: return "person.badge.plus"
        case .skillExchange: return "arrow.2.squarepath"
        case .crossTeam: return "arrow.triangle.branch"
        case .innovation: return "lightbulb.2.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .collaboration: return Theme.Colors.neonBlue
        case .oneOnOne: return Theme.Colors.neonGreen
        case .skillExchange: return Theme.Colors.neonOrange
        case .crossTeam: return Theme.Colors.neonPink
        case .innovation: return Theme.Colors.neonYellow
        }
    }
}

enum TrendDirection {
    case up, down
}

struct Meeting: Identifiable {
    let id = UUID()
    let title: String
    let scheduledTime: Date
    let participants: [String]
    let type: MeetingType
    let isBridgingMeeting: Bool
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: scheduledTime)
    }
}

struct CollaborationSpace: Identifiable {
    let id = UUID()
    let name: String
    let activeMembers: Int
    let skillsBeingShared: [String]
    let icon: String
    let color: Color
}

// MARK: - View Model

class MeetingListViewModel: ObservableObject {
    @Published var upcomingMeetings: [Meeting] = []
    @Published var collaborationSpaces: [CollaborationSpace] = []
    
    func loadMeetings() {
        // Mock data for demonstration
        upcomingMeetings = [
            Meeting(
                title: "Product Strategy Sync",
                scheduledTime: Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date(),
                participants: ["Sarah Chen", "Marcus Rodriguez", "Elena Popov"],
                type: .collaboration,
                isBridgingMeeting: true
            ),
            Meeting(
                title: "1:1 Career Coaching",
                scheduledTime: Calendar.current.date(byAdding: .hour, value: 3, to: Date()) ?? Date(),
                participants: ["James Wilson"],
                type: .oneOnOne,
                isBridgingMeeting: false
            ),
            Meeting(
                title: "Design-Engineering Bridge",
                scheduledTime: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
                participants: ["Design Team", "Engineering Team"],
                type: .crossTeam,
                isBridgingMeeting: true
            )
        ]
        
        collaborationSpaces = [
            CollaborationSpace(
                name: "Innovation Hub",
                activeMembers: 12,
                skillsBeingShared: ["AI/ML", "Product Design", "Strategy"],
                icon: "lightbulb.2.fill",
                color: Theme.Colors.neonYellow
            ),
            CollaborationSpace(
                name: "Cross-Functional Bridge",
                activeMembers: 8,
                skillsBeingShared: ["Data Science", "Marketing", "Engineering"],
                icon: "arrow.triangle.merge",
                color: Theme.Colors.neonBlue
            )
        ]
    }
}

#Preview {
    MeetingListView()
}
