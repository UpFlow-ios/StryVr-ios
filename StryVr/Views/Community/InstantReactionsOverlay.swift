//
//  InstantReactionsOverlay.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  💫 Revolutionary Instant Reactions Overlay - Real-Time Gen Z Engagement
//  ⚡ Floating Emojis, Authenticity Boosts & Live Feedback During Any Interaction
//

import SwiftUI

struct InstantReactionsOverlay: View {
    @StateObject private var genZService = GenZEngagementService.shared
    @State private var showingReactionPicker = false
    @State private var selectedReactions: [InstantReactionDisplay] = []
    @Namespace private var reactionNamespace

    let targetId: String
    let context: String

    var body: some View {
        ZStack {
            // Floating reactions
            ForEach(selectedReactions) { reaction in
                FloatingReactionView(reaction: reaction)
                    .matchedGeometryEffect(id: "reaction-\(reaction.id)", in: reactionNamespace)
                    .onAppear {
                        // Auto-remove after animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            removeReaction(reaction)
                        }
                    }
            }

            // Quick reaction toolbar (appears on long press or trigger)
            if showingReactionPicker {
                quickReactionPicker
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .onTapGesture(count: 2) {
            // Double tap to show reaction picker
            showReactionPicker()
        }
        .onLongPressGesture {
            // Long press to show reaction picker
            showReactionPicker()
        }
    }

    // MARK: - Quick Reaction Picker
    private var quickReactionPicker: some View {
        VStack {
            Spacer()

            HStack(spacing: Theme.Spacing.medium) {
                ForEach(ReactionType.allCases.prefix(6), id: \.self) { reactionType in
                    Button(action: {
                        sendReaction(reactionType)
                    }) {
                        VStack(spacing: 4) {
                            Text(reactionType.rawValue)
                                .font(.title2)
                                .scaleEffect(1.2)

                            Text(reactionType.description)
                                .font(.caption2)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }
                        .padding()
                        .background(
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 16)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Theme.Colors.neonBlue.opacity(0.3), lineWidth: 1)
                        )
                        .liquidGlassGlow(color: Theme.Colors.neonBlue, radius: 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .matchedGeometryEffect(
                        id: "picker-\(reactionType.rawValue)", in: reactionNamespace)
                }
            }
            .padding(.horizontal, Theme.Spacing.large)
            .padding(.bottom, 120)  // Above tab bar
        }
        .background(
            Color.black.opacity(0.1)
                .onTapGesture {
                    hideReactionPicker()
                }
        )
    }

    // MARK: - Helper Methods

    private func showReactionPicker() {
        withAnimation(.spring()) {
            showingReactionPicker = true
        }

        HapticManager.shared.impact(.light)

        // Auto-hide after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            hideReactionPicker()
        }
    }

    private func hideReactionPicker() {
        withAnimation(.spring()) {
            showingReactionPicker = false
        }
    }

    private func sendReaction(_ reactionType: ReactionType) {
        // Send to Gen Z service
        genZService.sendReaction(reactionType, to: targetId, context: context)

        // Create local floating reaction
        let displayReaction = InstantReactionDisplay(
            type: reactionType,
            position: CGPoint(
                x: Double.random(in: 50...300),
                y: Double.random(in: 200...500)
            ),
            timestamp: Date()
        )

        withAnimation(.spring()) {
            selectedReactions.append(displayReaction)
        }

        // Award authenticity for authentic reactions
        if reactionType.isAuthentic {
            triggerAuthenticityBoost()
        }

        hideReactionPicker()
        HapticManager.shared.impact(.medium)
    }

    private func removeReaction(_ reaction: InstantReactionDisplay) {
        withAnimation(.easeOut) {
            selectedReactions.removeAll { $0.id == reaction.id }
        }
    }

    private func triggerAuthenticityBoost() {
        // Create authenticity boost effect
        let boostReaction = InstantReactionDisplay(
            type: .understood,
            position: CGPoint(x: 200, y: 150),
            timestamp: Date(),
            isAuthenticityBoost: true
        )

        withAnimation(.spring()) {
            selectedReactions.append(boostReaction)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            removeReaction(boostReaction)
        }
    }
}

// MARK: - Floating Reaction View

struct FloatingReactionView: View {
    let reaction: InstantReactionDisplay
    @State private var animationOffset: CGSize = .zero
    @State private var animationOpacity: Double = 1.0
    @State private var animationScale: Double = 1.0

    var body: some View {
        ZStack {
            if reaction.isAuthenticityBoost {
                // Special authenticity boost animation
                authenticityBoostView
            } else {
                // Regular reaction
                regularReactionView
            }
        }
        .position(
            x: reaction.position.x + animationOffset.width,
            y: reaction.position.y + animationOffset.height
        )
        .opacity(animationOpacity)
        .scaleEffect(animationScale)
        .onAppear {
            startAnimation()
        }
    }

    private var regularReactionView: some View {
        Text(reaction.type.rawValue)
            .font(.system(size: 40))
            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
    }

    private var authenticityBoostView: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(Theme.Colors.neonGreen)
                    .font(.title3)

                Text("Authentic!")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.neonGreen)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Theme.Colors.neonGreen.opacity(0.2), in: Capsule())
            .overlay(
                Capsule()
                    .stroke(Theme.Colors.neonGreen, lineWidth: 1)
            )
            .liquidGlassGlow(color: Theme.Colors.neonGreen, radius: 8, intensity: 1.2)
        }
    }

    private func startAnimation() {
        if reaction.isAuthenticityBoost {
            // Authenticity boost animation: pulse and fade
            withAnimation(.easeIn(duration: 0.5)) {
                animationScale = 1.2
            }

            withAnimation(.easeOut(duration: 2.5).delay(0.5)) {
                animationOpacity = 0
                animationScale = 0.8
            }
        } else {
            // Regular reaction animation: float up and fade
            withAnimation(.easeOut(duration: 4)) {
                animationOffset = CGSize(
                    width: Double.random(in: -50...50),
                    height: -150
                )
                animationOpacity = 0
                animationScale = 0.7
            }
        }
    }
}

// MARK: - Compact Reaction Button

struct CompactReactionButton: View {
    let onTrigger: () -> Void
    @State private var isPulsing = false

    var body: some View {
        Button(action: onTrigger) {
            HStack(spacing: 6) {
                Image(systemName: "heart.fill")
                    .foregroundColor(Theme.Colors.neonPink)
                    .font(.caption)
                    .scaleEffect(isPulsing ? 1.2 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                        value: isPulsing)

                Text("React")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.neonPink)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Theme.Colors.neonPink.opacity(0.2), in: Capsule())
            .overlay(
                Capsule()
                    .stroke(Theme.Colors.neonPink.opacity(0.5), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            isPulsing = true
        }
    }
}

// MARK: - Reaction Trigger Areas

struct ReactionTriggerArea: View {
    let targetId: String
    let context: String
    let content: () -> AnyView

    init<Content: View>(
        targetId: String, context: String, @ViewBuilder content: @escaping () -> Content
    ) {
        self.targetId = targetId
        self.context = context
        self.content = { AnyView(content()) }
    }

    var body: some View {
        ZStack {
            content()

            InstantReactionsOverlay(targetId: targetId, context: context)
        }
    }
}

// MARK: - Reaction Stats Display

struct ReactionStatsView: View {
    let reactions: [UserReaction]

    var body: some View {
        if !reactions.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.small) {
                    ForEach(getReactionCounts(), id: \.type) { reactionCount in
                        HStack(spacing: 4) {
                            Text(reactionCount.type.rawValue)
                                .font(.caption2)

                            if reactionCount.count > 1 {
                                Text("\(reactionCount.count)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.Colors.textSecondary)
                            }
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Theme.Colors.glassPrimary, in: Capsule())
                    }
                }
            }
        }
    }

    private func getReactionCounts() -> [ReactionCount] {
        let grouped = Dictionary(grouping: reactions, by: { $0.type })
        return grouped.map { ReactionCount(type: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
    }
}

// MARK: - Supporting Types

struct InstantReactionDisplay: Identifiable {
    let id = UUID()
    let type: ReactionType
    let position: CGPoint
    let timestamp: Date
    let isAuthenticityBoost: Bool

    init(type: ReactionType, position: CGPoint, timestamp: Date, isAuthenticityBoost: Bool = false)
    {
        self.type = type
        self.position = position
        self.timestamp = timestamp
        self.isAuthenticityBoost = isAuthenticityBoost
    }
}

struct ReactionCount {
    let type: ReactionType
    let count: Int
}

// MARK: - Modifier Extensions

extension View {
    func withInstantReactions(targetId: String, context: String) -> some View {
        ReactionTriggerArea(targetId: targetId, context: context) {
            self
        }
    }

    func compactReactionButton(onTrigger: @escaping () -> Void) -> some View {
        HStack {
            self
            Spacer()
            CompactReactionButton(onTrigger: onTrigger)
        }
    }
}

#Preview {
    ZStack {
        Theme.LiquidGlass.background
            .ignoresSafeArea()

        VStack {
            Text("Sample Content")
                .font(.title)
                .padding()
                .liquidGlassCard()
                .withInstantReactions(targetId: "sample", context: "preview")

            Spacer()
        }
        .padding()
    }
}
