//
//  ThemeManager.swift
//  StryVr
//
//  Created by Joe Dormond on 3/7/25.
//  🎨 Centralized Theme Config for Layout, Fonts, Colors & Shadows
//

import SwiftUI

/// Global Theme Configuration used throughout StryVr
struct Theme {
    
    // MARK: - Color Palette (Asset-based)
    /// Defines the app's primary color palette, with optional fallbacks.
    struct Colors {
        static let safeTextPrimary = Color("TextPrimaryColor") ?? Fallback.textPrimary
        static let safeTextSecondary = Color("TextSecondaryColor") ?? Fallback.textSecondary
        static let background = Color("BackgroundColor")
        static let textPrimary = Color("TextPrimaryColor")
        static let textSecondary = Color("TextSecondaryColor")
        static let accent = Color("AccentColor")
        static let whiteText = Color.white // ✅ Add this to fix missing 'whiteText'

        
        /// Fallbacks (optional)
        struct Fallback {
            static let primary = Color(hex: "#4FC3F7")
            static let background = Color(hex: "#0D0D0D")
            static let textPrimary = Color.white
            static let textSecondary = Color(hex: "#AAAAAA")
            static let accent = Color(hex: "#FF4081")
        }
    }

    // MARK: - Typography (Apple HIG + Rounded)
    /// Defines the app's typography styles for consistent text appearance.
    struct Typography {
        static let headline = Font.system(size: 24, weight: .bold, design: .rounded)
        static let subheadline = Font.system(size: 20, weight: .medium, design: .rounded)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let caption = Font.system(size: 14, weight: .light, design: .default)
        static let buttonText = Font.system(size: 18, weight: .semibold, design: .rounded)
    }

    // MARK: - Corner Radius (UI Layout Tokens)
    /// Defines corner radius values for consistent UI layout.
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }

    // MARK: - Shadow Opacities
    /// Defines shadow opacity levels for consistent depth effects.
    struct Shadows {
        static let light = Color.black.opacity(0.1)
        static let medium = Color.black.opacity(0.2)
        static let dark = Color.black.opacity(0.4)
    }

    // MARK: - Spacing Tokens
    /// Defines spacing values for consistent layout spacing.
    struct Spacing {
        static let xSmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xLarge: CGFloat = 32
    }
}
