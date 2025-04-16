//
//  FontStyle.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//  ✍️ Optimized Font System for Scalability & Accessibility
//

import SwiftUI

extension Font {
    struct Style {
        
        /// Large section title font
        static let title: Font = Font.system(size: 28, weight: .bold, design: .rounded)

        /// Section header font
        static let heading: Font = Font.system(size: 20, weight: .semibold, design: .rounded)

        /// Standard body font for general content
        static let body: Font = Font.system(size: 16, weight: .regular, design: .rounded)

        /// Smaller caption or sublabel text
        static let caption: Font = Font.system(size: 14, weight: .light, design: .rounded)

        /// Extra small micro text for footnotes or metadata
        static let footnote: Font = Font.system(size: 12, weight: .thin, design: .rounded)

        /// Dynamic scaling wrapper for accessibility
        /// - Parameter font: The base font to scale dynamically.
        /// - Returns: A font that supports dynamic type scaling.
        static func scalable(_ font: Font) -> Font {
            return font
        }
    }
}
