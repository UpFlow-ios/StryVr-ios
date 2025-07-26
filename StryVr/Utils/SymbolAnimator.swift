//
//  SymbolAnimator.swift
//  StryVr
//
//  Created for July 2025 Apple HIG compliance.
//  Provides a reusable ViewModifier and .animateSymbol() extension for animating SF Symbols in SwiftUI.
//  Use for all system icons that require stateful or on-appear animation. See AGENTS.md for standards.
//

import SwiftUI

struct SymbolAnimator: ViewModifier {
    var animate: Bool
    var type: String

    func body(content: Content) -> some View {
        if animate {
            #if os(iOS)
                if #available(iOS 17.0, *) {
                    switch type {
                    case "bounce":
                        content.symbolEffect(.bounce)
                    case "pulse":
                        content.symbolEffect(.pulse)
                    case "variableColor":
                        content.symbolEffect(.variableColor)
                    case "replace":
                        content.symbolEffect(.replace)
                    default:
                        content.symbolEffect(.bounce)
                    }
                } else {
                    // Fallback for iOS 16 and earlier
                    content.scaleEffect(animate ? 1.1 : 1.0)
                        .animation(
                            .easeInOut(duration: 0.3).repeatCount(1, autoreverses: true),
                            value: animate)
                }
            #else
                content
            #endif
        } else {
            content
        }
    }
}

extension View {
    func animateSymbol(_ animate: Bool, type: String = "bounce") -> some View {
        self.modifier(SymbolAnimator(animate: animate, type: type))
    }
}
