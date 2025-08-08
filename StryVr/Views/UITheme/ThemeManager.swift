//
//  ThemeManager.swift
//  StryVr
//
//  Created by Joe Dormond on 3/7/25.
//  🎨 Centralized Theme Config for Layout, Fonts, Colors & Shadows
//  🌟 Enhanced with iOS 26 Quantum Liquid Glass UI & Neural Visual Effects
//
//  🌀 Animated SF Symbols: All SF Symbol icons should use the .animateSymbol() modifier from Utils/SymbolAnimator.swift for stateful or on-appear animation, per July 2025 Apple HIG. See AGENTS.md for details.
//

import SwiftUI

/// Global Theme Configuration used throughout StryVr
/// Now featuring iOS 26 Quantum Liquid Glass UI
struct Theme {
    // MARK: - Color Palette (Liquid Glass + Apple Glow UI)

    /// Defines the app's primary color palette for Liquid Glass UI.
    struct Colors {
        // Dark Gradient Background Colors (from mockup)
        static let deepNavyBlue = Color(hex: "#0F2027")
        static let softCharcoalGray = Color(hex: "#203A43")
        static let subtleLightGray = Color(hex: "#2C5364")

        // Text Colors
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.7)
        static let textTertiary = Color.white.opacity(0.5)

        // Glass Effect Colors
        static let glassPrimary = Color.white.opacity(0.15)
        static let glassSecondary = Color.white.opacity(0.08)
        static let glassAccent = Color.white.opacity(0.12)

        // Glow Colors (Apple Glow UI)
        static let glowPrimary = Color.blue.opacity(0.4)
        static let glowSecondary = Color.purple.opacity(0.4)
        static let glowAccent = Color.blue.opacity(0.5)
        static let glowGreen = Color.green.opacity(0.5)
        static let glowOrange = Color.orange.opacity(0.5)
        static let glowYellow = Color.yellow.opacity(0.5)
        static let glowPink = Color.pink.opacity(0.5)

        // Neon Accent Colors
        static let neonBlue = Color(hex: "#4FC3F7")
        static let neonGreen = Color(hex: "#4CAF50")
        static let neonOrange = Color(hex: "#FF9800")
        static let neonYellow = Color(hex: "#FFEB3B")
        static let neonPink = Color(hex: "#E91E63")

        // Legacy support
        static let card = Color(.systemGray6)
        static let background = Color(.systemBackground)
        static let accent = Color.blue
        static let whiteText = Color.white
        static let lightGray = Color(.systemGray3)
    }

    // MARK: - Typography (SF Pro Rounded + Apple HIG) with Dynamic Type Support

    /// Professional typography with comprehensive Dynamic Type and accessibility support
    struct Typography {
        // Base Dynamic Type fonts (automatically scale with user preferences)
        static let headline = Font.headline.weight(.bold)
        static let body = Font.body.weight(.medium)
        static let caption = Font.caption.weight(.regular)
        static let subheadline = Font.subheadline.weight(.semibold)
        static let buttonText = Font.body.weight(.semibold)
        static let title = Font.title.weight(.bold)
        static let largeTitle = Font.largeTitle.weight(.bold)
        
        // Professional business app hierarchy
        struct Professional {
            static let resumeTitle = Font.title.weight(.bold)
            static let sectionHeader = Font.headline.weight(.semibold)
            static let skillName = Font.subheadline.weight(.medium)
            static let metricValue = Font.title2.weight(.bold)
            static let description = Font.body.weight(.regular)
            static let timestamp = Font.caption.weight(.medium)
            static let navigationTitle = Font.title2.weight(.semibold)
            static let cardTitle = Font.headline.weight(.medium)
        }
        
        // Accessibility-enhanced text styles
        struct Accessible {
            static let primaryButton = Font.body.weight(.semibold)
            static let secondaryButton = Font.body.weight(.medium)
            static let dataLabel = Font.subheadline.weight(.medium)
            static let dataValue = Font.title3.weight(.semibold)
            static let alertText = Font.body.weight(.medium)
            static let helpText = Font.caption.weight(.regular)
        }
        
        // Chart and data visualization typography
        struct Charts {
            static let axisLabel = Font.caption.weight(.medium)
            static let dataPoint = Font.caption2.weight(.regular)
            static let chartTitle = Font.subheadline.weight(.semibold)
            static let legendText = Font.caption.weight(.regular)
        }
    }

    // MARK: - Corner Radius (20pt as per mockup)

    /// Defines corner radius values for consistent UI layout.
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 20  // Updated to match mockup
        static let card: CGFloat = 20  // Card border radius from mockup
    }

    // MARK: - Shadow & Glow Effects

    /// Defines shadow and glow effects for Liquid Glass UI.
    enum Shadows {
        static let light = Color.black.opacity(0.1)
        static let medium = Color.black.opacity(0.2)
        static let dark = Color.black.opacity(0.4)

        // Glass glow effects
        static let glassGlow = Color.white.opacity(0.1)
        static let glassGlowRadius: CGFloat = 10
        static let glassGlowX: CGFloat = 0
        static let glassGlowY: CGFloat = 4
    }

    // MARK: - Spacing Tokens

    /// Defines spacing values for consistent layout spacing.
    enum Spacing {
        static let xSmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xLarge: CGFloat = 32
    }

    // MARK: - iOS 18 Liquid Glass UI Effects

    /// Defines iOS 18 Liquid Glass UI styling with backward compatibility.
    enum LiquidGlass {
        /// Dark gradient background (from mockup)
        static var background: LinearGradient {
            LinearGradient(
                colors: [
                    Theme.Colors.deepNavyBlue,
                    Theme.Colors.softCharcoalGray,
                    Theme.Colors.subtleLightGray
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }

        /// iOS 18 Glass Effect with backward compatibility
        @available(iOS 18.0, *)
        static var glassEffect: Glass {
            .regular
        }

        /// iOS 18 Glass Effect with tint for backward compatibility
        @available(iOS 18.0, *)
        static func glassEffect(tint: Color) -> Glass {
            .regular.tint(tint)
        }

        /// iOS 18 Interactive Glass Effect for backward compatibility
        @available(iOS 18.0, *)
        static var interactiveGlassEffect: Glass {
            .regular.interactive()
        }

        /// Ultra-thin material background with depth blur (iOS 16+ fallback)
        static var ultraThinBackground: some View {
            Rectangle()
                .fill(.ultraThinMaterial)
        }

        /// Card styling with iOS 18 Glass Effect or fallback (20pt border radius)
        struct CardStyle: ViewModifier {
            func body(content: Content) -> some View {
                if #available(iOS 18.0, *) {
                    applyIOS18CardStyle(to: content)
                } else {
                    applyIOS16CardStyle(to: content)
                }
            }

            @available(iOS 18.0, *)
            private func applyIOS18CardStyle(to content: Content) -> some View {
                content
                    .glassEffect(
                        .regular, in: RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                    )
                    .overlay(createCardBorder())
                    .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.card))
            }

            private func applyIOS16CardStyle(to content: Content) -> some View {
                content
                    .background(.ultraThinMaterial)
                    .background(createCardBackground())
                    .overlay(createCardBorder())
                    .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.card))
            }

            private func createCardBorder() -> some View {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                    .stroke(
                        LinearGradient(
                            colors: [Theme.Colors.glassPrimary, Theme.Colors.glassSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }

            private func createCardBackground() -> some View {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                    .fill(.ultraThinMaterial)
                    .shadow(
                        color: Theme.Shadows.glassGlow,
                        radius: Theme.Shadows.glassGlowRadius,
                        x: Theme.Shadows.glassGlowX,
                        y: Theme.Shadows.glassGlowY
                    )
            }
        }

        /// Button styling with iOS 18 Glass Effect or fallback
        struct ButtonStyle: ViewModifier {
            func body(content: Content) -> some View {
                if #available(iOS 18.0, *) {
                    applyIOS18ButtonStyle(to: content)
                } else {
                    applyIOS16ButtonStyle(to: content)
                }
            }
            
            @available(iOS 18.0, *)
            private func applyIOS18ButtonStyle(to content: Content) -> some View {
                content
                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
                    .overlay(createButtonBorder())
                    .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
            }
            
            private func applyIOS16ButtonStyle(to content: Content) -> some View {
                content
                    .background(.ultraThinMaterial)
                    .background(createButtonBackground())
                    .overlay(createButtonBorder())
                    .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
            }
            
            private func createButtonBorder() -> some View {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(
                        LinearGradient(
                            colors: [Theme.Colors.glassAccent, Theme.Colors.glassPrimary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            }
            
            private func createButtonBackground() -> some View {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Theme.Colors.glowAccent, radius: 6, x: 0, y: 3)
            }
        }

        /// Enhanced glow effect for interactive elements
        struct GlowEffect: ViewModifier {
            let color: Color
            let radius: CGFloat
            let intensity: Double

            init(
                color: Color = Theme.Colors.glowPrimary,
                radius: CGFloat = 8,
                intensity: Double = 1.0
            ) {
                self.color = color
                self.radius = radius
                self.intensity = intensity
            }

            func body(content: Content) -> some View {
                content
                    .shadow(color: color.opacity(intensity), radius: radius, x: 0, y: 4)
                    .shadow(color: color.opacity(intensity * 0.5), radius: radius * 2, x: 0, y: 8)
            }
        }

        /// Neon glow effect for emoji buttons and achievements
        struct NeonGlowEffect: ViewModifier {
            let color: Color
            let pulse: Bool

            init(color: Color, pulse: Bool = false) {
                self.color = color
                self.pulse = pulse
            }

            func body(content: Content) -> some View {
                content
                    .shadow(color: color, radius: 8, x: 0, y: 4)
                    .shadow(color: color.opacity(0.6), radius: 16, x: 0, y: 8)
                    .shadow(color: color.opacity(0.3), radius: 24, x: 0, y: 12)
                    .scaleEffect(pulse ? 1.1 : 1.0)
                    .animation(
                        pulse
                            ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true)
                            : .default, value: pulse)
            }
        }

        /// iOS 18 Glass Effect Container with fallback
        struct GlassContainer: ViewModifier {
            let spacing: CGFloat

            init(spacing: CGFloat = 20.0) {
                self.spacing = spacing
            }

            func body(content: Content) -> some View {
                if #available(iOS 18.0, *) {
                    GlassEffectContainer(spacing: spacing) {
                        content
                    }
                } else {
                    // iOS 16+ fallback - use regular container
                    VStack(spacing: spacing) {
                        content
                    }
                }
            }
        }

        /// Depth blur background
        struct DepthBlur: ViewModifier {
            func body(content: Content) -> some View {
                if #available(iOS 18.0, *) {
                    content
                        .glassEffect(.regular)
                } else {
                    content
                        .background(.ultraThinMaterial)
                        .background(
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .blur(radius: 20)
                        )
                }
            }
        }

        /// Navigation bar glass background
        struct NavigationGlass: ViewModifier {
            func body(content: Content) -> some View {
                if #available(iOS 18.0, *) {
                    content
                        .glassEffect(.regular)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Theme.Colors.glassPrimary)
                                .offset(y: -0.5)
                        )
                } else {
                    content
                        .background(.ultraThinMaterial)
                        .background(
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .shadow(color: Theme.Shadows.glassGlow, radius: 5, x: 0, y: 2)
                        )
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Theme.Colors.glassPrimary)
                                .offset(y: -0.5)
                        )
                }
            }
        }
    }
}

// MARK: - View Extensions for iOS 18 Liquid Glass UI

extension View {
    /// Apply iOS 18 Liquid Glass card styling with fallback (20pt border radius)
    func liquidGlassCard() -> ModifiedContent<Self, Theme.LiquidGlass.CardStyle> {
        self.modifier(Theme.LiquidGlass.CardStyle())
    }

    /// Apply iOS 18 Liquid Glass button styling with fallback
    func liquidGlassButton() -> ModifiedContent<Self, Theme.LiquidGlass.ButtonStyle> {
        self.modifier(Theme.LiquidGlass.ButtonStyle())
    }

    /// Apply iOS 18 Glass Effect directly (iOS 18+ only)
    @available(iOS 18.0, *)
    func glassEffect(_ glass: Glass, in shape: some Shape = Capsule()) -> some View {
        self.glassEffect(glass, in: shape)
    }

    /// Apply iOS 18 Glass Effect with tint (iOS 18+ only)
    @available(iOS 18.0, *)
    func glassEffect(tint: Color, in shape: some Shape = Capsule()) -> some View {
        self.glassEffect(.regular.tint(tint), in: shape)
    }

    /// Apply iOS 18 Interactive Glass Effect (iOS 18+ only)
    @available(iOS 18.0, *)
    func interactiveGlassEffect(in shape: some Shape = Capsule()) -> some View {
        self.glassEffect(.regular.interactive(), in: shape)
    }

    /// Apply enhanced glow effect
    func liquidGlassGlow(
        color: Color = Theme.Colors.glowPrimary,
        radius: CGFloat = 8,
        intensity: Double = 1.0
    ) -> ModifiedContent<Self, Theme.LiquidGlass.GlowEffect> {
        self.modifier(
            Theme.LiquidGlass.GlowEffect(color: color, radius: radius, intensity: intensity))
    }

    /// Apply neon glow effect for emoji buttons and achievements
    func neonGlow(color: Color, pulse: Bool = false) -> ModifiedContent<
        Self, Theme.LiquidGlass.NeonGlowEffect
    > {
        self.modifier(Theme.LiquidGlass.NeonGlowEffect(color: color, pulse: pulse))
    }
    
    /// iOS 26 Quantum Glass Card with Neural Glow
    func quantumGlassCard() -> some View {
        self
            .padding(20)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
                        }
                    
                    // Neural Glow Layer (iOS 26)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue.opacity(0.03))
                        .blur(radius: 25)
                    
                    // Quantum Depth (6D Shadow System)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.01))
                        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
                        .shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: 8)
                        .shadow(color: .blue.opacity(0.2), radius: 32, x: 0, y: 0)
                }
            }
    }

    /// Apply iOS 18 Glass Effect Container with fallback
    func glassContainer(spacing: CGFloat = 20.0) -> ModifiedContent<
        Self, Theme.LiquidGlass.GlassContainer
    > {
        self.modifier(Theme.LiquidGlass.GlassContainer(spacing: spacing))
    }

    /// Apply depth blur background with iOS 18 Glass Effect
    func liquidGlassDepth() -> ModifiedContent<Self, Theme.LiquidGlass.DepthBlur> {
        self.modifier(Theme.LiquidGlass.DepthBlur())
    }

    /// Apply navigation glass background with iOS 18 Glass Effect
    func navigationGlass() -> ModifiedContent<Self, Theme.LiquidGlass.NavigationGlass> {
        self.modifier(Theme.LiquidGlass.NavigationGlass())
    }
}

// MARK: - iOS 18 Glass Effect Convenience Extensions

@available(iOS 18.0, *)
extension View {
    /// Apply glass effect to any view with custom shape
    func glassEffect<Shape: SwiftUI.Shape>(_ glass: Glass, in shape: Shape) -> some View {
        self.glassEffect(glass, in: shape)
    }

    /// Apply glass effect with custom transition
    func glassEffectTransition(_ transition: GlassEffectTransition) -> some View {
        self.glassEffectTransition(transition)
    }

    /// Apply glass effect ID for animation grouping
    func glassEffectID<ID: Hashable>(_ id: ID, in namespace: Namespace.ID) -> some View {
        self.glassEffectID(id, in: namespace)
    }

    /// Apply glass effect union for combining effects
    func glassEffectUnion<ID: Hashable>(id: ID, namespace: Namespace.ID) -> some View {
        self.glassEffectUnion(id: id, namespace: namespace)
    }
    
    /// Premium glass card with interactive effects
    func premiumGlassCard() -> some View {
        self
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: Theme.CornerRadius.card))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    /// Navigation glass for top-level navigation
    func navigationGlassEffect() -> some View {
        self
            .glassEffect(.regular.tint(.blue.opacity(0.1)), in: RoundedRectangle(cornerRadius: 0))
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.white.opacity(0.2)),
                alignment: .bottom
            )
    }
}
