//
//  RealTimeCoachingOverlay.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  🎯 Revolutionary Real-Time AI Coaching Overlay
//  💡 Live Performance Prompts During Video Calls
//

import SwiftUI

struct RealTimeCoachingOverlay: View {
    @StateObject private var coachingService = AICoachingService.shared
    @State private var currentPromptIndex = 0
    @State private var showingPromptDetail = false
    @State private var promptsExpanded = false
    @State private var confidenceBoostActive = false
    @Namespace private var overlayNamespace

    let callId: String

    var body: some View {
        ZStack {
            // Main coaching prompts overlay
            if !coachingService.currentCoachingPrompts.isEmpty && promptsExpanded {
                expandedPromptsView
            } else if !coachingService.currentCoachingPrompts.isEmpty {
                compactPromptsView
            }

            // Confidence boost animation
            if confidenceBoostActive {
                confidenceBoostOverlay
            }
        }
        .animation(.spring(), value: promptsExpanded)
        .animation(.spring(), value: confidenceBoostActive)
        .onReceive(coachingService.$currentCoachingPrompts) { prompts in
            if !prompts.isEmpty && prompts.contains(where: { $0.type == .confidence }) {
                triggerConfidenceBoost()
            }
        }
    }

    // MARK: - Compact Prompts View
    private var compactPromptsView: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                VStack(spacing: Theme.Spacing.small) {
                    // Current prompt indicator
                    if let currentPrompt = getCurrentPrompt() {
                        Button(action: {
                            withAnimation(.spring()) {
                                promptsExpanded = true
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: currentPrompt.type.icon)
                                    .foregroundColor(getPromptColor(currentPrompt.type))
                                    .font(.caption)
                                    .neonGlow(
                                        color: getPromptColor(currentPrompt.type), pulse: true)

                                Text(currentPrompt.title)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                    .lineLimit(1)

                                Image(systemName: "chevron.up")
                                    .font(.caption2)
                                    .foregroundColor(Theme.Colors.textSecondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                .ultraThinMaterial,
                                in: Capsule()
                            )
                            .overlay(
                                Capsule()
                                    .stroke(
                                        getPromptColor(currentPrompt.type).opacity(0.5),
                                        lineWidth: 1)
                            )
                            .liquidGlassGlow(color: getPromptColor(currentPrompt.type), radius: 8)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .matchedGeometryEffect(id: "prompt-indicator", in: overlayNamespace)
                    }

                    // Prompt counter
                    if coachingService.currentCoachingPrompts.count > 1 {
                        Text(
                            "\(currentPromptIndex + 1) of \(coachingService.currentCoachingPrompts.count)"
                        )
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textTertiary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial, in: Capsule())
                    }
                }
            }
            .padding(.trailing, Theme.Spacing.large)
            .padding(.bottom, 100)  // Above video controls
        }
    }

    // MARK: - Expanded Prompts View
    private var expandedPromptsView: some View {
        VStack {
            Spacer()

            VStack(spacing: Theme.Spacing.medium) {
                // Header with close button
                HStack {
                    Text("AI Coaching")
                        .font(Theme.Typography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Spacer()

                    Button(action: {
                        withAnimation(.spring()) {
                            promptsExpanded = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }

                // Current prompt card
                if let currentPrompt = getCurrentPrompt() {
                    ExpandedPromptCard(prompt: currentPrompt, callId: callId)
                        .matchedGeometryEffect(id: "prompt-card", in: overlayNamespace)
                }

                // Navigation controls
                if coachingService.currentCoachingPrompts.count > 1 {
                    promptNavigationControls
                }

                // Quick action buttons
                quickActionButtons
            }
            .padding()
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 20)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        getCurrentPrompt()?.type.color.opacity(0.5) ?? Color.clear, lineWidth: 1)
            )
            .liquidGlassGlow(
                color: getCurrentPrompt()?.type.color ?? Theme.Colors.neonBlue, radius: 12
            )
            .padding(.horizontal, Theme.Spacing.large)
            .padding(.bottom, 120)  // Above video controls
        }
    }

    private var promptNavigationControls: some View {
        HStack(spacing: Theme.Spacing.large) {
            Button(action: previousPrompt) {
                Image(systemName: "chevron.left")
                    .font(.caption)
                    .foregroundColor(
                        currentPromptIndex > 0
                            ? Theme.Colors.textPrimary : Theme.Colors.textTertiary)
            }
            .disabled(currentPromptIndex <= 0)

            // Prompt indicators
            HStack(spacing: 6) {
                ForEach(0..<coachingService.currentCoachingPrompts.count, id: \.self) { index in
                    Circle()
                        .fill(
                            index == currentPromptIndex
                                ? Theme.Colors.neonBlue : Theme.Colors.textTertiary.opacity(0.3)
                        )
                        .frame(width: 6, height: 6)
                        .scaleEffect(index == currentPromptIndex ? 1.2 : 1.0)
                        .animation(.spring(), value: currentPromptIndex)
                }
            }

            Button(action: nextPrompt) {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(
                        currentPromptIndex < coachingService.currentCoachingPrompts.count - 1
                            ? Theme.Colors.textPrimary : Theme.Colors.textTertiary)
            }
            .disabled(currentPromptIndex >= coachingService.currentCoachingPrompts.count - 1)
        }
        .padding(.horizontal, Theme.Spacing.medium)
        .padding(.vertical, Theme.Spacing.small)
        .background(.ultraThinMaterial, in: Capsule())
    }

    private var quickActionButtons: some View {
        HStack(spacing: Theme.Spacing.medium) {
            QuickActionButton(
                title: "Got it",
                icon: "checkmark",
                color: Theme.Colors.neonGreen,
                action: markPromptCompleted
            )

            QuickActionButton(
                title: "Skip",
                icon: "forward",
                color: Theme.Colors.textSecondary,
                action: skipPrompt
            )

            QuickActionButton(
                title: "More",
                icon: "ellipsis",
                color: Theme.Colors.neonBlue,
                action: showMoreOptions
            )
        }
    }

    // MARK: - Confidence Boost Overlay
    private var confidenceBoostOverlay: some View {
        ZStack {
            // Animated background
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Theme.Colors.neonYellow.opacity(0.3),
                            Theme.Colors.neonYellow.opacity(0.1),
                            Color.clear,
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 200
                    )
                )
                .scaleEffect(confidenceBoostActive ? 1.5 : 0.5)
                .opacity(confidenceBoostActive ? 1 : 0)
                .animation(.easeInOut(duration: 2), value: confidenceBoostActive)

            VStack(spacing: Theme.Spacing.medium) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Theme.Colors.neonYellow)
                    .neonGlow(color: Theme.Colors.neonYellow, pulse: true)
                    .scaleEffect(confidenceBoostActive ? 1.2 : 0.8)
                    .animation(.spring(), value: confidenceBoostActive)

                Text("You've got this!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .opacity(confidenceBoostActive ? 1 : 0)
                    .animation(.easeInOut(duration: 1).delay(0.5), value: confidenceBoostActive)

                Text("Speak with confidence")
                    .font(.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .opacity(confidenceBoostActive ? 1 : 0)
                    .animation(.easeInOut(duration: 1).delay(0.7), value: confidenceBoostActive)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
        .onTapGesture {
            dismissConfidenceBoost()
        }
    }

    // MARK: - Helper Methods

    private func getCurrentPrompt() -> CoachingPrompt? {
        guard currentPromptIndex < coachingService.currentCoachingPrompts.count else { return nil }
        return coachingService.currentCoachingPrompts[currentPromptIndex]
    }

    private func getPromptColor(_ type: CoachingPrompt.PromptType) -> Color {
        switch type {
        case .preparation: return Theme.Colors.neonBlue
        case .realTime: return Theme.Colors.neonGreen
        case .encouragement: return Theme.Colors.neonYellow
        case .guidance: return Theme.Colors.neonOrange
        case .positive: return Theme.Colors.neonPink
        case .confidence: return Theme.Colors.neonYellow
        }
    }

    private func previousPrompt() {
        if currentPromptIndex > 0 {
            currentPromptIndex -= 1
            HapticManager.shared.impact(.light)
        }
    }

    private func nextPrompt() {
        if currentPromptIndex < coachingService.currentCoachingPrompts.count - 1 {
            currentPromptIndex += 1
            HapticManager.shared.impact(.light)
        }
    }

    private func markPromptCompleted() {
        HapticManager.shared.impact(.medium)

        // Mark prompt as completed
        if let currentPrompt = getCurrentPrompt() {
            // Track completion in coaching service
        }

        // Move to next prompt or collapse if this was the last one
        if currentPromptIndex < coachingService.currentCoachingPrompts.count - 1 {
            nextPrompt()
        } else {
            withAnimation(.spring()) {
                promptsExpanded = false
            }
        }
    }

    private func skipPrompt() {
        HapticManager.shared.impact(.light)
        nextPrompt()
    }

    private func showMoreOptions() {
        HapticManager.shared.impact(.light)
        // Show additional coaching options
    }

    private func triggerConfidenceBoost() {
        withAnimation(.spring()) {
            confidenceBoostActive = true
        }

        // Auto-dismiss after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            dismissConfidenceBoost()
        }
    }

    private func dismissConfidenceBoost() {
        withAnimation(.spring()) {
            confidenceBoostActive = false
        }
    }
}

// MARK: - Expanded Prompt Card

struct ExpandedPromptCard: View {
    let prompt: CoachingPrompt
    let callId: String

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            // Header with icon and type
            HStack {
                Image(systemName: prompt.type.icon)
                    .foregroundColor(prompt.type.color)
                    .font(.title3)
                    .neonGlow(color: prompt.type.color, pulse: true)

                VStack(alignment: .leading, spacing: 2) {
                    Text(prompt.title)
                        .font(Theme.Typography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text(prompt.type.displayName)
                        .font(.caption2)
                        .foregroundColor(prompt.type.color)
                        .fontWeight(.medium)
                }

                Spacer()

                // Priority indicator
                if prompt.priority == .high || prompt.priority == .urgent {
                    Circle()
                        .fill(prompt.priority == .urgent ? Color.red : Theme.Colors.neonOrange)
                        .frame(width: 8, height: 8)
                        .neonGlow(
                            color: prompt.priority == .urgent ? Color.red : Theme.Colors.neonOrange,
                            pulse: true)
                }
            }

            // Prompt message
            Text(prompt.message)
                .font(.caption)
                .foregroundColor(Theme.Colors.textPrimary)
                .lineLimit(3)

            // Action items
            if !prompt.actionItems.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Suggested Actions:")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.textSecondary)

                    ForEach(prompt.actionItems.prefix(3), id: \.self) { actionItem in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(prompt.type.color)
                                .frame(width: 4, height: 4)

                            Text(actionItem)
                                .font(.caption2)
                                .foregroundColor(Theme.Colors.textSecondary)
                                .lineLimit(1)
                        }
                    }
                }
                .padding()
                .background(prompt.type.color.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption2)

                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .foregroundColor(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.2), in: Capsule())
            .overlay(
                Capsule()
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Extensions

extension CoachingPrompt.PromptType {
    var color: Color {
        switch self {
        case .preparation: return Theme.Colors.neonBlue
        case .realTime: return Theme.Colors.neonGreen
        case .encouragement: return Theme.Colors.neonYellow
        case .guidance: return Theme.Colors.neonOrange
        case .positive: return Theme.Colors.neonPink
        case .confidence: return Theme.Colors.neonYellow
        }
    }

    var displayName: String {
        switch self {
        case .preparation: return "Preparation"
        case .realTime: return "Real-time"
        case .encouragement: return "Encouragement"
        case .guidance: return "Guidance"
        case .positive: return "Positive"
        case .confidence: return "Confidence"
        }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()

        RealTimeCoachingOverlay(callId: "preview-call")
    }
}
