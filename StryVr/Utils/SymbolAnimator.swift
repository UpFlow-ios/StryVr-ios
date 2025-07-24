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
