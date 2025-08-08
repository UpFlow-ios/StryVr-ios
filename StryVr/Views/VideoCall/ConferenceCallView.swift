//
//  ConferenceCallView.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  🎥 Revolutionary Video Call UI - Making All Platforms Look Antique
//  🌟 iOS 18 Liquid Glass + Apple Glow + Holographic Effects
//

import SwiftUI
import AVFoundation

struct ConferenceCallView: View {
    @StateObject private var callManager = ConferenceCallManager()
    @State private var isCallActive = false
    @State private var participants: [CallParticipant] = []
    @State private var showingSkillAuras = true
    @State private var aiInsightsVisible = false
    @State private var recordingActive = false
    @Namespace private var holographicNamespace
    
    var body: some View {
        ZStack {
            // MARK: - Revolutionary Background
            revolutionaryBackground
            
            VStack(spacing: 0) {
                // MARK: - Header with AI Insights
                callHeader
                
                // MARK: - Main Video Area with Holographic Effects
                mainVideoArea
                
                // MARK: - Participant Gallery with Skill Auras
                participantGallery
                
                // MARK: - Revolutionary Control Panel
                controlPanel
            }
        }
        .navigationBarHidden(true)
        .statusBarHidden()
        .onAppear {
            setupCall()
        }
    }
    
    // MARK: - Revolutionary Background
    private var revolutionaryBackground: some View {
        ZStack {
            // Dynamic gradient that responds to call energy
            Theme.LiquidGlass.background
                .ignoresSafeArea()
            
            // Floating particles that represent collaboration energy
            FloatingParticles(count: 20, color: Theme.Colors.glowPrimary)
                .opacity(isCallActive ? 1.0 : 0.3)
                .animation(.easeInOut(duration: 2), value: isCallActive)
        }
    }
    
    // MARK: - Call Header with AI Insights
    private var callHeader: some View {
        HStack {
            // Meeting title with glow
            VStack(alignment: .leading, spacing: 4) {
                Text("Team Strategy Session")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .liquidGlassGlow(color: Theme.Colors.glowPrimary)
                
                Text("5 participants • Recording")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            Spacer()
            
            // AI Insights Toggle
            Button(action: {
                withAnimation(.spring()) {
                    aiInsightsVisible.toggle()
                }
            }) {
                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundColor(aiInsightsVisible ? Theme.Colors.neonBlue : Theme.Colors.textSecondary)
                    .scaleEffect(aiInsightsVisible ? 1.2 : 1.0)
                    .animation(.spring(), value: aiInsightsVisible)
            }
            .liquidGlassButton()
            
            // Call timer with neon glow
            Text("23:45")
                .font(Theme.Typography.title2)
                .foregroundColor(Theme.Colors.neonGreen)
                .neonGlow(color: Theme.Colors.neonGreen, pulse: recordingActive)
                .monospacedDigit()
        }
        .padding(.horizontal, Theme.Spacing.large)
        .padding(.top, Theme.Spacing.medium)
    }
    
    // MARK: - Main Video Area with Holographic Effects
    private var mainVideoArea: some View {
        ZStack {
            // Main speaker view with holographic border
            RoundedRectangle(cornerRadius: 20)
                .fill(Theme.Colors.glassPrimary)
                .frame(height: 300)
                .overlay(
                    // Holographic border effect
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Theme.Colors.neonBlue,
                                    Theme.Colors.neonPink,
                                    Theme.Colors.neonBlue
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: isCallActive)
                )
                .liquidGlassCard()
            
            // Speaker skill aura (shows expertise in real-time)
            if showingSkillAuras {
                SkillAuraView(skills: ["Leadership", "Strategy", "Innovation"])
                    .matchedGeometryEffect(id: "speakerAura", in: holographicNamespace)
            }
            
            // Floating AI insights
            if aiInsightsVisible {
                FloatingAIInsights()
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
            }
        }
        .padding(.horizontal, Theme.Spacing.large)
        .padding(.top, Theme.Spacing.medium)
    }
    
    // MARK: - Participant Gallery with Skill Auras
    private var participantGallery: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: Theme.Spacing.medium) {
                ForEach(participants) { participant in
                    ParticipantCard(participant: participant, showSkillAura: showingSkillAuras)
                        .matchedGeometryEffect(id: "participant-\(participant.id)", in: holographicNamespace)
                }
            }
            .padding(.horizontal, Theme.Spacing.large)
        }
        .frame(height: 120)
        .padding(.top, Theme.Spacing.medium)
    }
    
    // MARK: - Revolutionary Control Panel
    private var controlPanel: some View {
        HStack(spacing: Theme.Spacing.large) {
            // Mute with haptic feedback
            ControlButton(
                icon: "mic.slash.fill",
                isActive: false,
                activeColor: Theme.Colors.neonGreen,
                action: { 
                    HapticManager.shared.impact(.medium)
                    // Toggle mute
                }
            )
            
            // Video toggle
            ControlButton(
                icon: "video.fill",
                isActive: true,
                activeColor: Theme.Colors.neonBlue,
                action: { 
                    HapticManager.shared.impact(.medium)
                    // Toggle video
                }
            )
            
            Spacer()
            
            // AI Co-pilot button
            Button(action: {
                withAnimation(.spring()) {
                    // Activate AI co-pilot
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "brain.head.profile")
                        .font(.title3)
                    Text("AI Co-pilot")
                        .font(Theme.Typography.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(Theme.Colors.textPrimary)
                .padding(.horizontal, Theme.Spacing.medium)
                .padding(.vertical, Theme.Spacing.small)
                .liquidGlassButton()
                .neonGlow(color: Theme.Colors.neonPink, pulse: true)
            }
            
            Spacer()
            
            // Screen share
            ControlButton(
                icon: "rectangle.on.rectangle",
                isActive: false,
                activeColor: Theme.Colors.neonOrange,
                action: { 
                    HapticManager.shared.impact(.medium)
                    // Toggle screen share
                }
            )
            
            // End call with confirmation
            ControlButton(
                icon: "phone.down.fill",
                isActive: false,
                activeColor: Color.red,
                action: { 
                    HapticManager.shared.impact(.heavy)
                    // End call with confirmation
                }
            )
        }
        .padding(.horizontal, Theme.Spacing.large)
        .padding(.bottom, Theme.Spacing.large)
    }
    
    // MARK: - Setup
    private func setupCall() {
        // Mock participants with skills for demo
        participants = [
            CallParticipant(id: "1", name: "Sarah Chen", skills: ["Product Strategy", "UX Design"], isActive: true),
            CallParticipant(id: "2", name: "Marcus Rodriguez", skills: ["Data Science", "AI/ML"], isActive: true),
            CallParticipant(id: "3", name: "Elena Popov", skills: ["Engineering", "Architecture"], isActive: false),
            CallParticipant(id: "4", name: "James Wilson", skills: ["Marketing", "Growth"], isActive: true)
        ]
        
        withAnimation(.spring(duration: 1)) {
            isCallActive = true
            recordingActive = true
        }
    }
}

// MARK: - Supporting Views

struct ParticipantCard: View {
    let participant: CallParticipant
    let showSkillAura: Bool
    
    var body: some View {
        ZStack {
            // Participant video frame
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.Colors.glassPrimary)
                .frame(width: 80, height: 80)
                .overlay(
                    // Active speaking indicator
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            participant.isActive ? Theme.Colors.neonGreen : Color.clear,
                            lineWidth: 2
                        )
                        .animation(.easeInOut(duration: 0.5), value: participant.isActive)
                )
                .liquidGlassCard()
            
            // Skill aura for participant
            if showSkillAura && participant.isActive {
                SkillAuraView(skills: participant.skills)
                    .frame(width: 80, height: 80)
            }
            
            // Name label
            VStack {
                Spacer()
                Text(participant.name.components(separatedBy: " ").first ?? "")
                    .font(Theme.Typography.caption2)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.horizontal, 4)
                    .background(Theme.Colors.glassPrimary, in: Capsule())
                    .offset(y: 10)
            }
        }
    }
}

struct SkillAuraView: View {
    let skills: [String]
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            ForEach(Array(skills.enumerated()), id: \.offset) { index, skill in
                Text(skill)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Theme.Colors.glassPrimary)
                            .neonGlow(color: getSkillColor(for: index), pulse: true)
                    )
                    .offset(
                        x: cos(Double(index) * 2 * .pi / Double(skills.count) + rotationAngle) * 50,
                        y: sin(Double(index) * 2 * .pi / Double(skills.count) + rotationAngle) * 50
                    )
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                rotationAngle = 2 * .pi
            }
        }
    }
    
    private func getSkillColor(for index: Int) -> Color {
        let colors = [Theme.Colors.neonBlue, Theme.Colors.neonGreen, Theme.Colors.neonOrange, Theme.Colors.neonPink]
        return colors[index % colors.count]
    }
}

struct FloatingAIInsights: View {
    @State private var insights = [
        "Sarah is demonstrating strong leadership",
        "Team engagement: 92%",
        "Decision velocity increasing",
        "Cross-functional collaboration detected"
    ]
    @State private var currentInsightIndex = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(Theme.Colors.neonPink)
                    .font(.caption)
                Text("AI Insights")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                Spacer()
            }
            
            Text(insights[currentInsightIndex])
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textPrimary)
                .transition(.asymmetric(insertion: .slide, removal: .opacity))
        }
        .padding(Theme.Spacing.small)
        .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 12))
        .liquidGlassGlow(color: Theme.Colors.glowPrimary, radius: 6)
        .frame(maxWidth: 200)
        .offset(x: 100, y: -100)
        .onAppear {
            startInsightRotation()
        }
    }
    
    private func startInsightRotation() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation(.easeInOut) {
                currentInsightIndex = (currentInsightIndex + 1) % insights.count
            }
        }
    }
}

struct ControlButton: View {
    let icon: String
    let isActive: Bool
    let activeColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isActive ? activeColor : Theme.Colors.textSecondary)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(Theme.Colors.glassPrimary)
                        .liquidGlassGlow(
                            color: isActive ? activeColor : Theme.Colors.glowPrimary,
                            radius: isActive ? 10 : 6
                        )
                )
        }
        .scaleEffect(isActive ? 1.1 : 1.0)
        .animation(.spring(), value: isActive)
    }
}

struct FloatingParticles: View {
    let count: Int
    let color: Color
    @State private var particles: [ParticleState] = []
    
    var body: some View {
        ZStack {
            ForEach(particles.indices, id: \.self) { index in
                Circle()
                    .fill(color.opacity(0.3))
                    .frame(width: particles[index].size, height: particles[index].size)
                    .position(particles[index].position)
                    .animation(
                        Animation.linear(duration: particles[index].duration)
                            .repeatForever(autoreverses: false),
                        value: particles[index].position
                    )
            }
        }
        .onAppear {
            setupParticles()
        }
    }
    
    private func setupParticles() {
        particles = (0..<count).map { _ in
            ParticleState(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 2...6),
                duration: Double.random(in: 3...8)
            )
        }
        
        animateParticles()
    }
    
    private func animateParticles() {
        for index in particles.indices {
            withAnimation(
                Animation.linear(duration: particles[index].duration)
                    .repeatForever(autoreverses: false)
            ) {
                particles[index].position = CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                )
            }
        }
    }
}

struct ParticleState {
    var position: CGPoint
    let size: CGFloat
    let duration: Double
}

// MARK: - Supporting Models

struct CallParticipant: Identifiable {
    let id: String
    let name: String
    let skills: [String]
    let isActive: Bool
}

class ConferenceCallManager: ObservableObject {
    @Published var isCallActive = false
    @Published var participants: [CallParticipant] = []
    @Published var recordingActive = false
    
    func startCall() {
        isCallActive = true
    }
    
    func endCall() {
        isCallActive = false
    }
}

// MARK: - Haptic Manager

class HapticManager {
    static let shared = HapticManager()
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.impactOccurred()
    }
}

#Preview {
    ConferenceCallView()
}
