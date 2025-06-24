//
//  Spacing.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//  📐 Optimized Global Spacing Constants for Layout Consistency
//

import SwiftUI

extension CGFloat {
    /// A collection of global spacing constants for consistent layout design.
    enum Spacing {
        /// Small spacing (used for padding/margins in tight areas)
        static let small: CGFloat = 8

        /// Medium spacing (standard spacing between components)
        static let medium: CGFloat = 16

        /// Large spacing (used for major sections or card padding)
        static let large: CGFloat = 24

        /// Extra-large spacing (hero sections, wide paddings)
        static let extraLarge: CGFloat = 32

        /// Ultra spacing (used rarely — large headers or deep padding)
        static let extraExtraLarge: CGFloat = 40
    }
}
