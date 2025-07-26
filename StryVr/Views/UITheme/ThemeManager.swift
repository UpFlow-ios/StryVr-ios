//
//  ThemeManager.swift
//  StryVr
//
//  Created by Joe Dormond on 3/7/25.
//  🎨 Centralized Theme Config for Layout, Fonts, Colors & Shadows
//  🌟 Enhanced with Liquid Glass UI & Premium Visual Effects
//
//  🌀 Animated SF Symbols: All SF Symbol icons should use the .animateSymbol() modifier from Utils/SymbolAnimator.swift for stateful or on-appear animation, per July 2025 Apple HIG. See AGENTS.md for details.
//

import SwiftUI

/// Global Theme Configuration used throughout StryVr
struct Theme {
    // MARK: - Color Palette (Asset-based)

    /// Defines the app's primary color palette, with optional fallbacks.
    struct Colors {
        static let card = Color(.systemGray6)
        static let background = Color(.systemBackground)
        static let accent = Color.blue
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
        static let whiteText = Color.white
        static let lightGray = Color(.systemGray3)

        // Liquid Glass UI Colors
        static let glowPrimary = Color.blue.opacity(0.3)
        static let glowSecondary = Color.purple.opacity(0.3)
        static let glowAccent = Color.blue.opacity(0.4)
        static let glassPrimary = Color.white.opacity(0.1)
        static let glassSecondary = Color.white.opacity(0.05)
        static let glassAccent = Color.blue.opacity(0.1)
    }

    // MARK: - Typography (Apple HIG + Rounded)

    /// Defines the app's typography styles for consistent text appearance.
    struct Typography {
        static let headline = Font.system(size: 20, weight: .bold)
        static let body = Font.system(size: 16)
        static let caption = Font.system(size: 13)
        static let subheadline = Font.system(size: 17, weight: .medium)
        static let buttonText = Font.system(size: 16, weight: .semibold)
        static let title = Font.system(size: 24, weight: .bold)
    }

    // MARK: - Corner Radius (UI Layout Tokens)

    /// Defines corner radius values for consistent UI layout.
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }

    // MARK: - Shadow Opacities

    /// Defines shadow opacity levels for consistent depth effects.
    enum Shadows {
        static let light = Color.black.opacity(0.1)
        static let medium = Color.black.opacity(0.2)
        static let dark = Color.black.opacity(0.4)
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

    // MARK: - Liquid Glass UI Effects

    /// Defines Liquid Glass UI styling for premium visual effects.
    enum LiquidGlass {
        /// Ultra-thin material background with depth blur
        static let background = Rectangle()
            .fill(.ultraThinMaterial)
            .background(.ultraThinMaterial)

        /// Card styling with glass effect and glow
        struct CardStyle: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .background(.ultraThinMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                            .fill(.ultraThinMaterial)
                            .shadow(color: Theme.Colors.glowPrimary, radius: 8, x: 0, y: 4)
                            .shadow(color: Theme.Colors.glowSecondary, radius: 16, x: 0, y: 8)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Theme.Colors.glassPrimary, Theme.Colors.glassSecondary,
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.large))
            }
        }

        /// Button styling with glass effect and glow
        struct ButtonStyle: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .background(.ultraThinMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .fill(.ultraThinMaterial)
                            .shadow(color: Theme.Colors.glowAccent, radius: 6, x: 0, y: 3)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .stroke(
                                LinearGradient(
                                    colors: [Theme.Colors.glassAccent, Theme.Colors.glassPrimary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
            }
        }

        /// Glow effect for interactive elements
        struct GlowEffect: ViewModifier {
            let color: Color

            init(color: Color = Theme.Colors.glowPrimary) {
                self.color = color
            }

            func body(content: Content) -> some View {
                content
                    .shadow(color: color, radius: 8, x: 0, y: 4)
                    .shadow(color: color.opacity(0.5), radius: 16, x: 0, y: 8)
            }
        }

        /// Depth blur background
        struct DepthBlur: ViewModifier {
            func body(content: Content) -> some View {
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
}

// MARK: - View Extensions for Liquid Glass UI

extension View {
    /// Apply Liquid Glass card styling
    func liquidGlassCard() -> ModifiedContent<Self, Theme.LiquidGlass.CardStyle> {
        self.modifier(Theme.LiquidGlass.CardStyle())
    }

    /// Apply Liquid Glass button styling
    func liquidGlassButton() -> ModifiedContent<Self, Theme.LiquidGlass.ButtonStyle> {
        self.modifier(Theme.LiquidGlass.ButtonStyle())
    }

    /// Apply glow effect
    func liquidGlassGlow(color: Color = Theme.Colors.glowPrimary) -> ModifiedContent<
        Self, Theme.LiquidGlass.GlowEffect
    > {
        self.modifier(Theme.LiquidGlass.GlowEffect(color: color))
    }

    /// Apply depth blur background
    func liquidGlassDepth() -> ModifiedContent<Self, Theme.LiquidGlass.DepthBlur> {
        self.modifier(Theme.LiquidGlass.DepthBlur())
    }
}
