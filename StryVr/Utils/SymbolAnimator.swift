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
    var type: SymbolEffect

    func body(content: Content) -> some View {
        if animate {
            content
                .symbolEffect(type)
                .animation(.easeInOut(duration: 0.4), value: animate)
        } else {
            content
        }
    }
}

extension View {
    func animateSymbol(_ animate: Bool, type: SymbolEffect = .bounce) -> some View {
        self.modifier(SymbolAnimator(animate: animate, type: type))
    }
}
