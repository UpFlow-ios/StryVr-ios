//
//  ThemeManager.swift
//  StryVr
//
//  Created by Joe Dormond on 3/7/25.
//
import SwiftUI

/// Centralized theme management for StryVr.
struct Theme {
    
    // MARK: - Colors
    /// Color definitions for the app theme.
    struct Colors {
        static let primary = Color("PrimaryColor") // Use Assets.xcassets
        static let secondary = Color("SecondaryColor")
        static let background = Color("BackgroundColor")
        static let textPrimary = Color("TextPrimaryColor")
        static let textSecondary = Color("TextSecondaryColor")
        static let accent = Color("AccentColor")
    }

    // MARK: - Typography
    /// Font definitions for the app theme.
    struct Typography {
        static let headline = Font.system(size: 24, weight: .bold, design: .rounded)
        static let subheadline = Font.system(size: 20, weight: .medium, design: .rounded)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let caption = Font.system(size: 14, weight: .light, design: .default)
        static let buttonText = Font.system(size: 18, weight: .semibold, design: .rounded)
    }
    
    // MARK: - Corner Radius
    /// Corner radius definitions for the app theme.
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }

    // MARK: - Shadows
    /// Shadow definitions for the app theme.
    struct Shadows {
        static let light = Color.black.opacity(0.1)
        static let medium = Color.black.opacity(0.2)
        static let dark = Color.black.opacity(0.4)
    }
}
