import SwiftUI

extension Color {
    /// Initialize a Color from a hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        switch hex.count {
        case 6: // RGB (24-bit)
            r = Double((int >> 16) & 0xFF) / 255.0
            g = Double((int >> 8) & 0xFF) / 255.0
            b = Double(int & 0xFF) / 255.0
        default:
            r = 0
            g = 0
            b = 0
        }
        self.init(red: r, green: g, blue: b)
    }

    static let background = Color(hex: "#0D0D0D")        // Deep black background
    static let card = Color(hex: "#1A1A1A")              // Dark gray card backgrounds
    static let neonBlue = Color(hex: "#4FC3F7")          // Accent blue
    static let lightGray = Color(hex: "#AAAAAA")         // Text secondary
    static let whiteText = Color.white                   // Primary text
}
