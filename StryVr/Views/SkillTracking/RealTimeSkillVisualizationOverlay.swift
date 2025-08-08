//
//  RealTimeSkillVisualizationOverlay.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  🎯 Revolutionary Real-Time Skill Visualization - Live AI Analysis Display
//  ✨ Floating Skill Auras, Particle Systems & Dynamic Expertise Visualization
//

import SwiftUI

struct RealTimeSkillVisualizationOverlay: View {
    @StateObject private var skillTrackingService = RealTimeSkillTrackingService.shared
    @State private var showingSkillDetails = false
    @State private var selectedSkillMoment: SkillMoment?
    @Namespace private var skillNamespace
    
    let callId: String
    
    var body: some View {
        ZStack {
            // Skill particles floating animation
            skillParticleLayer
            
            // Live skill auras around speakers
            skillAurasLayer
            
            // Confidence aura visualization
            confidenceAuraLayer
            
            // Expertise heatmap overlay
            expertiseHeatmapLayer
            
            // Real-time skill notifications
            skillNotificationsLayer
            
            // Compact skill tracking dashboard
            compactSkillDashboard
        }
        .onAppear {
            skillTrackingService.startSkillTracking(for: callId, participants: getMockParticipants())
        }
        .onDisappear {
            skillTrackingService.endSkillTracking(callId)
        }
        .sheet(isPresented: $showingSkillDetails) {
            if let moment = selectedSkillMoment {
                SkillMomentDetailView(moment: moment)
            }
        }
    }
    
    // MARK: - Skill Particles Layer
    private var skillParticleLayer: some View {
        ZStack {
            ForEach(skillTrackingService.skillParticles) { particle in
                SkillParticleView(particle: particle)
                    .position(particle.position)
                    .opacity(particle.life / 3.0) // Fade out as life decreases
                    .scaleEffect(particle.size / 10.0)
                    .animation(.easeOut(duration: 0.1), value: particle.position)
            }
        }
        .allowsHitTesting(false)
    }
    
    // MARK: - Skill Auras Layer
    private var skillAurasLayer: some View {
        ZStack {
            ForEach(skillTrackingService.liveSkillAuras) { aura in
                SkillAuraView(aura: aura)
                    .position(aura.position)
                    .scaleEffect(1.0 + (aura.intensity * 0.5))
                    .opacity(0.8)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: aura.animationPhase)
                    .onTapGesture {
                        if let moment = findSkillMoment(for: aura.skill) {
                            selectedSkillMoment = moment
                            showingSkillDetails = true
                        }
                    }
            }
        }
    }
    
    // MARK: - Confidence Aura Layer
    private var confidenceAuraLayer: some View {
        VStack {
            Spacer()
            
            HStack {
                // Confidence visualization for current speaker
                if skillTrackingService.currentSpeaker != nil {
                    ConfidenceAuraView(aura: skillTrackingService.confidenceAura)
                        .frame(width: 100, height: 100)
                        .padding(.leading, Theme.Spacing.large)
                }
                
                Spacer()
            }
            .padding(.bottom, 200) // Above video controls
        }
    }
    
    // MARK: - Expertise Heatmap Layer
    private var expertiseHeatmapLayer: some View {
        VStack {
            HStack {
                Spacer()
                
                ExpertiseHeatmapView(heatmap: skillTrackingService.expertiseHeatmap)
                    .frame(width: 120, height: 200)
                    .padding(.trailing, Theme.Spacing.large)
            }
            .padding(.top, 100) // Below status bar
            
            Spacer()
        }
    }
    
    // MARK: - Skill Notifications Layer
    private var skillNotificationsLayer: some View {
        VStack {
            ForEach(skillTrackingService.detectedSkillMoments.suffix(3)) { moment in
                SkillMomentNotification(moment: moment)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .onTapGesture {
                        selectedSkillMoment = moment
                        showingSkillDetails = true
                    }
            }
            
            Spacer()
        }
        .padding(.top, 60)
        .padding(.trailing, Theme.Spacing.large)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    // MARK: - Compact Skill Dashboard
    private var compactSkillDashboard: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                CompactSkillDashboard(
                    metrics: skillTrackingService.realTimeMetrics,
                    activeBehaviors: skillTrackingService.activeBehaviors,
                    onDetailsTap: {
                        // Show full skill tracking dashboard
                    }
                )
                .padding(.trailing, Theme.Spacing.large)
                .padding(.bottom, 160) // Above video controls
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func findSkillMoment(for skill: SkillType) -> SkillMoment? {
        return skillTrackingService.detectedSkillMoments
            .filter { $0.skill == skill }
            .sorted { $0.timestamp > $1.timestamp }
            .first
    }
    
    private func getMockParticipants() -> [CallParticipant] {
        return [
            CallParticipant(name: "You", role: .presenter, userId: "current_user"),
            CallParticipant(name: "Sarah Chen", role: .participant, userId: "sarah_123"),
            CallParticipant(name: "Marcus Rodriguez", role: .facilitator, userId: "marcus_456")
        ]
    }
}

// MARK: - Skill Particle View

struct SkillParticleView: View {
    let particle: SkillParticle
    
    var body: some View {
        Image(systemName: particle.skill.icon)
            .font(.system(size: particle.size))
            .foregroundColor(Theme.Colors.fromString(particle.skill.color))
            .shadow(color: Theme.Colors.fromString(particle.skill.color).opacity(0.5), radius: 4, x: 0, y: 0)
    }
}

// MARK: - Skill Aura View

struct SkillAuraView: View {
    let aura: LiveSkillAura
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            Theme.Colors.fromString(aura.skill.color).opacity(0.8),
                            Theme.Colors.fromString(aura.skill.color).opacity(0.2)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 4
                )
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(rotation))
                .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: rotation)
            
            // Inner skill icon
            ZStack {
                Circle()
                    .fill(Theme.Colors.fromString(aura.skill.color).opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Image(systemName: aura.skill.icon)
                    .font(.title2)
                    .foregroundColor(Theme.Colors.fromString(aura.skill.color))
                    .scaleEffect(1.0 + (aura.confidence * 0.3))
            }
            
            // Confidence indicator
            VStack {
                Spacer()
                
                Text("\(Int(aura.confidence * 100))%")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.fromString(aura.skill.color))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Theme.Colors.fromString(aura.skill.color).opacity(0.2), in: Capsule())
            }
            .frame(width: 80, height: 80)
        }
        .onAppear {
            rotation = 360
        }
    }
}

// MARK: - Confidence Aura View

struct ConfidenceAuraView: View {
    let aura: ConfidenceAura
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Pulsing confidence ring
            Circle()
                .stroke(
                    RadialGradient(
                        colors: [
                            Theme.Colors.neonYellow.opacity(aura.level),
                            Theme.Colors.neonYellow.opacity(aura.level * 0.3)
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 50
                    ),
                    lineWidth: 6
                )
                .scaleEffect(pulseScale)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulseScale)
            
            // Confidence level indicator
            VStack(spacing: 4) {
                Image(systemName: "bolt.fill")
                    .font(.title3)
                    .foregroundColor(Theme.Colors.neonYellow)
                
                Text("\(Int(aura.level * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.neonYellow)
            }
        }
        .onAppear {
            pulseScale = aura.pulsing ? 1.2 : 1.0
        }
        .onChange(of: aura.pulsing) { newValue in
            pulseScale = newValue ? 1.2 : 1.0
        }
    }
}

// MARK: - Expertise Heatmap View

struct ExpertiseHeatmapView: View {
    let heatmap: ExpertiseHeatmap
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(Theme.Colors.neonBlue)
                    .font(.caption)
                
                Text("Expertise")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            
            VStack(spacing: 6) {
                ForEach(Array(heatmap.participantScores.keys), id: \.self) { participantId in
                    if let score = heatmap.participantScores[participantId] {
                        ExpertiseBarView(
                            participantName: getParticipantName(participantId),
                            score: score
                        )
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.Colors.neonBlue.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func getParticipantName(_ id: String) -> String {
        switch id {
        case "current_user": return "You"
        case "sarah_123": return "Sarah"
        case "marcus_456": return "Marcus"
        default: return "Unknown"
        }
    }
}

struct ExpertiseBarView: View {
    let participantName: String
    let score: Double
    
    var body: some View {
        HStack(spacing: 6) {
            Text(participantName)
                .font(.caption2)
                .foregroundColor(Theme.Colors.textSecondary)
                .frame(width: 40, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Theme.Colors.glassPrimary)
                        .frame(height: 4)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            LinearGradient(
                                colors: [Theme.Colors.neonBlue, Theme.Colors.neonGreen],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * score, height: 4)
                        .animation(.spring(), value: score)
                }
            }
            .frame(height: 4)
        }
    }
}

// MARK: - Skill Moment Notification

struct SkillMomentNotification: View {
    let moment: SkillMoment
    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: moment.skill.icon)
                .foregroundColor(Theme.Colors.fromString(moment.skill.color))
                .font(.caption)
                .neonGlow(color: Theme.Colors.fromString(moment.skill.color), pulse: true)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(moment.skill.displayName)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text("\(Int(moment.confidence * 100))% confidence")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.fromString(moment.skill.color))
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(
            Capsule()
                .stroke(Theme.Colors.fromString(moment.skill.color).opacity(0.5), lineWidth: 1)
        )
        .scaleEffect(isVisible ? 1.0 : 0.8)
        .opacity(isVisible ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring()) {
                isVisible = true
            }
            
            // Auto-hide after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation(.spring()) {
                    isVisible = false
                }
            }
        }
    }
}

// MARK: - Compact Skill Dashboard

struct CompactSkillDashboard: View {
    let metrics: RealTimeMetrics
    let activeBehaviors: [BehaviorPattern]
    let onDetailsTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            // Skill moments counter
            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .foregroundColor(Theme.Colors.neonYellow)
                    .font(.caption2)
                
                Text("\(metrics.totalSkillMoments)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text("skills")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            // Engagement level
            VStack(spacing: 4) {
                Text("Engagement")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
                
                CircularProgressView(
                    value: metrics.engagementLevel,
                    color: Theme.Colors.neonGreen,
                    size: 30
                )
            }
            
            // Details button
            Button(action: onDetailsTap) {
                Image(systemName: "chevron.up")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.neonBlue)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.Colors.neonBlue.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Circular Progress View

struct CircularProgressView: View {
    let value: Double
    let color: Color
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.3), lineWidth: 3)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: value)
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.spring(), value: value)
            
            Text("\(Int(value * 100))")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
    }
}

// MARK: - Skill Moment Detail View

struct SkillMomentDetailView: View {
    let moment: SkillMoment
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                // Skill header
                HStack {
                    Image(systemName: moment.skill.icon)
                        .foregroundColor(Theme.Colors.fromString(moment.skill.color))
                        .font(.title)
                        .neonGlow(color: Theme.Colors.fromString(moment.skill.color), pulse: true)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(moment.skill.displayName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        Text("Demonstrated with \(Int(moment.confidence * 100))% confidence")
                            .font(.subheadline)
                            .foregroundColor(Theme.Colors.fromString(moment.skill.color))
                    }
                    
                    Spacer()
                }
                
                // Context and evidence
                VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                    Text("Context")
                        .font(.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text(moment.context)
                        .font(.body)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .padding()
                        .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 12))
                    
                    Text("Evidence")
                        .font(.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text(moment.evidence)
                        .font(.body)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .padding()
                        .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 12))
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Skill Moment")
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
    ZStack {
        Color.black
            .ignoresSafeArea()
        
        RealTimeSkillVisualizationOverlay(callId: "preview-call")
    }
}
