//
//  NewMeetingView.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  ➕ Create Revolutionary Meetings - AI-Powered Scheduling
//  🌉 Smart Gap Detection & Bridge Building
//

import SwiftUI

struct NewMeetingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = NewMeetingViewModel()
    @State private var selectedMeetingType: MeetingType = .collaboration
    @State private var meetingTitle = ""
    @State private var selectedDate = Date()
    @State private var selectedParticipants: Set<String> = []
    @State private var aiSuggestionVisible = false
    @Namespace private var formNamespace
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.LiquidGlass.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Theme.Spacing.large) {
                        // AI-Powered Meeting Suggestions
                        aiSuggestionsSection
                        
                        // Meeting Type Selection
                        meetingTypeSection
                        
                        // Meeting Details Form
                        meetingDetailsForm
                        
                        // Smart Participant Selection
                        participantSelectionSection
                        
                        // Gap Bridging Insights
                        if viewModel.showBridgingInsights {
                            bridgingInsightsSection
                        }
                        
                        // Create Meeting Button
                        createMeetingButton
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.top, Theme.Spacing.medium)
                }
            }
            .navigationTitle("New Meeting")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Theme.Colors.textSecondary)
                }
            }
        }
        .onAppear {
            viewModel.loadSuggestions()
        }
    }
    
    // MARK: - AI Suggestions Section
    private var aiSuggestionsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(Theme.Colors.neonPink)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonPink, pulse: true)
                
                Text("AI Suggestions")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        aiSuggestionVisible.toggle()
                    }
                }) {
                    Image(systemName: aiSuggestionVisible ? "chevron.up" : "chevron.down")
                        .foregroundColor(Theme.Colors.textSecondary)
                        .font(.caption)
                }
            }
            
            if aiSuggestionVisible {
                ForEach(viewModel.aiSuggestions) { suggestion in
                    AISuggestionCard(suggestion: suggestion) {
                        applySuggestion(suggestion)
                    }
                }
            }
        }
        .padding()
        .liquidGlassCard()
        .onAppear {
            withAnimation(.spring().delay(0.5)) {
                aiSuggestionVisible = true
            }
        }
    }
    
    // MARK: - Meeting Type Section
    private var meetingTypeSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Meeting Type")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: Theme.Spacing.medium) {
                ForEach(MeetingType.allCases, id: \.self) { type in
                    MeetingTypeCard(
                        type: type,
                        isSelected: selectedMeetingType == type
                    ) {
                        withAnimation(.spring()) {
                            selectedMeetingType = type
                            viewModel.updateMeetingType(type)
                        }
                    }
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Meeting Details Form
    private var meetingDetailsForm: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large) {
            Text("Meeting Details")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            // Title Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Title")
                    .font(Theme.Typography.subheadline)
                    .foregroundColor(Theme.Colors.textSecondary)
                
                TextField("Enter meeting title", text: $meetingTitle)
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding()
                    .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.Colors.glowPrimary.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Date & Time Picker
            VStack(alignment: .leading, spacing: 8) {
                Text("Date & Time")
                    .font(Theme.Typography.subheadline)
                    .foregroundColor(Theme.Colors.textSecondary)
                
                DatePicker("Select date and time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding()
                    .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 12))
            }
            
            // Duration Picker
            VStack(alignment: .leading, spacing: 8) {
                Text("Duration")
                    .font(Theme.Typography.subheadline)
                    .foregroundColor(Theme.Colors.textSecondary)
                
                Picker("Duration", selection: $viewModel.selectedDuration) {
                    ForEach(viewModel.durationOptions, id: \.self) { duration in
                        Text(duration.formatted)
                            .tag(duration)
                    }
                }
                .pickerStyle(.segmented)
                .colorScheme(.dark)
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Participant Selection
    private var participantSelectionSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Text("Participants")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(selectedParticipants.count) selected")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            // Smart suggestions based on meeting type
            if !viewModel.suggestedParticipants.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("AI Suggested")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.neonPink)
                        .fontWeight(.semibold)
                    
                    FlowLayout(spacing: 8) {
                        ForEach(viewModel.suggestedParticipants) { participant in
                            ParticipantChip(
                                participant: participant,
                                isSelected: selectedParticipants.contains(participant.id),
                                isSuggested: true
                            ) {
                                toggleParticipant(participant.id)
                            }
                        }
                    }
                }
            }
            
            // All available participants
            VStack(alignment: .leading, spacing: 8) {
                Text("Team Members")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .fontWeight(.semibold)
                
                FlowLayout(spacing: 8) {
                    ForEach(viewModel.allParticipants) { participant in
                        ParticipantChip(
                            participant: participant,
                            isSelected: selectedParticipants.contains(participant.id),
                            isSuggested: false
                        ) {
                            toggleParticipant(participant.id)
                        }
                    }
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    // MARK: - Bridging Insights
    private var bridgingInsightsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "arrow.triangle.merge")
                    .foregroundColor(Theme.Colors.neonBlue)
                    .font(.title3)
                    .neonGlow(color: Theme.Colors.neonBlue, pulse: true)
                
                Text("Bridging Opportunities")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
            }
            
            ForEach(viewModel.bridgingInsights) { insight in
                BridgingInsightCard(insight: insight)
            }
        }
        .padding()
        .liquidGlassCard()
        .transition(.asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        ))
    }
    
    // MARK: - Create Meeting Button
    private var createMeetingButton: some View {
        Button(action: {
            createMeeting()
        }) {
            HStack(spacing: 12) {
                if viewModel.isCreating {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.textPrimary))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
                
                Text(viewModel.isCreating ? "Creating Meeting..." : "Create Meeting")
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(Theme.Colors.textPrimary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                selectedMeetingType.color.opacity(0.8),
                in: RoundedRectangle(cornerRadius: 16)
            )
            .liquidGlassGlow(color: selectedMeetingType.color, radius: 12)
            .scaleEffect(viewModel.isCreating ? 0.95 : 1.0)
            .animation(.spring(), value: viewModel.isCreating)
        }
        .disabled(viewModel.isCreating || meetingTitle.isEmpty || selectedParticipants.isEmpty)
        .opacity(viewModel.isCreating || meetingTitle.isEmpty || selectedParticipants.isEmpty ? 0.6 : 1.0)
        .padding(.horizontal)
    }
    
    // MARK: - Actions
    private func applySuggestion(_ suggestion: AISuggestion) {
        withAnimation(.spring()) {
            selectedMeetingType = suggestion.type
            meetingTitle = suggestion.title
            selectedParticipants = Set(suggestion.suggestedParticipants)
            viewModel.updateMeetingType(suggestion.type)
        }
        
        HapticManager.shared.impact(.medium)
    }
    
    private func toggleParticipant(_ participantId: String) {
        withAnimation(.spring()) {
            if selectedParticipants.contains(participantId) {
                selectedParticipants.remove(participantId)
            } else {
                selectedParticipants.insert(participantId)
            }
            viewModel.updateParticipants(Array(selectedParticipants))
        }
        
        HapticManager.shared.impact(.light)
    }
    
    private func createMeeting() {
        viewModel.createMeeting(
            title: meetingTitle,
            type: selectedMeetingType,
            date: selectedDate,
            participants: Array(selectedParticipants)
        ) { success in
            if success {
                HapticManager.shared.impact(.medium)
                dismiss()
            }
        }
    }
}

// MARK: - Supporting Views

struct AISuggestionCard: View {
    let suggestion: AISuggestion
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: suggestion.type.icon)
                        .foregroundColor(suggestion.type.color)
                        .font(.title3)
                    
                    Text(suggestion.title)
                        .font(Theme.Typography.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Spacer()
                    
                    Text("AI")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.neonPink)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Theme.Colors.neonPink.opacity(0.2), in: Capsule())
                }
                
                Text(suggestion.reason)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text("\(suggestion.suggestedParticipants.count) participants")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textTertiary)
                    
                    Spacer()
                    
                    Text("Tap to apply")
                        .font(.caption2)
                        .foregroundColor(suggestion.type.color)
                }
            }
            .padding()
            .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(suggestion.type.color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MeetingTypeCard: View {
    let type: MeetingType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: type.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? type.color : Theme.Colors.textSecondary)
                    .neonGlow(color: isSelected ? type.color : .clear, pulse: isSelected)
                
                Text(type.rawValue)
                    .font(Theme.Typography.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? Theme.Colors.textPrimary : Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                isSelected ? type.color.opacity(0.2) : Theme.Colors.glassPrimary,
                in: RoundedRectangle(cornerRadius: 16)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? type.color : Color.clear, lineWidth: 1)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ParticipantChip: View {
    let participant: Participant
    let isSelected: Bool
    let isSuggested: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                // Avatar or initials
                Circle()
                    .fill(participant.color)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Text(participant.initials)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    )
                
                Text(participant.name)
                    .font(Theme.Typography.caption)
                    .foregroundColor(isSelected ? Theme.Colors.textPrimary : Theme.Colors.textSecondary)
                
                if isSuggested {
                    Image(systemName: "brain.head.profile")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.neonPink)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                isSelected ? participant.color.opacity(0.3) : Theme.Colors.glassPrimary,
                in: Capsule()
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? participant.color : Color.clear, lineWidth: 1)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BridgingInsightCard: View {
    let insight: BridgingInsight
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: insight.icon)
                .foregroundColor(insight.color)
                .font(.title3)
                .neonGlow(color: insight.color, pulse: true)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(Theme.Typography.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text(insight.description)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                
                Text("Impact: \(insight.impactLevel)")
                    .font(.caption2)
                    .foregroundColor(insight.color)
                    .fontWeight(.semibold)
            }
            
            Spacer()
        }
        .padding()
        .background(insight.color.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(insight.color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Flow Layout for Chips
struct FlowLayout: Layout {
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return calculateSize(sizes: sizes, proposal: proposal)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        var point = CGPoint(x: bounds.minX, y: bounds.minY)
        
        for (index, subview) in subviews.enumerated() {
            let size = sizes[index]
            
            if point.x + size.width > bounds.maxX && point.x > bounds.minX {
                point.x = bounds.minX
                point.y += size.height + spacing
            }
            
            subview.place(at: point, proposal: ProposedViewSize(size))
            point.x += size.width + spacing
        }
    }
    
    private func calculateSize(sizes: [CGSize], proposal: ProposedViewSize) -> CGSize {
        guard let proposalWidth = proposal.width else {
            return CGSize(width: 300, height: 100)
        }
        
        var height: CGFloat = 0
        var currentLineHeight: CGFloat = 0
        var x: CGFloat = 0
        
        for size in sizes {
            if x + size.width > proposalWidth && x > 0 {
                height += currentLineHeight + spacing
                currentLineHeight = 0
                x = 0
            }
            
            currentLineHeight = max(currentLineHeight, size.height)
            x += size.width + spacing
        }
        
        height += currentLineHeight
        return CGSize(width: proposalWidth, height: height)
    }
}

// MARK: - Supporting Models

struct AISuggestion: Identifiable {
    let id = UUID()
    let title: String
    let type: MeetingType
    let reason: String
    let suggestedParticipants: [String]
    let confidence: Double
}

struct Participant: Identifiable {
    let id: String
    let name: String
    let role: String
    let skills: [String]
    let color: Color
    
    var initials: String {
        name.components(separatedBy: " ")
            .compactMap { $0.first }
            .prefix(2)
            .map { String($0) }
            .joined()
    }
}

struct BridgingInsight: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let impactLevel: String
}

struct MeetingDuration {
    let minutes: Int
    
    var formatted: String {
        if minutes < 60 {
            return "\(minutes)m"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            if remainingMinutes == 0 {
                return "\(hours)h"
            } else {
                return "\(hours)h \(remainingMinutes)m"
            }
        }
    }
}

extension MeetingDuration: Hashable, Equatable {}

// MARK: - View Model

class NewMeetingViewModel: ObservableObject {
    @Published var aiSuggestions: [AISuggestion] = []
    @Published var suggestedParticipants: [Participant] = []
    @Published var allParticipants: [Participant] = []
    @Published var bridgingInsights: [BridgingInsight] = []
    @Published var showBridgingInsights = false
    @Published var isCreating = false
    @Published var selectedDuration = MeetingDuration(minutes: 30)
    
    let durationOptions = [
        MeetingDuration(minutes: 15),
        MeetingDuration(minutes: 30),
        MeetingDuration(minutes: 60),
        MeetingDuration(minutes: 90)
    ]
    
    func loadSuggestions() {
        // Mock AI suggestions
        aiSuggestions = [
            AISuggestion(
                title: "Design-Engineering Sync",
                type: .crossTeam,
                reason: "Detected communication gap between design and engineering teams",
                suggestedParticipants: ["sarah-chen", "marcus-rodriguez"],
                confidence: 0.92
            ),
            AISuggestion(
                title: "Product Strategy Review",
                type: .collaboration,
                reason: "Key decisions pending, high-impact stakeholders available",
                suggestedParticipants: ["elena-popov", "james-wilson", "sarah-chen"],
                confidence: 0.87
            )
        ]
        
        // Mock participants
        allParticipants = [
            Participant(id: "sarah-chen", name: "Sarah Chen", role: "Product Manager", skills: ["Strategy", "UX"], color: Theme.Colors.neonBlue),
            Participant(id: "marcus-rodriguez", name: "Marcus Rodriguez", role: "Senior Engineer", skills: ["iOS", "Backend"], color: Theme.Colors.neonGreen),
            Participant(id: "elena-popov", name: "Elena Popov", role: "Design Lead", skills: ["UI/UX", "Research"], color: Theme.Colors.neonOrange),
            Participant(id: "james-wilson", name: "James Wilson", role: "Marketing", skills: ["Growth", "Analytics"], color: Theme.Colors.neonPink)
        ]
    }
    
    func updateMeetingType(_ type: MeetingType) {
        // Update suggested participants based on meeting type
        switch type {
        case .crossTeam:
            suggestedParticipants = Array(allParticipants.prefix(2))
            showBridgingInsights = true
            bridgingInsights = [
                BridgingInsight(
                    title: "Skill Gap Bridge",
                    description: "Connect design thinking with technical implementation",
                    icon: "arrow.triangle.merge",
                    color: Theme.Colors.neonBlue,
                    impactLevel: "High"
                )
            ]
        case .oneOnOne:
            suggestedParticipants = Array(allParticipants.prefix(1))
            showBridgingInsights = false
        default:
            suggestedParticipants = Array(allParticipants.prefix(3))
            showBridgingInsights = type == .skillExchange
        }
    }
    
    func updateParticipants(_ participants: [String]) {
        // Update bridging insights based on selected participants
        if participants.count >= 2 {
            showBridgingInsights = true
        }
    }
    
    func createMeeting(title: String, type: MeetingType, date: Date, participants: [String], completion: @escaping (Bool) -> Void) {
        isCreating = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isCreating = false
            completion(true)
        }
    }
}

#Preview {
    NewMeetingView()
}
