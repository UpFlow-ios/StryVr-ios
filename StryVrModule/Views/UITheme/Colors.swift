//
//  Color+Theme.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//  🎨 Optimized Color System for Performance & HIG Compliance
//

import SwiftUI

extension Color {

    // MARK: - Hex initializer with optional opacity
    /// Initializes a `Color` from a hex string with optional opacity.
    /// - Parameters:
    ///   - hex: The hex string representing the color (e.g., "#FFFFFF").
    ///   - opacity: The opacity of the color (default is 1.0).
    init(hex: String, opacity: Double = 1.0) {
        let cleanedHex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&int)

        let r, g, b: Double
        switch cleanedHex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255.0
            g = Double((int >> 8) & 0xFF) / 255.0
            b = Double(int & 0xFF) / 255.0
        default:
            r = 0.0
            g = 0.0
            b = 0.0
            os_log("⚠️ Invalid hex string: %{public}@", log: .default, type: .error, hex)
        }

        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }

    // MARK: - App Color Palette (HIG & Accessibility Compliant)
    /// App-wide color palette using asset catalog colors.
    static let background = Color("Background")       // Use asset catalog colors
    static let card = Color("Card")
    static let neonBlue = Color("NeonBlue")
    static let lightGray = Color("LightGray")
    static let whiteText = Color("WhiteText")
}

// MARK: - Preview colors (Fallback defaults if assets fail)
extension Color {
    struct Fallback {
        /// Fallback colors for previews or when asset catalog colors are unavailable.
        static let background = Color(hex: "#0D0D0D")
        static let card = Color(hex: "#1A1A1A")
        static let neonBlue = Color(hex: "#4FC3F7")
        static let lightGray = Color(hex: "#AAAAAA")
        static let whiteText = Color.white
    }
}
