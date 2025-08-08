//
//  MeetingScriptView.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  📜 Revolutionary Meeting Script Display - AI-Powered Insights
//  🎯 Transforms conversations into actionable career growth opportunities
//

import SwiftUI

struct MeetingScriptView: View {
    let meetingScript: MeetingScript
    @StateObject private var aiService = AIPostMeetingService.shared
    @State private var selectedTab: ScriptTab = .summary
    @State private var showingSaveOptions = false
    @State private var showingShareSheet = false
    @Namespace private var scriptNamespace
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.LiquidGlass.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with meeting info
                    meetingHeader
                    
                    // Tab selector
                    scriptTabs
                    
                    // Content area
                    ScrollView {
                        VStack(spacing: Theme.Spacing.large) {
                            switch selectedTab {
                            case .summary:
                                summarySection
                            case .transcript:
                                transcriptSection
                            case .insights:
                                insightsSection
                            case .bridging:
                                bridgingSection
                            case .actions:
                                actionsSection
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        .padding(.top, Theme.Spacing.medium)
                    }
                }
            }
            .navigationTitle("Meeting Script")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: Theme.Spacing.medium) {
                        // Save button
                        Button(action: {
                            showingSaveOptions = true
                        }) {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(Theme.Colors.textPrimary)
                                .neonGlow(color: Theme.Colors.neonBlue, pulse: true)
                        }
                        
                        // Share button
                        Button(action: {
                            showingShareSheet = true
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(Theme.Colors.textPrimary)
                                .neonGlow(color: Theme.Colors.neonGreen, pulse: true)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingSaveOptions) {
            SaveOptionsView(meetingScript: meetingScript)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheetView(meetingScript: meetingScript)
        }
    }
    
    // MARK: - Meeting Header
    private var meetingHeader: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("AI Meeting Analysis")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text("Generated \(meetingScript.generatedAt, style: .relative) ago")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                
                Spacer()
                
                // AI confidence indicator
                HStack(spacing: 6) {
                    Image(systemName: "brain.head.profile")
                        .foregroundColor(Theme.Colors.neonPink)
                        .font(.title3)
                        .neonGlow(color: Theme.Colors.neonPink, pulse: true)
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("AI Confidence")
                            .font(.caption2)
                            .foregroundColor(Theme.Colors.textSecondary)
                        
                        Text("\(Int(meetingScript.transcription.confidence * 100))%")
                            .font(Theme.Typography.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.Colors.neonPink)
                    }
                }
            }
            
            // Quick stats
            HStack(spacing: Theme.Spacing.large) {
                StatCard(
                    title: "Duration",
                    value: formatDuration(meetingScript.duration),
                    icon: "clock",
                    color: Theme.Colors.neonBlue
                )
                
                StatCard(
                    title: "Insights",
                    value: "\(meetingScript.actionableInsights.count)",
                    icon: "lightbulb.fill",
                    color: Theme.Colors.neonYellow
                )
                
                StatCard(
                    title: "Bridges",
                    value: "\(meetingScript.bridgingOpportunities.count)",
                    icon: "arrow.triangle.merge",
                    color: Theme.Colors.neonGreen
                )
                
                StatCard(
                    title: "Engagement",
                    value: "\(Int(meetingScript.analysis.overallEngagement * 100))%",
                    icon: "person.3.fill",
                    color: Theme.Colors.neonOrange
                )
            }
        }
        .padding()
        .liquidGlassCard()
        .padding(.horizontal, Theme.Spacing.large)
        .padding(.top, Theme.Spacing.medium)
    }
    
    // MARK: - Script Tabs
    private var scriptTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.medium) {
                ForEach(ScriptTab.allCases, id: \.self) { tab in
                    ScriptTabButton(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        action: {
                            withAnimation(.spring()) {
                                selectedTab = tab
                            }
                        }
                    )
                    .matchedGeometryEffect(id: "tab-\(tab.rawValue)", in: scriptNamespace)
                }
            }
            .padding(.horizontal, Theme.Spacing.large)
        }
        .padding(.vertical, Theme.Spacing.medium)
    }
    
    // MARK: - Summary Section
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large) {
            // Key highlights
            highlightsCard
            
            // Sentiment overview
            sentimentCard
            
            // Speaking time distribution
            speakingTimeCard
            
            // Topic overview
            topicsCard
        }
    }
    
    private var highlightsCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(Theme.Colors.neonYellow)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonYellow, pulse: true)
                
                Text("Key Highlights")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                HighlightRow(
                    icon: "checkmark.circle.fill",
                    text: "Strong team collaboration observed",
                    color: Theme.Colors.neonGreen
                )
                
                HighlightRow(
                    icon: "brain.head.profile",
                    text: "Multiple skill demonstrations identified",
                    color: Theme.Colors.neonPink
                )
                
                HighlightRow(
                    icon: "arrow.triangle.merge",
                    text: "\(meetingScript.bridgingOpportunities.count) bridging opportunities found",
                    color: Theme.Colors.neonBlue
                )
                
                HighlightRow(
                    icon: "target",
                    text: "\(meetingScript.analysis.decisions.actionItems.count) action items identified",
                    color: Theme.Colors.neonOrange
                )
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    private var sentimentCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(Theme.Colors.neonPink)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonPink, pulse: true)
                
                Text("Meeting Sentiment")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                // Sentiment indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(sentimentColor)
                        .frame(width: 12, height: 12)
                        .neonGlow(color: sentimentColor, pulse: true)
                    
                    Text(meetingScript.analysis.sentiment.overall.displayName)
                        .font(Theme.Typography.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(sentimentColor)
                }
            }
            
            Text("Overall meeting tone was \(meetingScript.analysis.sentiment.overall.displayName.lowercased()) with \(meetingScript.analysis.sentiment.emotionalTone.displayName.lowercased()) communication style.")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding()
        .liquidGlassCard()
    }
    
    private var speakingTimeCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "person.wave.2.fill")
                    .foregroundColor(Theme.Colors.neonBlue)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonBlue, pulse: true)
                
                Text("Participation")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
            }
            
            ForEach(Array(meetingScript.analysis.speakingTime.distribution.keys), id: \.self) { participantId in
                let duration = meetingScript.analysis.speakingTime.distribution[participantId] ?? 0
                let percentage = duration / meetingScript.analysis.speakingTime.totalDuration
                
                ParticipationBar(
                    participantName: getParticipantName(id: participantId),
                    percentage: percentage,
                    duration: duration
                )
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    private var topicsCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .foregroundColor(Theme.Colors.neonOrange)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonOrange, pulse: true)
                
                Text("Topics Discussed")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
            }
            
            FlowLayout(spacing: 8) {
                ForEach(meetingScript.analysis.topics.primaryTopics, id: \.self) { topic in
                    Text(topic)
                        .font(Theme.Typography.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Theme.Colors.glassPrimary,
                            in: Capsule()
                        )
                        .overlay(
                            Capsule()
                                .stroke(Theme.Colors.neonOrange.opacity(0.5), lineWidth: 1)
                        )
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Transcript Section
    private var transcriptSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "text.bubble.fill")
                    .foregroundColor(Theme.Colors.neonBlue)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonBlue, pulse: true)
                
                Text("Full Transcript")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(meetingScript.transcription.segments.count) segments")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            LazyVStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                ForEach(meetingScript.transcription.segments) { segment in
                    TranscriptSegment(segment: segment)
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Insights Section
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(Theme.Colors.neonYellow)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonYellow, pulse: true)
                
                Text("Actionable Insights")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(meetingScript.actionableInsights.count) insights")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            ForEach(meetingScript.actionableInsights) { insight in
                InsightCard(insight: insight)
            }
        }
    }
    
    // MARK: - Bridging Section
    private var bridgingSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large) {
            HStack {
                Image(systemName: "arrow.triangle.merge")
                    .foregroundColor(Theme.Colors.neonGreen)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonGreen, pulse: true)
                
                Text("Bridging Opportunities")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(meetingScript.bridgingOpportunities.count) opportunities")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            ForEach(meetingScript.bridgingOpportunities) { opportunity in
                BridgingOpportunityCard(opportunity: opportunity)
            }
        }
    }
    
    // MARK: - Actions Section
    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Theme.Colors.neonOrange)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonOrange, pulse: true)
                
                Text("Action Items")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(meetingScript.analysis.decisions.actionItems.count) actions")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            ForEach(Array(meetingScript.analysis.decisions.actionItems.enumerated()), id: \.offset) { index, action in
                ActionItemCard(action: action, index: index + 1)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private var sentimentColor: Color {
        switch meetingScript.analysis.sentiment.overall {
        case .positive: return Theme.Colors.neonGreen
        case .negative: return Color.red
        case .neutral: return Theme.Colors.neonBlue
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }
    
    private func getParticipantName(id: String) -> String {
        // In a real implementation, this would look up the participant name
        return id.capitalized
    }
}

// MARK: - Supporting Views

struct StatCard: View {
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

struct ScriptTabButton: View {
    let tab: ScriptTab
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

struct HighlightRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.caption)
                .frame(width: 16)
            
            Text(text)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            
            Spacer()
        }
    }
}

struct ParticipationBar: View {
    let participantName: String
    let percentage: Double
    let duration: TimeInterval
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(participantName)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(Int(percentage * 100))%")
                    .font(Theme.Typography.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Theme.Colors.glassPrimary)
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(Theme.Colors.neonBlue)
                        .frame(width: geometry.size.width * percentage, height: 6)
                        .cornerRadius(3)
                        .animation(.easeInOut(duration: 1), value: percentage)
                }
            }
            .frame(height: 6)
        }
    }
}

struct TranscriptSegment: View {
    let segment: ConversationSegment
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Timestamp
            Text(formatTimestamp(segment.startTime))
                .font(.caption2)
                .foregroundColor(Theme.Colors.textTertiary)
                .frame(width: 50, alignment: .leading)
            
            // Speaker and content
            VStack(alignment: .leading, spacing: 4) {
                Text(segment.speakerId.capitalized)
                    .font(Theme.Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.neonBlue)
                
                Text(segment.text)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding()
        .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 12))
    }
    
    private func formatTimestamp(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }
}

struct InsightCard: View {
    let insight: ActionableInsight
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: insight.type.icon)
                    .foregroundColor(insight.type.color)
                    .font(.title3)
                    .neonGlow(color: insight.type.color, pulse: true)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(insight.title)
                        .font(Theme.Typography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text(insight.type.displayName)
                        .font(.caption2)
                        .foregroundColor(insight.type.color)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                // Priority indicator
                PriorityBadge(priority: insight.priority)
            }
            
            Text(insight.description)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            
            if !insight.recommendation.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb")
                        .foregroundColor(Theme.Colors.neonYellow)
                        .font(.caption)
                    
                    Text(insight.recommendation)
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .italic()
                }
            }
        }
        .padding()
        .liquidGlassCard()
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(insight.type.color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct BridgingOpportunityCard: View {
    let opportunity: BridgingOpportunity
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: opportunity.type.icon)
                    .foregroundColor(opportunity.type.color)
                    .font(.title3)
                    .neonGlow(color: opportunity.type.color, pulse: true)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(opportunity.title)
                        .font(Theme.Typography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text(opportunity.type.displayName)
                        .font(.caption2)
                        .foregroundColor(opportunity.type.color)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                // Impact indicator
                ImpactBadge(impact: opportunity.impactLevel)
            }
            
            Text(opportunity.description)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            
            // Suggested actions
            VStack(alignment: .leading, spacing: 6) {
                Text("Suggested Actions:")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                ForEach(Array(opportunity.suggestedActions.enumerated()), id: \.offset) { index, action in
                    HStack(spacing: 8) {
                        Text("\(index + 1).")
                            .font(.caption2)
                            .foregroundColor(opportunity.type.color)
                            .fontWeight(.bold)
                        
                        Text(action)
                            .font(.caption2)
                            .foregroundColor(Theme.Colors.textSecondary)
                        
                        Spacer()
                    }
                }
            }
            
            // Timeframe
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(Theme.Colors.textTertiary)
                    .font(.caption2)
                
                Text("Timeframe: \(opportunity.estimatedTimeframe)")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textTertiary)
                
                Spacer()
            }
        }
        .padding()
        .liquidGlassCard()
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(opportunity.type.color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct ActionItemCard: View {
    let action: String
    let index: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // Index circle
            ZStack {
                Circle()
                    .fill(Theme.Colors.neonOrange.opacity(0.3))
                    .frame(width: 24, height: 24)
                
                Text("\(index)")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.neonOrange)
            }
            
            Text(action)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            
            Spacer()
        }
        .padding()
        .liquidGlassCard()
    }
}

struct PriorityBadge: View {
    let priority: InsightPriority
    
    var body: some View {
        Text(priority.displayName)
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(priority.color, in: Capsule())
    }
}

struct ImpactBadge: View {
    let impact: ImpactLevel
    
    var body: some View {
        Text(impact.displayName)
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(impact.color, in: Capsule())
    }
}

// MARK: - Supporting Types

enum ScriptTab: String, CaseIterable {
    case summary = "Summary"
    case transcript = "Transcript"
    case insights = "Insights"
    case bridging = "Bridging"
    case actions = "Actions"
    
    var title: String { rawValue }
    
    var icon: String {
        switch self {
        case .summary: return "doc.text.fill"
        case .transcript: return "text.bubble.fill"
        case .insights: return "lightbulb.fill"
        case .bridging: return "arrow.triangle.merge"
        case .actions: return "checkmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .summary: return Theme.Colors.neonBlue
        case .transcript: return Theme.Colors.neonGreen
        case .insights: return Theme.Colors.neonYellow
        case .bridging: return Theme.Colors.neonPink
        case .actions: return Theme.Colors.neonOrange
        }
    }
}

// MARK: - Extension for Display Names

extension SentimentType {
    var displayName: String {
        switch self {
        case .positive: return "Positive"
        case .negative: return "Negative"
        case .neutral: return "Neutral"
        }
    }
}

extension EmotionalTone {
    var displayName: String {
        switch self {
        case .professional: return "Professional"
        case .casual: return "Casual"
        case .energetic: return "Energetic"
        case .serious: return "Serious"
        }
    }
}

extension InsightType {
    var displayName: String {
        switch self {
        case .communication: return "Communication"
        case .skillDevelopment: return "Skill Development"
        case .collaboration: return "Collaboration"
        case .leadership: return "Leadership"
        case .process: return "Process"
        }
    }
    
    var icon: String {
        switch self {
        case .communication: return "bubble.left.and.bubble.right"
        case .skillDevelopment: return "brain.head.profile"
        case .collaboration: return "person.3"
        case .leadership: return "crown"
        case .process: return "gearshape"
        }
    }
    
    var color: Color {
        switch self {
        case .communication: return Theme.Colors.neonBlue
        case .skillDevelopment: return Theme.Colors.neonPink
        case .collaboration: return Theme.Colors.neonGreen
        case .leadership: return Theme.Colors.neonYellow
        case .process: return Theme.Colors.neonOrange
        }
    }
}

extension InsightPriority {
    var displayName: String {
        switch self {
        case .critical: return "Critical"
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        case .info: return "Info"
        }
    }
    
    var color: Color {
        switch self {
        case .critical: return Color.red
        case .high: return Theme.Colors.neonOrange
        case .medium: return Theme.Colors.neonYellow
        case .low: return Theme.Colors.neonBlue
        case .info: return Theme.Colors.textSecondary
        }
    }
}

extension BridgingType {
    var displayName: String {
        switch self {
        case .skillGap: return "Skill Gap"
        case .communication: return "Communication"
        case .knowledgeTransfer: return "Knowledge Transfer"
        case .crossFunctional: return "Cross-Functional"
        }
    }
    
    var icon: String {
        switch self {
        case .skillGap: return "arrow.up.and.down"
        case .communication: return "message"
        case .knowledgeTransfer: return "arrow.2.squarepath"
        case .crossFunctional: return "arrow.triangle.branch"
        }
    }
    
    var color: Color {
        switch self {
        case .skillGap: return Theme.Colors.neonPink
        case .communication: return Theme.Colors.neonBlue
        case .knowledgeTransfer: return Theme.Colors.neonGreen
        case .crossFunctional: return Theme.Colors.neonOrange
        }
    }
}

extension ImpactLevel {
    var displayName: String {
        switch self {
        case .high: return "High Impact"
        case .medium: return "Medium Impact"
        case .low: return "Low Impact"
        }
    }
    
    var color: Color {
        switch self {
        case .high: return Theme.Colors.neonGreen
        case .medium: return Theme.Colors.neonYellow
        case .low: return Theme.Colors.neonBlue
        }
    }
}

// MARK: - Save and Share Views (Placeholder)

struct SaveOptionsView: View {
    let meetingScript: MeetingScript
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Save Options")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                // Save options implementation
            }
            .navigationTitle("Save Script")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct ShareSheetView: View {
    let meetingScript: MeetingScript
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Share Options")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                // Share options implementation
            }
            .navigationTitle("Share Script")
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
    MeetingScriptView(meetingScript: MeetingScript(
        meetingId: "test-meeting",
        transcription: ConversationTranscript(
            segments: [],
            fullText: "Sample meeting transcript",
            duration: 1800,
            confidence: 0.87
        ),
        analysis: ConversationAnalysis(
            speakingTime: SpeakingTimeAnalysis(distribution: [:], totalDuration: 1800, dominantSpeaker: nil),
            topics: TopicAnalysis(primaryTopics: ["Strategy", "Innovation"], topicDistribution: [:], keyThemes: []),
            sentiment: SentimentAnalysis(overall: .positive, confidence: 0.8, positiveKeywords: [], negativeKeywords: [], emotionalTone: .professional),
            decisions: DecisionAnalysis(decisions: [], actionItems: [], followUpRequired: false, decisionQuality: .high),
            teamDynamics: TeamDynamicsAnalysis(collaborationLevel: .high, leadershipPattern: .distributed, participationBalance: .balanced, interactionMatrix: [:], conflictLevel: .low),
            overallEngagement: 0.87
        ),
        actionableInsights: [],
        bridgingOpportunities: [],
        duration: 1800,
        generatedAt: Date()
    ))
}
