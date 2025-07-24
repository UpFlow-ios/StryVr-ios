//
//  ConfettiManager.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25.
//  🎉 Central Confetti Manager for Achievements, Streaks & Challenges
//

import ConfettiSwiftUI
import SwiftUI

/// Usage:
/// Bind `.confettiCannon(counter: ConfettiManager.shared.counter, num: 20)` to a view.
/// Call `ConfettiManager.shared.triggerConfetti()` to trigger the animation.

/// Singleton manager to trigger confetti from anywhere in the app
@MainActor
final class ConfettiManager: ObservableObject {
    static let shared = ConfettiManager()

    /// Counter that drives the confetti animation
    @Published var counter: Int = 0

    /// Number of confetti particles to emit (used by views that observe this)
    @Published var numberOfParticles: Int = 20

    /// Placeholder for future customization (e.g., colors or shapes)
    var styleOptions: [String: Any] = [:]

    private init() {}

    /// Call this to launch a confetti burst
    func triggerConfetti(particles: Int? = nil) {
        if let particles = particles {
            self.numberOfParticles = particles
        }
        self.counter += 1
    }
}
