//
//  LiquidGlassExamples.swift
//  StryVr
//
//  Created by Joe Dormond on 3/7/25.
//  🌟 iOS 18 Liquid Glass Implementation Examples
//  📱 Demonstrates new Liquid Glass features with backward compatibility
//

import SwiftUI

/// Examples of iOS 18 Liquid Glass implementation in StryVr
struct LiquidGlassExamples: View {
    @State private var showInteractiveElements = true
    @State private var selectedTab = 0
    @Namespace private var glassNamespace
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with iOS 18 Glass Effect
                headerSection
                
                // Interactive Glass Elements
                interactiveElementsSection
                
                // Glass Effect Container Examples
                glassContainerSection
                
                // Advanced Glass Effects
                advancedEffectsSection
                
                // Navigation Glass Example
                navigationGlassSection
            }
            .padding()
        }
        .background(Theme.LiquidGlass.background)
    }
    
    // MARK: - Header Section with iOS 18 Glass Effect
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("StryVr Liquid Glass")
                .font(Theme.Typography.largeTitle)
                .foregroundColor(Theme.Colors.textPrimary)
                .liquidGlassCard()
                .padding(.horizontal)
            
            Text("iOS 18 Professional Development Platform")
                .font(Theme.Typography.subheadline)
                .foregroundColor(Theme.Colors.textSecondary)
                .liquidGlassCard()
                .padding(.horizontal)
        }
    }
    
    // MARK: - Interactive Glass Elements
    
    private var interactiveElementsSection: some View {
        VStack(spacing: 16) {
            Text("Interactive Elements")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            HStack(spacing: 16) {
                // iOS 18 Interactive Glass Button
                Button("Career Insights") {
                    // Action
                }
                .font(Theme.Typography.buttonText)
                .foregroundColor(Theme.Colors.textPrimary)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .liquidGlassButton()
                
                // iOS 18 Glass Effect with custom shape
                if #available(iOS 18.0, *) {
                    Button("Skills") {
                        // Action
                    }
                    .font(Theme.Typography.buttonText)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 25))
                } else {
                    Button("Skills") {
                        // Action
                    }
                    .font(Theme.Typography.buttonText)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .liquidGlassButton()
                }
            }
            
            // Toggle with Glass Effect
            Toggle("Show Interactive Elements", isOn: $showInteractiveElements)
                .toggleStyle(SwitchToggleStyle(tint: Theme.Colors.neonBlue))
                .liquidGlassCard()
                .padding(.horizontal)
        }
    }
    
    // MARK: - Glass Effect Container Examples
    
    private var glassContainerSection: some View {
        VStack(spacing: 16) {
            Text("Glass Effect Containers")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            // iOS 18 Glass Effect Container
            glassContainer(spacing: 16) {
                HStack(spacing: 12) {
                    ForEach(0..<3) { index in
                        VStack {
                            Image(systemName: ["chart.bar.fill", "person.fill", "star.fill"][index])
                                .font(.system(size: 24))
                                .foregroundColor(Theme.Colors.neonBlue)
                            
                            Text(["Analytics", "Profile", "Achievements"][index])
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .liquidGlassCard()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Advanced Glass Effects
    
    private var advancedEffectsSection: some View {
        VStack(spacing: 16) {
            Text("Advanced Effects")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            // Glass Effect with custom tint
            if #available(iOS 18.0, *) {
                VStack(spacing: 12) {
                    Text("Performance Dashboard")
                        .font(Theme.Typography.subheadline)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<4) { index in
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 60)
                                .glassEffect(.regular.tint(Theme.Colors.neonGreen.opacity(0.3)), in: RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    Text("\(75 + index * 5)%")
                                        .font(Theme.Typography.caption)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                )
                        }
                    }
                }
                .padding()
                .liquidGlassCard()
                .padding(.horizontal)
            }
            
            // Glass Effect with animation grouping
            if #available(iOS 18.0, *) {
                HStack(spacing: 16) {
                    ForEach(0..<3) { index in
                        Circle()
                            .frame(width: 60, height: 60)
                            .glassEffect(.regular.tint(Theme.Colors.neonPink.opacity(0.3)), in: Circle())
                            .glassEffectID(index, in: glassNamespace)
                            .overlay(
                                Image(systemName: ["heart.fill", "star.fill", "bolt.fill"][index])
                                    .foregroundColor(Theme.Colors.textPrimary)
                            )
                            .scaleEffect(showInteractiveElements ? 1.0 : 0.8)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showInteractiveElements)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Navigation Glass Example
    
    private var navigationGlassSection: some View {
        VStack(spacing: 16) {
            Text("Navigation Glass")
                .font(Theme.Typography.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            // Custom tab bar with Glass Effect
            HStack(spacing: 0) {
                ForEach(0..<4) { index in
                    Button(action: {
                        selectedTab = index
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: ["house.fill", "chart.bar.fill", "person.fill", "gear"][index])
                                .font(.system(size: 20))
                                .foregroundColor(selectedTab == index ? Theme.Colors.neonBlue : Theme.Colors.textSecondary)
                            
                            Text(["Home", "Analytics", "Profile", "Settings"][index])
                                .font(Theme.Typography.caption)
                                .foregroundColor(selectedTab == index ? Theme.Colors.neonBlue : Theme.Colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                }
            }
            .navigationGlass()
            .padding(.horizontal)
        }
    }
    
    // MARK: - Helper Methods
    
    @ViewBuilder
    private func glassContainer<Content: View>(spacing: CGFloat = 20.0, @ViewBuilder content: () -> Content) -> some View {
        if #available(iOS 18.0, *) {
            GlassEffectContainer(spacing: spacing) {
                content()
            }
        } else {
            VStack(spacing: spacing) {
                content()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    LiquidGlassExamples()
        .preferredColorScheme(.dark)
}

// MARK: - Usage Examples for StryVr Features

/// Example of how to use iOS 18 Liquid Glass in StryVr's main features
struct StryVrLiquidGlassUsage {
    
    /// Example: Career Path Insights Card
    static func careerPathCard() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(Theme.Colors.neonGreen)
                
                Text("Career Growth")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                if #available(iOS 18.0, *) {
                    Text("+15%")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.neonGreen)
                        .glassEffect(.regular.tint(Theme.Colors.neonGreen.opacity(0.2)), in: Capsule())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                } else {
                    Text("+15%")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.neonGreen)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.Colors.neonGreen.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            
            Text("Your communication skills have improved significantly this month.")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding()
        .liquidGlassCard()
    }
    
    /// Example: Skill Assessment Button
    static func skillAssessmentButton() -> some View {
        Button("Start Assessment") {
            // Launch skill assessment
        }
        .font(Theme.Typography.buttonText)
        .foregroundColor(Theme.Colors.textPrimary)
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .liquidGlassButton()
        .neonGlow(color: Theme.Colors.neonBlue, pulse: true)
    }
    
    /// Example: Achievement Badge with Glass Effect
    static func achievementBadge() -> some View {
        VStack(spacing: 8) {
            if #available(iOS 18.0, *) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 32))
                    .foregroundColor(Theme.Colors.neonYellow)
                    .glassEffect(.regular.tint(Theme.Colors.neonYellow.opacity(0.3)), in: Circle())
                    .frame(width: 80, height: 80)
            } else {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 32))
                    .foregroundColor(Theme.Colors.neonYellow)
                    .frame(width: 80, height: 80)
                    .background(Theme.Colors.neonYellow.opacity(0.3))
                    .clipShape(Circle())
            }
            
            Text("Top Performer")
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .liquidGlassCard()
    }
} 
