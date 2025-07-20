//
//  ThemeManager.swift
//  StryVr
//
//  Created by Joe Dormond on 3/7/25.
//  🎨 Centralized Theme Config for Layout, Fonts, Colors & Shadows
//  🌟 Enhanced with Liquid Glass UI & Premium Visual Effects
//

import SwiftUI

/// Global Theme Configuration used throughout StryVr
enum Theme {
    // MARK: - Color Palette (Asset-based)

    /// Defines the app's primary color palette, with optional fallbacks.
    enum Colors {
        static let safeTextPrimary = Color("TextPrimaryColor")
        static let safeTextSecondary = Color("TextSecondaryColor")
        static let background = Color("BackgroundColor")
        static let textPrimary = Color("TextPrimaryColor")
        static let textSecondary = Color("TextSecondaryColor")
        static let accent = Color("AccentColor")
        static let whiteText = Color.white  // ✅ Add this to fix missing 'whiteText'
        static let card = Color("Card")

        // MARK: - Liquid Glass UI Colors
        static let glassPrimary = Color.blue.opacity(0.8)
        static let glassSecondary = Color.purple.opacity(0.6)
        static let glassAccent = Color.cyan.opacity(0.7)
        static let glowPrimary = Color.blue.opacity(0.3)
        static let glowSecondary = Color.purple.opacity(0.2)
        static let glowAccent = Color.cyan.opacity(0.25)

        /// Fallbacks (optional)
        enum Fallback {
            static let primary = Color(hex: "#4FC3F7")
            static let background = Color(hex: "#0D0D0D")
            static let textPrimary = Color.white
            static let textSecondary = Color(hex: "#AAAAAA")
            static let accent = Color(hex: "#FF4081")
            static let card = Color(hex: "#1A1A1A")
        }
    }

    // MARK: - Typography (Apple HIG + Rounded)

    /// Defines the app's typography styles for consistent text appearance.
    enum Typography {
        static let headline = Font.system(size: 24, weight: .bold, design: .rounded)
        static let subheadline = Font.system(size: 20, weight: .medium, design: .rounded)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let caption = Font.system(size: 14, weight: .light, design: .default)
        static let buttonText = Font.system(size: 18, weight: .semibold, design: .rounded)
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
        static func cardStyle() -> some ViewModifier {
            return ViewModifier { content in
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
        static func buttonStyle() -> some ViewModifier {
            return ViewModifier { content in
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
        static func glowEffect(color: Color = Theme.Colors.glowPrimary) -> some ViewModifier {
            return ViewModifier { content in
                content
                    .shadow(color: color, radius: 8, x: 0, y: 4)
                    .shadow(color: color.opacity(0.5), radius: 16, x: 0, y: 8)
            }
        }

        /// Depth blur background
        static func depthBlur() -> some ViewModifier {
            return ViewModifier { content in
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
    func liquidGlassCard() -> some View {
        self.modifier(Theme.LiquidGlass.cardStyle())
    }

    /// Apply Liquid Glass button styling
    func liquidGlassButton() -> some View {
        self.modifier(Theme.LiquidGlass.buttonStyle())
    }

    /// Apply glow effect
    func liquidGlassGlow(color: Color = Theme.Colors.glowPrimary) -> some View {
        self.modifier(Theme.LiquidGlass.glowEffect(color: color))
    }

    /// Apply depth blur background
    func liquidGlassDepth() -> some View {
        self.modifier(Theme.LiquidGlass.depthBlur())
    }
}
