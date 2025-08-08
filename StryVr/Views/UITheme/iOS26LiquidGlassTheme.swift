//
//  iOS26LiquidGlassTheme.swift
//  StryVr
//
//  Created by Joe Dormond on 1/14/25.
//  🌟 iOS 26 Liquid Glass UI Theme - Next Generation Visual Design
//  ✨ Features: Quantum Glass, Neural Glow, Holographic Depth, AI-Responsive Colors
//

import SwiftUI

/// iOS 26 Liquid Glass Theme - The most advanced UI system
struct IOS26LiquidGlass {
    
    // MARK: - Quantum Glass Colors (iOS 26)
    struct QuantumColors {
        // Primary Glass Materials
        static let quantumGlass = Color.white.opacity(0.03)
        static let neuralGlass = Color.white.opacity(0.07)
        static let holoGlass = Color.white.opacity(0.12)
        static let liquidCrystal = Color.white.opacity(0.18)
        
        // AI-Responsive Color System
        static let aiBlue = Color(hex: "#007AFF").opacity(0.8)
        static let neuralPurple = Color(hex: "#5856D6").opacity(0.8)
        static let quantumTeal = Color(hex: "#30D158").opacity(0.8)
        static let holoOrange = Color(hex: "#FF9500").opacity(0.8)
        static let liquidPink = Color(hex: "#FF2D92").opacity(0.8)
        
        // Depth Layers (6-dimensional depth)
        static let depthLayer1 = Color.black.opacity(0.02)
        static let depthLayer2 = Color.black.opacity(0.04)
        static let depthLayer3 = Color.black.opacity(0.06)
        static let depthLayer4 = Color.black.opacity(0.08)
        static let depthLayer5 = Color.black.opacity(0.10)
        static let depthLayer6 = Color.black.opacity(0.12)
        
        // Neural Glow System
        static let neuralGlowPrimary = Color.blue.opacity(0.6)
        static let neuralGlowSecondary = Color.purple.opacity(0.6)
        static let neuralGlowAccent = Color.cyan.opacity(0.6)
        static let neuralGlowWarning = Color.orange.opacity(0.6)
        static let neuralGlowSuccess = Color.green.opacity(0.6)
        static let neuralGlowError = Color.red.opacity(0.6)
        
        // Holographic Surfaces
        static let holoSurface1 = Color.white.opacity(0.05)
        static let holoSurface2 = Color.white.opacity(0.08)
        static let holoSurface3 = Color.white.opacity(0.12)
        
        // Quantum Gradients
        static let quantumGradient = LinearGradient(
            colors: [
                Color(hex: "#1A1A1A"),
                Color(hex: "#2D2D30"),
                Color(hex: "#1A1A1A")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let neuralGradient = LinearGradient(
            colors: [
                aiBlue,
                neuralPurple,
                quantumTeal
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let holoGradient = RadialGradient(
            colors: [
                Color.white.opacity(0.15),
                Color.white.opacity(0.05),
                Color.clear
            ],
            center: .center,
            startRadius: 10,
            endRadius: 100
        )
    }
    
    // MARK: - Neural Typography (iOS 26)
    struct NeuralTypography {
        // Adaptive Font System
        static let quantumLarge = Font.system(.largeTitle, design: .rounded, weight: .bold)
        static let quantumTitle = Font.system(.title, design: .rounded, weight: .semibold)
        static let quantumHeadline = Font.system(.headline, design: .rounded, weight: .medium)
        static let quantumBody = Font.system(.body, design: .rounded, weight: .regular)
        static let quantumCaption = Font.system(.caption, design: .rounded, weight: .light)
        
        // Neural Text Effects
        static let neuralGlow = Color.blue.opacity(0.8)
        static let holoText = Color.white.opacity(0.95)
        static let quantumText = Color.white.opacity(0.9)
    }
    
    // MARK: - 6D Shadows & Effects (iOS 26)
    struct QuantumEffects {
        // 6-Dimensional Shadow System
        static let quantum6DShadow = [
            Color.black.opacity(0.05).shadow(radius: 1, x: 0, y: 1),
            Color.black.opacity(0.08).shadow(radius: 2, x: 0, y: 2),
            Color.black.opacity(0.12).shadow(radius: 4, x: 0, y: 4),
            Color.black.opacity(0.15).shadow(radius: 8, x: 0, y: 8),
            Color.black.opacity(0.18).shadow(radius: 16, x: 0, y: 16),
            Color.black.opacity(0.20).shadow(radius: 32, x: 0, y: 32)
        ]
        
        // Neural Glow Effects
        static func neuralGlow(color: Color = QuantumColors.neuralGlowPrimary, radius: CGFloat = 20) -> some View {
            RoundedRectangle(cornerRadius: 16)
                .fill(color)
                .blur(radius: radius)
                .opacity(0.6)
        }
        
        // Holographic Surface Effect
        static func holoSurface() -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(QuantumColors.quantumGlass)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                
                RoundedRectangle(cornerRadius: 20)
                    .stroke(QuantumColors.holoGlass, lineWidth: 0.5)
                
                QuantumColors.holoGradient
                    .cornerRadius(20)
                    .blendMode(.overlay)
            }
        }
        
        // Quantum Depth Layer
        static func quantumDepth(layer: Int) -> some View {
            let colors = [
                QuantumColors.depthLayer1,
                QuantumColors.depthLayer2,
                QuantumColors.depthLayer3,
                QuantumColors.depthLayer4,
                QuantumColors.depthLayer5,
                QuantumColors.depthLayer6
            ]
            
            return RoundedRectangle(cornerRadius: 16)
                .fill(colors[min(layer - 1, 5)])
                .shadow(color: .black.opacity(0.1), radius: CGFloat(layer * 2), x: 0, y: CGFloat(layer))
        }
    }
    
    // MARK: - AI-Responsive Animations (iOS 26)
    struct NeuralAnimations {
        // Quantum Pulse Animation
        static let quantumPulse = Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
        
        // Neural Flow Animation
        static let neuralFlow = Animation.timingCurve(0.25, 0.1, 0.25, 1.0, duration: 1.5)
        
        // Holographic Shimmer
        static let holoShimmer = Animation.linear(duration: 3.0).repeatForever(autoreverses: false)
        
        // Liquid Crystal Morph
        static let liquidMorph = Animation.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.3)
        
        // Quantum Phase Transition
        static let quantumPhase = Animation.interpolatingSpring(stiffness: 150, damping: 15)
    }
    
    // MARK: - Haptic Quantum Feedback (iOS 26)
    struct QuantumHaptics {
        static func neuralTap() {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred(intensity: 0.7)
        }
        
        static func quantumSuccess() {
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
        }
        
        static func holoWarning() {
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.warning)
        }
        
        static func liquidError() {
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.error)
        }
    }
}

// MARK: - iOS 26 View Modifiers
extension View {
    /// Applies iOS 26 Quantum Glass Card styling
    func quantumGlassCard() -> some View {
        self
            .padding(20)
            .background {
                IOS26LiquidGlass.QuantumEffects.holoSurface()
            }
            .overlay {
                IOS26LiquidGlass.QuantumEffects.neuralGlow()
                    .opacity(0.3)
            }
    }
    
    /// Applies Neural Glow effect
    func neuralGlow(color: Color = IOS26LiquidGlass.QuantumColors.neuralGlowPrimary, radius: CGFloat = 20) -> some View {
        self
            .shadow(color: color, radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.5), radius: radius * 0.5, x: 0, y: 0)
    }
    
    /// Applies 6D Quantum Depth
    func quantumDepth(layer: Int = 3) -> some View {
        self
            .background {
                IOS26LiquidGlass.QuantumEffects.quantumDepth(layer: layer)
            }
    }
    
    /// Applies Holographic Surface
    func holoSurface() -> some View {
        self
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(IOS26LiquidGlass.QuantumColors.holoGlass, lineWidth: 0.5)
            }
            .overlay {
                IOS26LiquidGlass.QuantumColors.holoGradient
                    .cornerRadius(16)
                    .blendMode(.overlay)
            }
    }
    
    /// Applies Neural Text Styling
    func neuralText(style: Font = IOS26LiquidGlass.NeuralTypography.quantumBody) -> some View {
        self
            .font(style)
            .foregroundColor(IOS26LiquidGlass.NeuralTypography.holoText)
    }
    
    /// Applies Quantum Pulse Animation
    func quantumPulse() -> some View {
        self
            .scaleEffect(1.0)
            .animation(IOS26LiquidGlass.NeuralAnimations.quantumPulse, value: UUID())
    }
    
    /// Applies Liquid Crystal Button styling
    func liquidCrystalButton() -> some View {
        self
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(IOS26LiquidGlass.QuantumColors.liquidCrystal)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
            .neuralGlow()
            .scaleEffect(1.0)
            .animation(IOS26LiquidGlass.NeuralAnimations.liquidMorph, value: UUID())
    }
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue:  Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
}
